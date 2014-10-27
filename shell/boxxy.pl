#!/usr/bin/perl

use Switch;
use File::stat;
use File::Basename;
use POSIX 'strftime';
use Cwd qw{getcwd abs_path};

# Options

# Flattr ID (Use name, not the number. Undefined to disable.)
my $flattrid = 'monki';
# Base url, e.g. http://example.com/album (only used by flattr)
my $baseurl = 'http://blay.se';

# License, possible options:
# none     - No license tag
# by       - Creative Commons Attribution 
# by-sa    - Creative Commons Attribution-ShareAlike
# by-nd    - Creative Commons Attribution-NoDerivs 
# by-nc    - Creative Commons Attribution-NonCommercial 
# by-nc-sa - Creative Commons Attribution-NonCommercial-ShareAlike 
my $license = 'by-sa';

# Used like backticks, but automatically chomps output.
sub sh
{
  chomp(my $res = `$_[0]`);
  return $res;
}

# Gets mtime of a file or directory, caches the result for speed.
# Should not be used if mtimes might change while the script is running.
sub mtime
{
  my $file = abs_path shift;
  return 0 unless -f $file or -d $file;
  return $mtime{$file} ||= lstat($file)->mtime;
}

# Prints an html header to index.html.
sub header
{
  my ($lastdir) = @_;
  my $descriptionfile = "../" . basename(getcwd()) .".desc";
  my $description = do { local $/; open F, $descriptionfile; <F> }
    if -f $descriptionfile;
  open INDEX, ">index.html";
  print INDEX <<"EOF";
<html>
  <head>
    <title>$lastdir</title>
    <style type="text/css">
      body { margin: 0; padding: 0 }
      img { border: none; padding: 0 }
      a { text-decoration: none; margin: 0; padding: 0 }
      .container
      {
        position: relative;
        float: left;
        border: 1px solid black
      }
      .container-head
      {
        position: relative;
        float: left;
        border: 1px solid black;
        background: black;
        width: 300px;
        height: 225px;
      }
      .container-text
      {
        position: relative;
        float: left;
        border: 1px solid black;
        background: white;
        width: 300px;
        height: 225px;    
      }
      .label-text
      {
        font-size: 12pt;
        font-family: courier;
        color: black;
        position: absolute;
        top: 10px;
        left: 10px;
      }
      .description-text
      {
        font-size: 8pt;
        font-family: courier;
        color: black;
        top: 30px;
        left: 20px;
      }
      pre {
        font-size: 8px;
        margin-top: 30px;
        margin-left: 30px;
        color: black;
        padding: 0;
        width: 270px;
        height: 195px;
        overflow: auto;
        overflow-X: hidden;
        overflow-Y: hidden;
      }
      .label
      {
        font-size: 12pt;
        color: white;
        text-shadow:
         -1px -1px 0 #000,
          1px -1px 0 #000,
         -1px  1px 0 #000,
          1px  1px 0 #000;
        position: absolute;
        top: 20px;
        left: 20px;
      }
      .description
      {
        font-size: 8pt;
        color: white;
        text-shadow:
         -1px -1px 0 #000,
          1px -1px 0 #000,
         -1px  1px 0 #000,
          1px  1px 0 #000;
        position: absolute;
        bottom: 10px;
        left: 5px;
      }
    </style>
EOF
  print INDEX <<"EOF" if defined $flattrid and (-f '.flattr');
    <script type="text/javascript">
    /* <![CDATA[ */
      (function() {
        var s = document.createElement('script'),
            t = document.getElementsByTagName('script')[0];
        s.type = 'text/javascript';
        s.async = true;
        s.src = 'http://api.flattr.com/js/0.6/load.js?mode=auto';
        t.parentNode.insertBefore(s, t);
      })();
    /* ]]> */
    </script>
EOF
  print INDEX <<"EOF";
    <META http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
EOF

print INDEX qq{    <div class="container-head">\n}
  if $flattrid or $license ne 'none' or $description;
  
  print INDEX <<"EOF" if defined $flattrid and !(-e '.no-flattr');
      <a class="FlattrButton" style="display:none;"
          title="$flattrid's images: $lastdir"
          data-flattr-uid="$flattrid"
          data-flattr-tags=""
          data-flattr-category="images"
          href="$baseurl/$lastdir/">
      </a>
EOF
  
  print INDEX <<"EOF" if $license ne 'none' and !(-f '.no-license');
      <a rel="license" href="http://creativecommons.org/licenses/$license/3.0/">
        <img alt="Creative Commons License"
             style="position:absolute;top:0px;right:0px;border-width:0"
             src="http://i.creativecommons.org/l/$license/3.0/88x31.png" />
      </a>
EOF
  
  print INDEX <<"EOF" if $flattrid or $license ne 'none' or $description;
      <div class="description">$description</div>
    </div>
EOF
  close INDEX;
}

