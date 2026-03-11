#!/opt/homebrew/bin/python3
"""
Fetch all items from Zotero and build a semantic vector index.

Usage:
  build_zotero_index.py

Credentials (set in ~/.zotero or as environment variables):
  ZOTERO_USER_ID   — your numeric user ID (zotero.org → Settings → Feeds/API)
  ZOTERO_API_KEY   — API key with library read access (same page)

Index saved to: ~/notes/.zotero_index.pkl
"""

import sys, os, pickle, re
from pathlib import Path

CONFIG_FILE = Path("~/.zotero").expanduser()
INDEX_PATH  = Path("~/notes/.zotero_index.pkl").expanduser()

def load_credentials():
    creds = {}
    if CONFIG_FILE.exists():
        for line in CONFIG_FILE.read_text().splitlines():
            if "=" in line and not line.startswith("#"):
                k, _, v = line.partition("=")
                creds[k.strip()] = v.strip()
    user_id = os.environ.get("ZOTERO_USER_ID") or creds.get("ZOTERO_USER_ID")
    api_key = os.environ.get("ZOTERO_API_KEY") or creds.get("ZOTERO_API_KEY")
    if not user_id or not api_key:
        print("Error: ZOTERO_USER_ID and ZOTERO_API_KEY required.")
        print(f"Set them in {CONFIG_FILE} or as environment variables.")
        print("\nExample ~/.zotero file:")
        print("  ZOTERO_USER_ID = 123456")
        print("  ZOTERO_API_KEY = abcdefghijklmnop")
        sys.exit(1)
    return user_id, api_key

def parse_citekey(extra):
    """Extract Better BibTeX citekey from the extra field."""
    if not extra:
        return None
    m = re.search(r'Citation Key:\s*(\S+)', extra, re.IGNORECASE)
    return m.group(1) if m else None

def format_authors(creators):
    names = []
    for c in creators[:3]:
        if "lastName" in c:
            names.append(c["lastName"])
        elif "name" in c:
            names.append(c["name"])
    if len(creators) > 3:
        names.append("et al.")
    return ", ".join(names)

def main():
    user_id, api_key = load_credentials()

    from pyzotero import zotero
    print("Connecting to Zotero...")
    zot = zotero.Zotero(user_id, "user", api_key)

    print("Fetching all items (this may take a minute)...")
    all_items = zot.everything(zot.items())

    # Filter to actual reference items (not attachments, notes, etc.)
    items = [i for i in all_items
             if i["data"].get("itemType") not in ("attachment", "note", "annotation")]
    print(f"Found {len(items)} reference items")

    texts = []
    records = []
    for item in items:
        d = item["data"]
        title    = d.get("title", "").strip()
        abstract = d.get("abstractNote", "").strip()
        year     = d.get("date", "")[:4]
        authors  = format_authors(d.get("creators", []))
        citekey  = parse_citekey(d.get("extra", ""))

        if not title:
            continue

        embed_text = f"{title}. {abstract}"
        texts.append(embed_text)
        records.append({
            "zotero_key": item["key"],
            "citekey":    citekey,
            "title":      title,
            "authors":    authors,
            "year":       year,
            "abstract":   abstract[:300],
        })

    print(f"Embedding {len(texts)} items...")
    from sentence_transformers import SentenceTransformer
    model = SentenceTransformer("all-MiniLM-L6-v2")
    vectors = model.encode(texts, show_progress_bar=True, batch_size=64)

    index = [{**rec, "vector": vec} for rec, vec in zip(records, vectors)]

    with open(INDEX_PATH, "wb") as f:
        pickle.dump(index, f)

    print(f"Zotero index saved to {INDEX_PATH} ({len(index)} entries)")

if __name__ == "__main__":
    main()
