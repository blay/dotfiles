#!/usr/bin/env python3.14

# DEPENDENCIES:

# !!! REQUIRED: python3.12 of later!!!

# OPTIONAL DEPENDENCES
# graphicsmagick (or imagemagick) - for thumbnail generation:
#     ubunbtu/debian: 
#        sudo apt install graphicsmagick
#        OR
#        sudo apt install imagemagick

#     macos: 
#        brew install graphicsmagick
#     OR:
#        brew install imagemagick
#
# Pillow (for EXIF extraction):
#     python3.12 -m pip install -U Pillow
# pillow-heif (for EXIF extraction from HEIC):
#     python3.12 -m pip install pillow-heif

from concurrent.futures import ThreadPoolExecutor
import sys
import re

import shutil
import subprocess
from datetime import datetime
from pathlib import Path

from urllib.parse import quote

if sys.version_info[:2] < (3, 12):
    print('''Python 3.12 or later is required
install python 3.12 on ubuntu:
    sudo add-apt-repository ppa:deadsnakes/ppa
    sudo apt install python3.12

install python 3.12 on macos:
    brew install python@3.12
''')

try:
    from PIL import Image
    import PIL.ExifTags
except ImportError:
    Image = None
    print(f'''❗️ PIL/Pillow not found — EXIF data cannot be extracted.
install missing module with: {Path(sys.executable).name} -m pip install -U Pillow...
Enter to ignore and continue or CTR-C to abort...''')
    input()

try:
    from pillow_heif import register_heif_opener
except ImportError:
    print(f'''❗️ HEIC EXIF data cannot be extracted! 
install missing module with: {Path(sys.executable).name} -m pip install pillow-heif
Enter to ignore and continue or CTR-C to abort...''')
    input()
    register_heif_opener = None

# generate thumbnails only if image size is larger than 50KB
THUMBNAIL_GENERATION_MINIMUM_FILE_SIZE = 50000

# max thread pool size for concurrent thumbnail generation
MAX_THUMBNAIL_GENERATION_WORKERS = 16

# folder to store thumbnails in
THUMBS_DIR = '.thumbs'

# HTML gallery output file
OUTPUT_FILE_NAME = "gal.html"

IMAGE_SVG = ".svg"
IMAGE_HEIC = ".heic"
IMAGE_EXTENSIONS = (".jpg", ".jpeg", IMAGE_HEIC)
# IMAGE_EXTENSIONS = (".jpg", ".jpeg", ".png", ".bmp", ".webp", ".gif", IMAGE_HEIC)
VIDEO_EXTENSIONS = ('.mp4', '.mov', '.mkv')
# AUDIO_EXTENSIONS = ()
# VIDEO_EXTENSIONS = (".mp4", ".mkv", ".webm", ".3gp", ".mov", ".mkv", ".ogv", ".mpg", ".mpeg")
AUDIO_EXTENSIONS = (".mp3", ".ogg", ".wav", ".flac", ".m4a", ".aac")

ASSET_EXTENSIONS = IMAGE_EXTENSIONS + VIDEO_EXTENSIONS + AUDIO_EXTENSIONS

# literal lowercase path segments to ignore (matches intermediate folders too)
IGNORED_PATHS = [
    'cordova',
    'drawable',
    'sqlite/assets',
    'pydictionary-pyvoctr/trunk/pydictionary/pyvoctrainr/img',
    'BraveSoftware/Brave',
    'colorbreathing',
    'PaulsRobot',
    'lear-taiwanese-mandarin',
    'Thumbnails',
    'iCloud~com~apple~iBooks',
    '.DS_Store',
    'site-packages',
    'assets/icons',
    'allsetlearning',
    'goldendict_data',
    'Accupunture/accupunct',
    'Calibre Library',
    'Accupunture/moa',
    'pyvoctrainer',
    'moa5',
    'davx5',
    'deadbeef',
    'mamcom',
    'renditions',
    '_thumb',
    '.config',
    '.thumb',
    'dictionary/Contents',
    '/tests/',
    'zerotohero',
    'panlang',
    'cache/',
    '/projects/python',
    '/Library/Application/',
    '/ubs/',
    '/ubs-'
]

graphics_magick_path = shutil.which('gm')
image_magick_path = shutil.which('convert')  # requires at least python 3.3
total_assets = 0

