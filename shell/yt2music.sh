#!/bin/bash
# One-step batch YouTube → Apple Music importer
# Usage: yt2music.sh URL [URL2 URL3 ...]

INCOMING="$HOME/Music/IncomingMP3"
mkdir -p "$INCOMING"

if [ $# -eq 0 ]; then
    echo "Usage: $0 <YouTube URL> [more URLs...]"
    exit 1
fi

echo "Downloading audio..."
yt-dlp \
    --extract-audio \
    --audio-format mp3 \
    --audio-quality 0 \
    --embed-thumbnail \
    --output "$INCOMING/%(title)s.%(ext)s" \
    "$@"

echo "Tagging & importing into Apple Music..."
beet import "$INCOMING"

echo "Tracks should now appear in Apple Music."

