#!/bin/bash
# Entrypoint script for pandoc-pdf-ja
# Provides sensible defaults for Japanese PDF generation

set -e

# Default pandoc options for Japanese PDF
DEFAULT_OPTS=(
    --pdf-engine=lualatex
    --include-in-header=/latex/header.tex
    -V geometry:margin=2cm
    -V documentclass=article
    -V classoption=a4paper
)

# If no arguments, show help
if [ $# -eq 0 ]; then
    echo "Usage: docker run --rm -v \"\$(pwd):/workspace\" ghcr.io/intoffset/pandoc-pdf-ja <input.md> [options]"
    echo ""
    echo "Examples:"
    echo "  # Basic conversion (outputs input.pdf)"
    echo "  docker run --rm -v \"\$(pwd):/workspace\" ghcr.io/intoffset/pandoc-pdf-ja input.md"
    echo ""
    echo "  # Specify output file"
    echo "  docker run --rm -v \"\$(pwd):/workspace\" ghcr.io/intoffset/pandoc-pdf-ja input.md -o output.pdf"
    echo ""
    echo "  # With table of contents"
    echo "  docker run --rm -v \"\$(pwd):/workspace\" ghcr.io/intoffset/pandoc-pdf-ja input.md --toc"
    echo ""
    echo "  # Run raw pandoc command"
    echo "  docker run --rm -v \"\$(pwd):/workspace\" ghcr.io/intoffset/pandoc-pdf-ja pandoc --version"
    exit 0
fi

# If first argument is 'pandoc', run pandoc directly (bypass defaults)
if [ "$1" = "pandoc" ]; then
    exec "$@"
fi

# Check if first argument looks like a markdown file
INPUT="$1"
shift

# Parse remaining arguments
OUTPUT=""
EXTRA_OPTS=()

while [ $# -gt 0 ]; do
    case "$1" in
        -o|--output)
            OUTPUT="$2"
            shift 2
            ;;
        *)
            EXTRA_OPTS+=("$1")
            shift
            ;;
    esac
done

# If no output specified, derive from input filename
if [ -z "$OUTPUT" ]; then
    OUTPUT="${INPUT%.md}.pdf"
fi

# Run pandoc with defaults
exec pandoc "$INPUT" "${DEFAULT_OPTS[@]}" "${EXTRA_OPTS[@]}" -o "$OUTPUT"
