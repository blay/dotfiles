#!/opt/homebrew/bin/python3
"""
Build a semantic vector index of all markdown notes in the vault.

Usage:
  build_vault_index.py [vault_root] [index_output]

Defaults:
  vault_root     ~/notes/md/
  index_output   ~/notes/.vault_index.pkl

The index is a list of dicts: {path, preview, vector}.
Run this once to build, then re-run to rebuild when notes change.
"""

import sys, glob, pickle, os
from pathlib import Path

def main():
    vault_root  = Path(sys.argv[1]).expanduser() if len(sys.argv) > 1 else Path("~/notes/md/").expanduser()
    index_path  = Path(sys.argv[2]).expanduser() if len(sys.argv) > 2 else Path("~/notes/.vault_index.pkl").expanduser()

    files = [Path(f) for f in glob.glob(str(vault_root / "**/*.md"), recursive=True)
             if ".claude" not in f]

    print(f"Found {len(files)} notes. Loading model...")

    from sentence_transformers import SentenceTransformer
    model = SentenceTransformer("all-MiniLM-L6-v2")

    texts = []
    paths = []
    for f in files:
        try:
            text = f.read_text(errors="ignore").strip()
        except Exception:
            continue
        texts.append(text[:2000])  # truncate very long notes
        paths.append(str(f.relative_to(vault_root)))

    print(f"Embedding {len(texts)} notes (this may take a few minutes)...")
    vectors = model.encode(texts, show_progress_bar=True, batch_size=64)

    index = [{"path": p, "preview": t[:200], "vector": v}
             for p, t, v in zip(paths, texts, vectors)]

    with open(index_path, "wb") as f:
        pickle.dump(index, f)

    print(f"Index saved to {index_path} ({len(index)} entries)")

if __name__ == "__main__":
    main()