# Appends an image link with thumbnail to index.html.
sub href
{
  my ($target, $image) = @_;
  my ($descriptionfile, $original, $label, $type, $imagefile, $labelfile);
  
  if (-d $target)
  {
    open F, "$target/index.html";
    $label = basename($target) .' ('. scalar(grep { /a href/ } <F>) .')';
    close F;
    $labelfile = basename($target) . '.label';
    $descriptionfile = basename($target) . '.desc';
    $imagefile = basename($target) . '.img';
    $typefile = basename($target) . '.type';
  }
  else
  {
    $original = dirname($target) .'/'. do { basename($target) =~ /^\.?(.*)$/; $1 };
    $labelfile = $original .'.label';
    $descriptionfile = $original .'.desc';
    $imagefile = $original .'.img';
    $label = strftime('%H:%M', localtime mtime($target));
  }
  
  $label = do { local $/; open F, $labelfile; <F> }
    if -f $labelfile;
  my $description = do { local $/; open F, $descriptionfile; <F> }
    if -f $descriptionfile;
  $image = do { local $/; open F, $imagefile; <F> }
    if -f $imagefile;
  $type = do { local $/; open F, $typefile; <F> }
    if -f $typefile;
  chomp $type;
  chomp $label;
  chomp $description;

  $type = "text" if $target =~ /.(txt|asc|pl)$/;
  $type = "no-image" if !$image and !$type;

  # Different folder types, default to image directory.
  open INDEX, '>>index.html';
  switch ($type) {
    case "no-image" {
      print INDEX <<"EOF";
    <a href="$target">
      <div class="container-head">
        <div class="label">$label</div>
        <div class="description">$description</div>
      </div>
    </a>
EOF
    }
    case "folder" {
      print INDEX <<"EOF";
    <a href="$target">
      <div class="container-head">
        <div class="label">$label</div>
        <div class="description">$description</div>
      </div>
    </a>
EOF
    }
    case "text" {
      $description = do { local $/; open F, $target; <F> };
      print INDEX <<"EOF";
    <a href="$target">
      <div class="container-text">
        <div class="label-text">$target</div>
        <pre>$description</pre>
      </div>
    </a>
EOF
    }
    else {
    print INDEX <<"EOF";
    <a href="$target">
      <div class="container">
        <div class="label">$label</div>
        <div class="description">$description</div>
        <img src="$image" />
      </div>
    </a>
EOF
    }
  }
  close INDEX;
}

sub footer
{
  open INDEX, '>>index.html';
  print INDEX "  </body>\n</html>\n";
}

# Queues an image to be resized with convert.
sub resize
{
  my $size = shift;
  my ($input, $output) = map { abs_path $_ } @_;
  print CONVERT qq{"$input" -auto-orient -quality 90 -resize "$size" "$output"\n};
  $converting++;
}

# Tries to figure out the number of processor cores.
sub cores
{
  switch (sh 'uname')
  {
    case 'Linux'   { return scalar do { open F, '/proc/cpuinfo';
                                        grep { /^processor/ } <F> } }
    case 'SunOS'   { return my $c =()= sh('psrinfo -v') =~ /^Status/mg }
    case 'Darwin'  { return sh 'sysctl -na hw.ncpu' }
    case /^CYGWIN/ { return $ENV{NUMBER_OF_PROCESSORS} }
    else           { return 1 }
  }
}

# Sets timestamp of a file, optionally copies timestamp from another file.
sub touch
{
  my ($target, $source) = @_;
  my $time = $source ? mtime($source) : time;
  delete $mtime{$target};
  utime $time, $time, $target;
}

# The main function, which generates an image index.
sub generate_index
{
  my ($lastdir) = @_;
  
  header($lastdir);
  
  for my $subdir (sort { mtime($a) <=> mtime($b) }
                  grep { -d }
                  glob "*")
  {
    $typefile = $subdir . '.type';
    my $type = do { local $/; open F, $typefile; <F> }
      if -f $typefile;
    chomp $type;

    chdir $subdir;

    generate_index($lastdir .'/'. basename(getcwd()))
      if !($type eq "folder");
    my $html = do { open F, 'index.html'; local $/; <F> };
    chdir '..';
    
    if ($html =~ /a href/)
    {
      my @thumbs = $html =~ /img src="(.*?)"/g;
      href "$subdir/", "$subdir/$thumbs[rand @thumbs]"
        if !(-e "$subdir/.no-index");
    }
    if ($type eq "folder") 
    {
      href "$subdir/";
    }
  }

  for my $text (sort { mtime($a) <=> mtime($b) }
                grep { /^[^\.].*\.(txt|asc|pl)$/i }
                glob "*" )
  {
#    (my $view = $text) =~ s/^/./;
#    my $fulltext = do { local $/; open F, $text; <F> };
#    (my $summary = $fulltext) =~ s/^(.{100}).*/$1/;
#    $summary =~ s/\n/ /g;
     href $text;
  }
  for my $image (sort { mtime($a) <=> mtime($b) }
                 grep { /^[^\.].*\.(jpg|png)$/i }
                 glob "*" )
  {
    (my $view  = $image) =~ s/^/./;
    (my $thumb = $image) =~ s/^(.+)\.(.+)$/.$1_T.$2/;
    href $view, $thumb;
    -f $view or resize '2048x2048', $image, $view;
    -f $thumb or resize '800x225', $image, $thumb;

    # Fix timestamps of thumbnails and medium size images.
    # This currently needs a second run of the script when adding images.
    touch $view, $image unless mtime($view) == mtime($image);
    touch $thumb, $image unless mtime($thumb) == mtime($image);
  }
  
  footer();
}

# Add multi processing options if xargs is GNUish.
$xargsopts = sh('xargs --help') =~ /-P/ ? '-r -P '.cores() : '';
open CONVERT, "| xargs -L1 ${xargsopts} convert";

print STDERR "Generating HTML ...\n";
generate_index basename getcwd;

print STDERR "Converting images ...\n" if $converting;
close CONVERT;