class Asset:
    def __init__(self, type, relpath, abspath, created_date, html, thumbnail_path=None):
        self.type = type
        self.relpath = relpath
        self.abspath = abspath
        self.created_date = created_date
        self.html = html
        self.thumbnail = thumbnail_path

    def __lt__(self, other) -> bool:
        if self.type == other.type:
            return self.created_date > other.created_date
        return self.type < other.type

def get_exif(file_path: Path) -> dict:

    if Image and file_path.suffix.lower() in IMAGE_EXTENSIONS:
        exif = Image.open(file_path).getexif()
        if exif:
            return {
                PIL.ExifTags.TAGS[k]: v
                for k, v in exif.items()
                if k in PIL.ExifTags.TAGS
            }

def parse_date_from_filename(file_path: Path) -> datetime or None:
    """
    Fuzzily extract a date from a filename like 'YYYY-MM-DD_HH-MM-SS_bla.jpg'
    or random-junk-20140822T202948Z-randjunk
    Return a datetime object on match or otherwise return None.
    """
    # e.g. random-junk-20140822T202948Z-randjunk
    try:
        match = re.search(r"(\d{4})(\d{2})(\d{2})T\d+Z", file_path.stem)

        if match:
            year, month, day = map(int, match.groups())
            parsed_datetime = datetime(year, month, day)
            return parsed_datetime
    except Exception as e:
        print(f"😨 error extracting date from filename: {str(e)} while processing {file_path.absolute()}")

    # e.g. 'YYYY-MM-DD_HH-MM-SS_bla.jpg'
    if len(file_path.stem) > 3 and file_path.stem[:4].isdigit():
        try:
            return datetime.strptime(file_path.stem, "%Y-%m-%d_%H-%M-%S_%f")
        except (ValueError, TypeError):
            try:
                # this is a rough approach and can fail with corner cases, but mostly works
                return datetime(*map(int, re.findall(r'\d+', file_path.stem)[:4]))
            except Exception as e:
                print(f"😨 error extracting date from filename: {str(e)} while processing {file_path.absolute()}")
                return None


def get_created_time(file_path: Path) -> datetime:
    file_stat = file_path.stat()
    try:
        return datetime.fromtimestamp(file_stat.st_birthtime)
    except AttributeError:
        # We are probably on Linux. No way to get the creation date, only the last modification date.
        return datetime.fromtimestamp(file_stat.st_mtime)


UNITS_MAPPING = [
    (1024 ** 5, 'P'),
    (1024 ** 4, 'T'),
    (1024 ** 3, 'G'),
    (1024 ** 2, 'M'),
    (1024 ** 1, 'K'),
    (1024 ** 0, (' byte', ' bytes')),
]


def pretty_size(bytes, units=UNITS_MAPPING) -> str:
    """Human-readable file sizes.

    ripped from https://pypi.python.org/pypi/hurry.filesize/
    """
    for factor, suffix in units:
        if bytes >= factor:
            break
    amount = int(bytes / factor)

    if isinstance(suffix, tuple):
        singular, multiple = suffix
        if amount == 1:
            suffix = singular
        else:
            suffix = multiple
    return str(amount) + suffix


