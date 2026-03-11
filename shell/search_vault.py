#!/opt/homebrew/bin/python3
"""
Search the vault index for notes semantically similar to a query.

Usage:
  search_vault.py "your query text"
  search_vault.py --from-project path/to/project.md
  search_vault.py --from-project path/to/project.md --top 20

Options:
  --from-project FILE   Use purpose + core argument + key debates from project.md as query
  --top N               Number of results to return (default: 20)
  --index FILE          Path to index file (default: ~/notes/vault_index.pkl)
  --exclude FILE        Comma-separated filenames to exclude (e.g. already listed source notes)
"""

import sys, pickle, re
from pathlib import Path

import numpy as np

def cosine_similarity(a, b):
    return np.dot(a, b) / (np.linalg.norm(a) * np.linalg.norm(b))

def parse_args(args):
    opts = {
        "query": None,
        "from_project": None,
        "top": 20,
        "index": Path("~/notes/.vault_index.pkl").expanduser(),
        "exclude": [],
    }
    i = 0
    while i < len(args):
        if args[i] == "--from-project":
            opts["from_project"] = args[i+1]; i += 2
        elif args[i] == "--top":
            opts["top"] = int(args[i+1]); i += 2
        elif args[i] == "--index":
            opts["index"] = Path(args[i+1]).expanduser(); i += 2
        elif args[i] == "--exclude":
            opts["exclude"] = args[i+1].split(","); i += 2
        else:
            opts["query"] = args[i]; i += 1
    return opts

def extract_project_query(project_path):
    text = Path(project_path).read_text()
    sections = ["## Purpose", "## Core argument", "## Key debates engaged"]
    parts = []
    for section in sections:
        m = re.search(re.escape(section) + r"\n(.*?)(?=\n## |\Z)", text, re.DOTALL)
        if m:
            parts.append(m.group(1).strip())
    return "\n\n".join(parts)

def get_source_notes(project_path):
    text = Path(project_path).read_text()
    return re.findall(r'`([^`]+\.md)`', text)

def main():
    opts = parse_args(sys.argv[1:])

    if not opts["query"] and not opts["from_project"]:
        print(__doc__)
        sys.exit(1)

    print("Loading index...")
    with open(opts["index"], "rb") as f:
        index = pickle.load(f)

    from sentence_transformers import SentenceTransformer
    model = SentenceTransformer("all-MiniLM-L6-v2")

    if opts["from_project"]:
        query_text = extract_project_query(opts["from_project"])
        exclude = get_source_notes(opts["from_project"])
        print(f"Query from project.md ({len(query_text)} chars)")
        print(f"Excluding {len(exclude)} already-listed source notes\n")
    else:
        query_text = opts["query"]
        exclude = opts["exclude"]

    query_vec = model.encode([query_text])[0]

    scored = []
    for entry in index:
        if any(ex in entry["path"] for ex in exclude):
            continue
        sim = cosine_similarity(query_vec, entry["vector"])
        scored.append((sim, entry["path"], entry["preview"]))

    scored.sort(reverse=True)

    print(f"Top {opts['top']} results:\n")
    for sim, path, preview in scored[:opts["top"]]:
        first_line = preview.splitlines()[0][:80] if preview else ""
        print(f"  {sim:.3f}  {path}")
        print(f"           {first_line}")

if __name__ == "__main__":
    main()
