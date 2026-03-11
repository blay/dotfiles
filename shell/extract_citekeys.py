#!/usr/bin/env python3
"""
Extract pandoc citekeys from markdown files.

Usage:
  extract_citekeys.py                        # current directory (recursive)
  extract_citekeys.py path/to/dir/           # specific directory (recursive)
  extract_citekeys.py file.md [file2.md ...] # one or more specific files
  extract_citekeys.py --from-project project.md [vault_root]
                                             # reads ## Source notes from project.md,
                                             # extracts from project.md + listed files
                                             # vault_root defaults to ~/notes/md/
"""
import re, glob, sys, os
from pathlib import Path

PATTERN = re.compile(r'\[\[@([^\]]+)\]\]')

def extract_from_file(path):
    try:
        return set(PATTERN.findall(Path(path).read_text()))
    except FileNotFoundError:
        print(f"warning: file not found: {path}", file=sys.stderr)
        return set()

def extract_from_dir(directory):
    keys = set()
    for f in glob.glob(f"{directory}/**/*.md", recursive=True) + glob.glob(f"{directory}/*.md"):
        keys.update(extract_from_file(f))
    return keys

def parse_source_notes(project_path):
    """Return list of filenames from the ## Source notes section of project.md."""
    text = Path(project_path).read_text()
    in_section = False
    files = []
    for line in text.splitlines():
        if re.match(r'^## Source notes', line):
            in_section = True
            continue
        if in_section:
            if re.match(r'^## ', line):
                break
            m = re.match(r'^[-*]\s+`(.+\.md)`', line)
            if m:
                files.append(m.group(1))
    return files

def from_project(project_path, vault_root):
    vault = Path(vault_root).expanduser()
    keys = extract_from_file(project_path)
    for filename in parse_source_notes(project_path):
        keys.update(extract_from_file(vault / filename))
    return keys

if __name__ == '__main__':
    args = sys.argv[1:]

    if args and args[0] == '--from-project':
        project = args[1] if len(args) > 1 else 'project.md'
        vault_root = args[2] if len(args) > 2 else '~/notes/md/'
        keys = from_project(project, vault_root)
    elif not args:
        keys = extract_from_dir('.')
    elif len(args) == 1 and os.path.isdir(args[0]):
        keys = extract_from_dir(args[0])
    else:
        keys = set()
        for arg in args:
            keys.update(extract_from_file(arg))

    for key in sorted(keys):
        print(key)