def collect_media_assets(args) -> list[Asset]:
    homedir = Path.expanduser(Path('~'))
    assets: list[Asset] = []
    global total_assets

    for asset_path in args.gallery_root.absolute().rglob("*"):

        ignored_path_fragments = IGNORED_PATHS + args.ignored

        if len([ignored for ignored in ignored_path_fragments if ignored.lower() in str(asset_path.absolute()).lower()]):
            continue

        try:
            if asset_path.is_file() and asset_path.suffix.lower() in ASSET_EXTENSIONS:

                if asset_path.name.startswith('._'):  # skip macos junk
                    continue

                size: int = asset_path.stat().st_size
                size_pretty: str = pretty_size(size)
                exif: dict = get_exif(asset_path)

                created_date: datetime or None = None
                exif_make = ''
                exif_model = ''

                if exif:
                    exif_time = exif.get('DateTimeOriginal') or exif.get('DateTime')

                    if exif_time:
                        created_date = datetime.strptime(exif_time, "%Y:%m:%d %H:%M:%S")
                        if args.verbose:
                            print(f'🌅 EXIF create date: {created_date}')

                    exif_make = exif.get('Make') or ''
                    exif_model = exif.get('Model') or ''

                if not created_date:
                    created_date = parse_date_from_filename(asset_path)

                if not created_date:
                    created_date = get_created_time(asset_path)

                created_date_formatted = created_date.strftime("%Y-%m-%d %H:%M:%S")
                relative_path = str(asset_path.relative_to(args.gallery_root.absolute()))
                escaped_path = quote(relative_path, safe='/')

                if asset_path.suffix.lower() == IMAGE_SVG:
                    assets.append(Asset(type='svg',
                                        relpath=relative_path,
                                        abspath=asset_path,
                                        created_date=created_date,
                                        html=f"""<a class="item" href="{escaped_path}" target="_blank" title="{relative_path} size: {size_pretty}; created: {created_date_formatted}">
                        <img src="{relative_path}" loading="lazy">
                    </a>"""))
                elif asset_path.suffix.lower() in IMAGE_EXTENSIONS:
                    segment = str(args.gallery_root.absolute()).replace(str(homedir), '').lstrip('/')

                    # only generate thumbnails if file size is bigger than 50KB and imagemagick is installed
                    if not args.no_thumbnails and (image_magick_path or graphics_magick_path) and size >= THUMBNAIL_GENERATION_MINIMUM_FILE_SIZE:
                        thumbnail_path: Path = Path.expanduser(args.thumbs_dir).absolute() / segment / relative_path

                        if asset_path.suffix.lower() == IMAGE_HEIC:
                            thumbnail_path = thumbnail_path.with_suffix(".jpg")
                    else:
                        thumbnail_path: Path = asset_path

                    thumbnail_path_relative = thumbnail_path.relative_to(args.gallery_root.absolute(), walk_up=True)  ## IMPORTANT: REQUIRED python 3.12 minimum!
                    thumbnail_path_relative_escaped = quote(str(thumbnail_path_relative), safe='/')

                    assets.append(Asset(type='image',
                                        relpath=relative_path,
                                        abspath=asset_path,
                                        created_date=created_date,
                                        html=f"""<a class="item" href="{escaped_path}" target="_blank" title="{relative_path} size: {size_pretty}; created: {created_date_formatted}">
                        <img src="{thumbnail_path_relative_escaped}" loading="lazy">
                        <span class="meta">{created_date} {exif_make} {exif_model} ({size_pretty})</span>
                    </a>""", thumbnail_path=thumbnail_path))

                elif args.videos and asset_path.suffix.lower() in VIDEO_EXTENSIONS:

                    if args.video_preload:
                        markup = f"""<a class="item" href="{escaped_path}" target="_blank" title="{relative_path} size: {size_pretty}; created: {created_date_formatted}">
                        <video preload="metadata" controls><source src="{escaped_path}#t=0.1"></video>{asset_path.name}
                        <span class="meta">({size_pretty})</span>
                    </a>"""
                    else:
                        markup = f"""<a class="item" href="{escaped_path}" target="_blank" title="{relative_path} size: {size_pretty}; created: {created_date_formatted}">
                        <video preload="none" controls><source src="{escaped_path}"></video>{asset_path.name}
                        <span class="meta">({size_pretty})</span>
                    </a>"""

                    assets.append(Asset(type='video',
                                        relpath=relative_path,
                                        abspath=asset_path,
                                        created_date=created_date,
                                        html=markup))

                elif args.audios and asset_path.suffix.lower() in AUDIO_EXTENSIONS:
                    assets.append(Asset(type='audio',
                                        relpath=relative_path,
                                        abspath=asset_path,
                                        created_date=created_date,
                                        html=f"""<a class="item" href="{escaped_path}" target="_blank" title="{relative_path} size: {size_pretty}; created: {created_date_formatted}">
                        &#x25B6;&#xFE0F; {asset_path.name}<span class="meta">({size_pretty})</span>
                    </a>"""))

                if args.verbose:
                    print(f'{asset_path}')
                total_assets += 1

                if total_assets % 42:
                    print(f'Processed:     {total_assets}     {asset_path.name}         ', end='\r')
        except Exception as e:
            print(f'💥 ERROR: {str(e)} - {asset_path.absolute()}')
    return assets


