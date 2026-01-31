#!/bin/bash

# Build PDF from Markdown using Docker and pandoc
# Usage:
#   build-pdf.sh <input.md> <output.pdf> [options]
#
# Options:
#   --toc             Include table of contents
#   --number-sections Number the sections
#   --title-page FILE Prepend a title page markdown file
#   --latex-header FILE Custom LaTeX header file

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

DOCKER_IMAGE="intoffset/pandoc-pdf-ja"

# Parse arguments
INPUT=""
OUTPUT=""
TOC=""
NUMBER_SECTIONS=""
TITLE_PAGE=""
LATEX_HEADER=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --toc)
            TOC="--toc --toc-depth=3"
            shift
            ;;
        --number-sections)
            NUMBER_SECTIONS="--number-sections"
            shift
            ;;
        --title-page)
            TITLE_PAGE="$2"
            shift 2
            ;;
        --latex-header)
            LATEX_HEADER="$2"
            shift 2
            ;;
        *)
            if [ -z "$INPUT" ]; then
                INPUT="$1"
            elif [ -z "$OUTPUT" ]; then
                OUTPUT="$1"
            fi
            shift
            ;;
    esac
done

# Validate arguments
if [ -z "$INPUT" ] || [ -z "$OUTPUT" ]; then
    echo -e "${RED}Error: Input and output files are required${NC}"
    echo "Usage: build-pdf.sh <input.md> <output.pdf> [options]"
    exit 1
fi

if [ ! -f "$INPUT" ]; then
    echo -e "${RED}Error: Input file not found: $INPUT${NC}"
    exit 1
fi

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed${NC}"
    echo "Please install Docker Desktop or Rancher Desktop"
    exit 1
fi

# Pull Docker image if not available
if ! docker image inspect "$DOCKER_IMAGE" &> /dev/null; then
    echo "Pulling Docker image..."
    docker pull "$DOCKER_IMAGE"
fi

# Create output directory if needed
OUTPUT_DIR="$(dirname "$OUTPUT")"
mkdir -p "$OUTPUT_DIR"

# Prepare workspace
WORKSPACE_ROOT="$(cd "$(dirname "$INPUT")" && pwd)"

# Determine LaTeX header
CLEANUP_LATEX=false
if [ -n "$LATEX_HEADER" ] && [ -f "$LATEX_HEADER" ]; then
    # Custom header: copy to workspace
    mkdir -p "$WORKSPACE_ROOT/latex"
    cp "$LATEX_HEADER" "$WORKSPACE_ROOT/latex/header.tex"
    HEADER_OPTION="latex/header.tex"
    CLEANUP_LATEX=true
else
    # Use default header from Docker image
    HEADER_OPTION="/latex/header.tex"
fi

# Build pandoc command
PANDOC_OPTS=(
    "--pdf-engine=lualatex"
    "--include-in-header=$HEADER_OPTION"
    "-V" "geometry:margin=2cm"
    "-V" "documentclass=article"
    "-V" "classoption=a4paper"
    "-V" "block-headings"
)

if [ -n "$TOC" ]; then
    PANDOC_OPTS+=($TOC)
fi

if [ -n "$NUMBER_SECTIONS" ]; then
    PANDOC_OPTS+=($NUMBER_SECTIONS)
fi

# Handle title page (prepend to input)
FINAL_INPUT="$INPUT"
if [ -n "$TITLE_PAGE" ] && [ -f "$TITLE_PAGE" ]; then
    TEMP_INPUT="$WORKSPACE_ROOT/.tmp-merged-input.md"
    cat "$TITLE_PAGE" "$INPUT" > "$TEMP_INPUT"
    FINAL_INPUT="$TEMP_INPUT"
fi

echo -e "${YELLOW}Converting $INPUT to PDF...${NC}"

# Get relative paths for Docker
INPUT_REL="$(basename "$FINAL_INPUT")"
OUTPUT_REL="$(realpath --relative-to="$WORKSPACE_ROOT" "$OUTPUT" 2>/dev/null || echo "$(basename "$OUTPUT")")"

# Run pandoc in Docker
docker run --rm \
    -v "$WORKSPACE_ROOT:/workspace" \
    -w /workspace \
    "$DOCKER_IMAGE" \
    pandoc "$INPUT_REL" \
        "${PANDOC_OPTS[@]}" \
        -o "$OUTPUT_REL" 2>&1 | grep -v "WARNING" || true

# Cleanup
rm -f "$WORKSPACE_ROOT/.tmp-merged-input.md"
if [ "$CLEANUP_LATEX" = true ]; then
    rm -rf "$WORKSPACE_ROOT/latex"
fi

if [ -f "$OUTPUT" ]; then
    echo -e "${GREEN}✓ PDF generated: $OUTPUT${NC}"
else
    echo -e "${RED}✗ Failed to generate PDF${NC}"
    exit 1
fi
