#!/opt/homebrew/bin/python3
"""
Search the Zotero vector index for references relevant to a query.

Usage:
  search_zotero.py "your query text"
  search_zotero.py --from-project path/to/project.md
  search_zotero.py --from-project path/to/project.md --top 20

Options:
  --from-project FILE   Use purpose + core argument + key debates from project.md as query
  --top N               Number of results to return (default: 15)
  --index FILE          Path to index (default: ~/notes/.zotero_index.pkl)
"""

import sys, pickle, re
from pathlib import Path
import numpy as np

INDEX_PATH = Path("~/notes/.zotero_index.pkl").expanduser()

def cosine_similarity(a, b):
    return np.dot(a, b) / (np.linalg.norm(a) * np.linalg.norm(b))

def parse_args(args):
    opts = {"query": None, "from_project": None, "top": 15, "index": INDEX_PATH}
    i = 0
    while i < len(args):
        if args[i] == "--from-project":
            opts["from_project"] = args[i+1]; i += 2
        elif args[i] == "--top":
            opts["top"] = int(args[i+1]); i += 2
        elif args[i] == "--index":
            opts["index"] = Path(args[i+1]).expanduser(); i += 2
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
        print(f"Query from project.md ({len(query_text)} chars)\n")
    else:
        query_text = opts["query"]

    query_vec = model.encode([query_text])[0]

    scored = []
    for entry in index:
        sim = cosine_similarity(query_vec, entry["vector"])
        scored.append((sim, entry))

    scored.sort(key=lambda x: -x[0])

    print(f"Top {opts['top']} results:\n")
    for sim, e in scored[:opts["top"]]:
        citekey = f"[@{e['citekey']}]" if e["citekey"] else f"(zotero:{e['zotero_key']})"
        print(f"  {sim:.3f}  {e['authors']} ({e['year']}) {e['title'][:70]}")
        print(f"         {citekey}")
        if e["abstract"]:
            print(f"         {e['abstract'][:120]}...")
        print()

if __name__ == "__main__":
    main()