def generate_gallery_html(html_data, args:object):
    with (args.gallery_root / args.output_file).open(mode="w", encoding="utf-8") as fout:
        fout.write(r'''<html>
    <head>'''
                   f'<title>{args.gallery_root.absolute()}</title>'
                   r'''<meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
        * {
            font-family: system-ui, sans-serif;
        }
        body {
            background: #fafafa;
        }
        h1 {
            padding: 2em;
            font-size: 1.36em;
            color: #b3b3b3;
            text-align: center;
            font-family: 'Fira Code', 'JetBrains Mono', monospace;
        }
        #maine {
            display: grid; 
            grid-template-columns: repeat(auto-fill, minmax(11em, 1fr)); 
            gap: 6px;
        }
        .item {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            border-radius: 4px;
            background-color: white;
            /*
            padding: 10px;
            margin: 6px;
            */
            border-width: 0;
            border-style: solid;
            border-color: white;
            box-shadow: 0px 2px 1px -1px rgba(0, 0, 0, .2), 0px 1px 1px 0px rgba(0, 0, 0, .14), 0px 1px 3px 0px rgba(0, 0, 0, .12);
        }
        .item>img, .item>video {
            width: 100%;
            height: auto;
            max-height: 350px;
            display: table-cell;
            border-radius: 5px;
            object-fit: cover;
        }
        a {
            text-decoration: none;
            font-size: 14px;
        }
        a:hover {
            color: #0095e4;
        }

        a:visited {
            color: #800080;
        }

        a:visited:hover {
            color: #b900b9;
        }
        a.nowPlaying {
            color: #000000 !important;
            background: #ff9600;
            border: 1px dotted #d67e00;
            border-radius: 5px;
        }
        
        .overlay {
            position: fixed;
            top: 0;
            bottom: 0;
            left: 0;
            right: 0;
            background: rgba(0, 0, 0, 0.7);
            transition: opacity 500ms;
            z-index: 42;
            display: none;
        }

        .popup,
        #popup1.day .popup,
        #popup1.night .popup {
            margin: 3em auto;
            padding: 20px;
            border-radius: 5px;
            width: 90%;
            height: 90%;
            position: relative;
            transition: all 1s ease-in-out;
        }

        #popup1.day .popup {
            background: #fff;
        }

        #popup1.night .popup {
            background: #000;
        }

        .popup h2 {
            margin-top: 0;
            color: #a19f9f;
            font-family: sans-serif;
            font-size: small;
            text-align: center;
        }

        .popup .max {
            position: absolute;
            top: 10px;
            right: 40px;
            transition: all 200ms;
            font-weight: bold;
            text-decoration: none;
            z-index: 1000;
        }
        .popup .max:hover, .popup .close:hover {
            color: #06D85F;
        }

        .popup .close {
            position: absolute;
            top: 10px;
            right: 10px;
            transition: all 200ms;
            font-weight: bold;
            text-decoration: none;
            z-index: 1000;
        }

        #popup1 .content>img {
            max-width: 100%;
            max-height: 90%;
            margin: auto;
            display: block;
            margin: auto;
            top:0;
            bottom:0;
            left:0;
            right:0;
            position:absolute;
        }

        #popup1.day .popup .close, 
        #popup1.day .popup .max {
            color: #333;
        }

        #popup1.night .popup .close, 
        #popup1.night .popup .max {
            color: #e1e0e0;
        }

        .popup .content {
            height: 100%;
            overflow: auto;
        }

        #popup1.night .popup {
            background-color: black;
        }

        #popup1.day .popup {
            background-color: white;
        }
        .popup video {
            max-width: 100%;
            max-height: 100%;
            width: 100%;
            margin: auto;
            position: absolute;
            left: 0;
            top: 0;
            right: 0;
            bottom: 0;
        }

        .popup video::cue {
            color: #ffffff;
            border: 3px solid black;
            text-align: center;
            text-shadow: -1px -1px 1px rgba(255,255,255,.1), 1px 1px 1px rgba(0,0,0,.5), 2px 2px 3px rgba(206,89,55,0);
            font-size: 1.5vw;
        }

        .fixedplayer {
            display: none;
            text-align: center;
            background: #f1f3f4;
            position: fixed;
            min-width: 67vw;
            width: 100%;
            height: 24px;
            padding: 0;
            top: 0;
            right: 0;
            left:0;
            z-index: 3;
        }

        .fixedplayer #aplayer{
            width: 432px;
            height: 24px;
        }

        .fixedplayer a {
            position: absolute;
            top: 2px;
            transition: all 200ms;
            font-weight: bold;
            text-decoration: none;
            z-index: 1000;
            color: #939393;
        }
        .fixedplayer a:hover {
            color: #f5c400;
        }

        /* prevent body scroll when modal is shown */
        .modal-open {
            touch-action: none;
            -webkit-overflow-scrolling: none;
            overflow: hidden;
            overscroll-behavior: none;
            overflow-x: hidden;
            overflow-y: scroll !important;
            position: fixed;
        }

        .maximized {
                width: 98% !important;
                height: 100% !important;
                margin: auto !important;
        }
        .meta {
            font-size:10px;
            color: #ccc;
        }
        .nowPlaying .meta {
            font-size:10px;
            color: #775f89;            
        }
        @media (max-width: 811px) {
            #maine {
                min-height: 100vh;
                grid-template-columns: repeat(auto-fill, minmax(15em, 1fr)); 
                gap: 3px;
            }
            item.img, item.video {
                max-width: 50vw;
                height: auto;
                display: table-cell;
            }        
        }
        </style>
        <script>
            document.onkeydown = function (e) {
            const v = document.querySelector('.popup video');
            const img = document.querySelector('.popup img');

            switch (e.which) {
                case 27:    // = Escape
                    hideModal();
                    break;
                case 37: // left
                    jumpPrevious(v, img);
                    break;
                case 32: // Space
                    if(e.which == 32){
                    // stops default behaviour of space bar. Stop page scrolling down
                        e.preventDefault();
                        if (v.paused) {
                            v.play();
                        } else {
                            v.pause();
                        }
                    }
                    break;
                case 39: // Right
                    jumpNext(v, img);
                    break;
                case 70: // f-key
                    if (!(e.shiftKey || e.ctrlKey || e.altKey || e.metaKey)) {
                        if (!window.isFs) {
                            window.isFs = true;
                            fullscreenOn(v || img || document);
                        } else {
                            window.isFs = false;
                            fullscreenOff(v || img || document);
                        }
                    }
                    break;
            }
        };

        function fullscreenOn(p) {
            var fs = p.requestFullscreen || p.webkitRequestFullscreen || p.mozRequestFullScreen || p.oRequestFullscreen || p.msRequestFullscreen;
            fs.call(p);
        }

        function fullscreenOff(p) {
            var fsx = p.exitFullScreen || p.webkitExitFullScreen || p.mozExitFullScreen || p.oExitFullScreen || p.msExitFullScreen;
            fsx.call(p);
        }

        function findClosest(el, tagName, className) {
            if (el.tagName === tagName && !className || el.classList.contains(className)) {
                return el;
            } else if (el.parentElement) {
                return findClosest(el.parentElement, tagName, className);
            }
            return null;
        }

        function onDocumentClickHandler(e) {
            const el = e.target;

            let link = el;

            if (link.tagName !== 'A') {
                link = findClosest(link, 'A');
            }

            if (link && (link.matches("a"))) {
                onLinkClicked(link, e);
            } else if (!link && !document.querySelector('#popup1 .popup').contains(el)) {
                hideModal();
            }
        }

        function findNextPrevLink(link, regex, isBackwards) {
            if (isBackwards) {
                return link.previousElementSibling;
            } else {
                return link.nextElementSibling;
            }
        }

const REGEX_TYPE_AUDIO = /\.(mp3|m4a|aac|flac|ape|wav|ogg|oga|webm)$/i;
const REGEX_TYPE_VIDEO = /\.(mp4|m4v|avi|mov|mpg|mpeg|ogv|ogm|opus|mkv)$/i;
const REGEX_TYPE_IMAGE = /\.(gif|jpe?g|a?png|tiff?|bmp|webp|ico|wmf|avif|svg)$/i;
const REGEX_TYPE_CODE = /\.(asp|txt|memo|kt|go|ics|rst?|rb|dart|php|js|tsx?|py|cue|ipynb|z?sh|xml|plist|bat|css|json|java|c|cpp|h|m|hpp|conf|ini|pl|yaml|yml|groovy|swift|properties|gradle|srt|sql|lua|m3u8|log?)$/i;
// const REGEX_TYPE_HTML = /\.(html?)$/i;
const REGEX_TYPE_MARKDOWN = /\.(md)$/i;
const REGEX_TYPE_CAN_PREVIEW = /\.(mp4|m4v|avi|mov|mpg|mpeg|ogv|ogm|opus|mkv|md|html?|gif|jpe?g|a?png|tiff?|bmp|webp|ico|wmf|avif|svg|asp|txt|memo|kt|go|ics|rst?|rb|dart|php|js|tsx?|py|cue|ipynb|z?sh|xml|plist|bat|css|json|java|c|cpp|h|m|hpp|conf|ini|pl|yaml|yml|groovy|swift|properties|gradle|srt|sql|lua|m3u8?)$/i;

function escapeRegex(string) {
    return string.replace(/[/\-\\^$*+?.()|[\]{}]/g, '\\$&');
}

function showModal (popup, popupThemeClass) {
    window.lastScrollOffset = window.pageYOffset;
    document.body.classList.add('modal-open');
    document.body.style.top = `-${window.lastScrollOffsetllY}px`;

    var popup = popup || document.querySelector('#popup1');
    popup.style.display = 'block';

    popup.classList.remove(popupThemeClass === 'day' ? 'night' : 'day');
    popup.classList.add(popupThemeClass);
}

function hideModal (e) {
    if (e) {
        e.stopImmediatePropagation();
        e.preventDefault();
    }
    var popup = document.querySelector('#popup1');

    if (popup.style.display !== 'none') {
        popup.style.display = 'none';
        popup.querySelector('.content').innerHTML = '';

        document.body.classList.remove('modal-open');

        if (window.lastScrollOffset){
            window.scrollTo(0, window.lastScrollOffset);
        }
    }
}
function toggleRestoreModal (popup) {
    var popup = popup || document.querySelector('#popup1');
    if (popup.style.display !== 'none') {
        popup.querySelector('.popup').classList.toggle('maximized');
    }
}

function onAudioEnded(el) {
    if (el && window.currentLink) {
        window.currentLink.classList.remove('nowPlaying');
        let nextLink = findNextPrevLink(window.currentLink, REGEX_TYPE_AUDIO);
        const href = nextLink.getAttribute('href');

        if (REGEX_TYPE_AUDIO.test(href)) {
            el.src = href;
            el.play();
            el.title = decodeURIComponent(href);
            nextLink.classList.add('nowPlaying');
            nextLink.scrollIntoView(
                {
                    behavior: "smooth",
                    block: "center"
                }
            );
            window.currentLink = nextLink;
        }
    }
}

function startAudioPlayer(href) {
    const audioPlayer = document.getElementById('aplayer');
        audioPlayer.parentElement.style.display = 'block';
        audioPlayer.src = href;
        audioPlayer.title = decodeURIComponent(href);
        audioPlayer.play();
        document.querySelectorAll('th').forEach((th) => th.classList.toggle('offset'));
}

function hideAudioPlayer() {
    const audioPlayer = document.getElementById('aplayer');
    audioPlayer.pause();
    audioPlayer.parentElement.style.display = 'none';
    document.querySelectorAll('th').forEach((th) => th.classList.toggle('offset'));

    if (window.currentLink) {
        window.currentLink.classList.remove('nowPlaying');
    }
}

function onLinkClicked(link, evt) {
    var href = link.getAttribute("href");

    if (href == '#') {
        return;
    }

    if (window.currentLink && REGEX_TYPE_AUDIO.test(href)) {
        window.currentLink.classList.remove('nowPlaying');
    }
    window.currentLink = link;

    const event = evt || new Event('click');

    const fileName = href.split('/').pop();
    const baseName = fileName.split('.')[0];

    var popup = document.querySelector('#popup1');
    var content = popup.querySelector('.content');
    popup.querySelector('.info').textContent = decodeURIComponent(fileName);

    if (REGEX_TYPE_VIDEO.test(href)) {
        event.preventDefault();
        event.stopImmediatePropagation();

        hideAudioPlayer();
        
        if (link.firstElementChild && !link.firstElementChild.paused) {
            link.firstElementChild.pause();
        }

        const video = document.createElement('video');
        video.setAttribute('autoplay', true);
        video.setAttribute('controls', 'controls');
        video.setAttribute('preload', 'auto');
        video.setAttribute('tabIndex', "-1");

        const source = document.createElement('source');

        source.src = href;
        video.appendChild(source);

        document.querySelectorAll('a').forEach((link) => {
            if (new RegExp(`${baseName}\.?.*\.(vtt|srt)`, 'i').test(link.href)) {
                const track = document.createElement('track');
                loadSubtitle(link.href)
                    .then(url => {
                        track.src = url;
                        track.kind = 'subtitles';
                        track.label = decodeURIComponent(link.href.split('/').pop());
                        track.srclang = 'en';

                        if (!video.hasDefaultSubs) {
                            track.default = true;
                            video.hasDefaultSubs = true;
                        }

                        video.appendChild(track);
                    })
            }
        });

        content.innerHTML = '';
        content.appendChild(video);
        showModal(popup, 'night');

    } else if (REGEX_TYPE_AUDIO.test(href)) {
        event.preventDefault();
        event.stopImmediatePropagation();

        startAudioPlayer(href);
        link.classList.add('nowPlaying');
    }
    // special treatment by extension
    else if (REGEX_TYPE_MARKDOWN.test(href) || REGEX_TYPE_CODE.test(href)) {
        event.preventDefault();
        event.stopImmediatePropagation();
        fetch(href)
            .then(function (response) {
                if (response.ok) {
                    return response.text();
                } else {
                    throw new Error(response.statusText);
                }
            })
            .then(function (text) {

                showModal(popup, 'day');
                var content = popup.querySelector('.content');
                // Check if the window has marked library
                if (href.match(REGEX_TYPE_MARKDOWN) && window.marked) {
                    // Parse the markdown text as HTML and set it as the popup innerHTML
                    content.innerHTML = marked.parse(text);
                } else {
                    content.innerHTML = `<pre><code>${text}</code></pre>`;
                    window.hljs ? window.hljs.highlightAll() : console.error('nohljs!')
                }
            })
            .catch(function (error) {
                console.error(error);
            });
    } else if (REGEX_TYPE_IMAGE.test(href)) {
        event.preventDefault();
        event.stopImmediatePropagation();
        content.innerHTML = `<img src="${href}">`;
        showModal(popup, 'night');
    } else if (window.location.search && !link.href.includes(window.location.search)) { // regular click
        event.preventDefault();
        event.stopImmediatePropagation();
        document.location.href = `${link.href}${window.location.search}`;
    }
}

function jumpPrevious(v, img) {
    if (v){
        if (!v.paused) {
            v.pause();
            v.currentTime = v.currentTime - 5.0;
            if (v.paused) {
                v.play();
            }
        }
    } else if (window.currentLink && (img || !v || (v && v.paused && v.currentTime == 0))) {
        const prev = findNextPrevLink(window.currentLink, REGEX_TYPE_CAN_PREVIEW, true);
        if (prev) {
            onLinkClicked(prev);
        }
    }
}

function jumpNext(v, img) {
    if (v && e.which != 32){
        if (!v.paused) {
            v.pause();
            v.currentTime = v.currentTime + 5.0;
            if (v.paused) {
                v.play();
            }
        }
    }
    if (window.currentLink && (img || !v || (v && v.ended)) ) {
        const next = findNextPrevLink(window.currentLink, REGEX_TYPE_CAN_PREVIEW);
        if (next) {
            onLinkClicked(next);
        }
    }
}


window.tStartX = 0;
window.tEndX = 0;
    
function checkDirection() {
  if (tEndX < tStartX) {
    jumpPrevious(document.querySelector('.popup video'), document.querySelector('.popup img'));
    console.log('swiped left!');
  }
  if (tEndX > tStartX) {
    jumpNext(document.querySelector('.popup video'), document.querySelector('.popup img'));
    console.log('swiped right!');
  }
}

document.addEventListener('touchstart', e => {
  tStartX = e.changedTouches[0].screenX
})

document.addEventListener('touchend', e => {
  tEndX = e.changedTouches[0].screenX
  checkDirection()
})

document.onclick = onDocumentClickHandler;

        </script>
    </head>
    <body>
        <div class="fixedplayer">
            <audio controls id="aplayer" src="" onended="onAudioEnded(this)"></audio><a href="#" onclick="hideAudioPlayer(); return false;">&times;</a>
        </div>'''
                   f'''<h1><a href="..">..</a>{args.gallery_root.absolute()}</h1>
        <div id="maine">'''
                   + html_data
                   + '''</div>
        <div id="popup1" class="overlay">
            <div class="popup">
                <h2 class="info"></h2>
                <a class="max" onclick="toggleRestoreModal()" href="#">&#x26F6;</a>
                <a class="close" onclick="hideModal(event)" href="#">&times;</a>
                <div class="content">
                </div>
            </div>
        </div>
    </body>
</html>
''')
    print(f"\nGallery HTML file generated: {(args.gallery_root / args.output_file).absolute()}")


