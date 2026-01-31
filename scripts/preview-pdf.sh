#!/bin/bash

# Convert PDF to PNG images for quality preview
# Usage:
#   preview-pdf.sh <input.pdf> [output-dir]
#
# Output:
#   Creates PNG files in output-dir (default: same directory as PDF)
#   Named as: <basename>-page-001.png, <basename>-page-002.png, etc.

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

DOCKER_IMAGE="intoffset/pandoc-pdf-ja"

# Parse arguments
INPUT="$1"
OUTPUT_DIR="${2:-$(dirname "$INPUT")}"

if [ -z "$INPUT" ]; then
    echo -e "${RED}Error: Input PDF file is required${NC}"
    echo "Usage: preview-pdf.sh <input.pdf> [output-dir]"
    exit 1
fi

if [ ! -f "$INPUT" ]; then
    echo -e "${RED}Error: Input file not found: $INPUT${NC}"
    exit 1
fi

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed${NC}"
    exit 1
fi

# Pull Docker image if not available
if ! docker image inspect "$DOCKER_IMAGE" &> /dev/null; then
    echo "Pulling Docker image..."
    docker pull "$DOCKER_IMAGE"
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Get basename without extension
BASENAME="$(basename "$INPUT" .pdf)"
WORKSPACE_ROOT="$(cd "$(dirname "$INPUT")" && pwd)"
INPUT_REL="$(basename "$INPUT")"

echo -e "${YELLOW}Converting $INPUT to PNG images...${NC}"

# Run ghostscript in Docker to convert PDF to PNG
docker run --rm \
    -v "$WORKSPACE_ROOT:/workspace" \
    -v "$(realpath "$OUTPUT_DIR"):/output" \
    -w /workspace \
    "$DOCKER_IMAGE" \
    gs -dNOPAUSE -dBATCH -sDEVICE=png16m -r150 \
       -sOutputFile="/output/${BASENAME}-page-%03d.png" \
       "$INPUT_REL" 2>&1 | grep -v "GPL\|Copyright\|This software" || true

# Count generated files
COUNT=$(ls -1 "$OUTPUT_DIR/${BASENAME}-page-"*.png 2>/dev/null | wc -l | tr -d ' ')

if [ "$COUNT" -gt 0 ]; then
    echo -e "${GREEN}✓ Generated $COUNT preview image(s) in $OUTPUT_DIR${NC}"
    ls -1 "$OUTPUT_DIR/${BASENAME}-page-"*.png
else
    echo -e "${RED}✗ Failed to generate preview images${NC}"
    exit 1
fi
