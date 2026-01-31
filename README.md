# pandoc-pdf-ja

Docker image for converting Markdown to PDF with Japanese text and emoji support.

## Features

- Japanese text rendering with Noto Sans CJK JP
- Emoji support with Noto Color Emoji
- Table of contents generation
- Section numbering
- Custom LaTeX headers
- PDF to PNG preview generation

## Quick Start

### Pull the image

```bash
docker pull intoffset/pandoc-pdf-ja
```

### Convert Markdown to PDF

```bash
docker run --rm -v "$(pwd):/workspace" -w /workspace \
  intoffset/pandoc-pdf-ja \
  pandoc input.md \
    --pdf-engine=lualatex \
    --include-in-header=/latex/header.tex \
    -V geometry:margin=2cm \
    -V documentclass=article \
    -V classoption=a4paper \
    -o output.pdf
```

### Using helper scripts

Download the scripts from `scripts/` directory:

```bash
# Convert Markdown to PDF
./scripts/build-pdf.sh input.md output.pdf

# With table of contents and numbered sections
./scripts/build-pdf.sh input.md output.pdf --toc --number-sections

# Generate preview images
./scripts/preview-pdf.sh output.pdf preview/
```

## Script Options

### build-pdf.sh

```
Usage: build-pdf.sh <input.md> <output.pdf> [options]

Options:
  --toc               Include table of contents
  --number-sections   Number the sections
  --title-page FILE   Prepend a title page markdown file
  --latex-header FILE Custom LaTeX header file
```

### preview-pdf.sh

```
Usage: preview-pdf.sh <input.pdf> [output-dir]

Output:
  Creates PNG files in output-dir (default: same directory as PDF)
  Named as: <basename>-page-001.png, <basename>-page-002.png, etc.
```

## Building locally

```bash
docker build -t pandoc-pdf-ja .
```

## License

MIT