def generate_thumbnails(assets: list[Asset], args:object):
    with ThreadPoolExecutor(max_workers=args.num_workers) as executor:

        for asset in assets:
            if (asset.thumbnail
                    and asset.type == 'image'
                    and not asset.thumbnail.exists()
                    and str(asset.thumbnail.absolute()) != str(asset.abspath.absolute())):
                executor.submit(make_thumbnail, asset, args.gallery_root.absolute())


def make_thumbnail(asset: Asset, basedir: Path):
    thumbnail_dir: Path = asset.thumbnail.parent
    thumbnail_dir.mkdir(parents=True, exist_ok=True)

    if asset.thumbnail.exists():
        print(f'⚡️\tSKIP existing thumbnail: {asset.thumbnail.absolute()}')
        return

    if graphics_magick_path:
        args = [graphics_magick_path,
            'convert',
            str(asset.abspath),
            "-strip",
            "-quality", "60",
            "-thumbnail", "300x"]
    elif image_magick_path:
        args = [image_magick_path,
            str(asset.abspath),
            "-strip",
            "-quality", "60",
            "-thumbnail", "300x"]
    else:
        raise 'Need either graphicsmagick or imagemagick!'

    if asset.abspath.suffix == '.heic':
        args += ['-format', 'jpg']

    args.append(str(asset.thumbnail.absolute()))

    proc = subprocess.run(args,
                          stdout=subprocess.PIPE,
                          stderr=subprocess.PIPE)

    result = proc.stdout.decode()
    print('✅', asset.relpath, '▶️', str(asset.thumbnail.absolute()), result)
    err = proc.stderr.decode()

    if err:
        print("😱", err)


