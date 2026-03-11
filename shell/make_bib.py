#!/usr/bin/env python3
"""Extract citekeys from markdown files and build a filtered .bib file."""

import re, glob, subprocess, sys, tempfile, os
from pathlib import Path

PATTERN = re.compile(r'\[\[@([^\]]+)\]\]')

def extract_keys(path):
    keys = set()
    p = Path(path)
    if p.is_file():
        keys.update(PATTERN.findall(p.read_text()))
    else:
        for f in glob.glob(f"{path}/**/*.md", recursive=True) + glob.glob(f"{path}/*.md"):
            keys.update(PATTERN.findall(Path(f).read_text()))
    return sorted(keys)

def make_bib(keys, master_bib, output_bib):
    with tempfile.NamedTemporaryFile(mode='w', suffix='.aux', delete=False) as tmp:
        tmp.write('\n'.join(f'\\citation{{{k}}}' for k in keys))
        aux_path = tmp.name
    try:
        subprocess.run(['bibtool', '-x', aux_path, master_bib, '-o', output_bib], check=True)
    finally:
        os.unlink(aux_path)

if __name__ == '__main__':
    path       = sys.argv[1] if len(sys.argv) > 1 else '.'
    master_bib = sys.argv[2] if len(sys.argv) > 2 else '~/notes/lib.bib'
    master_bib = str(Path(master_bib).expanduser())
    folder_name = Path(path).resolve().name
    output_bib = sys.argv[3] if len(sys.argv) > 3 else f'{folder_name}.bib'

    keys = extract_keys(path)
    print(f"Found {len(keys)} unique citekeys")
    make_bib(keys, master_bib, output_bib)
    print(f"Written to {output_bib}")