if __name__ == "__main__":

    import argparse

    parser = argparse.ArgumentParser(description='Image gallery Generator')
    parser.add_argument('gallery_root',
                        help='Gallery root, by default current folder',
                        nargs='?',
                        action='store',
                        type=Path,
                        default=Path("."))
    parser.add_argument('--output-file', '-o',
                        metavar='output_file',
                        default=OUTPUT_FILE_NAME,
                        help='Output filename, by default (%(default)s)')
    parser.add_argument('--videos', '-m',
                        default=False,
                        action='store_true',
                        help='Include videos. !!!WARNING: increases page load time! (%(default)s)')
    parser.add_argument('--audios', '-a',
                        default=False,
                        action='store_true',
                        help='Include audios.')
    parser.add_argument('--video-preload',
                        default=False,
                        action='store_true',
                        help='Preload 1st frame for videos. !!!WARNING: increases page load time! (%(default)s)')
    parser.add_argument('--thumbs-dir', '-t',
                        type=Path,
                        default=Path(THUMBS_DIR),
                        help='Thumbnails folder, by default (%(default)s)')
    parser.add_argument('--no-thumbnails',
                        default=False,
                        action='store_true',
                        help='Use full size image and DO NOT generate image thumbnails using imagemagick (%(default)s)')
    parser.add_argument('--ignored', '-i',
                        nargs='*',
                        metavar='ignore',
                        default=[],
                        help='''Custom ignored path segments.
                        Accepts multiple segments, e.g. -i junk1 junk2 junk3 (%(default)s)''')
    parser.add_argument('--num-workers', '-n',
                        type=int,
                        default=MAX_THUMBNAIL_GENERATION_WORKERS,
                        help='''Maximum number of parallel threads for thumbnail generation, DEFAULT: (%(default)s)''')
    parser.add_argument('--verbose', '-v',
                        help='Verbose output (%(default)s)',
                        default=False,
                        action='store_true')

    args = parser.parse_args(sys.argv[1:])

    if not args.no_thumbnails:
        if not image_magick_path or not Path(image_magick_path).exists():
            print('''❗️ Imagemagick convert not found!".
    To install
    * ubuntu/debian: apt install imagemagick
    * macos: brew install imagemagick
    Press Enter to ignore and use full size images for gallery previews or CTR-C to abort...''')
            input()
    else:
        image_magick_path = None

    if register_heif_opener:
        register_heif_opener()  # https://stackoverflow.com/a/72584490

    thumbnails_dir = Path.expanduser(args.thumbs_dir)
    thumbnails_dir.mkdir(exist_ok=True)

    print(f'Collecting media in: {args.gallery_root.absolute()}')
    asset_list: list[Asset] = collect_media_assets(args)

    if not asset_list:
        print("No media files found.")
    else:
        asset_list.sort()
        html_content: str = '\n'.join(asset.html for asset in asset_list)

        generate_thumbnails(asset_list, args)
        generate_gallery_html(html_content, args)

        if len(asset_list):
            print(f'''
Total assets:    {len(asset_list)}
Images:          {sum(a.type == 'image' for a in asset_list)}
Audios:          {sum(a.type == 'audio' for a in asset_list)}
Videos:          {sum(a.type == 'video' for a in asset_list)}
''')
