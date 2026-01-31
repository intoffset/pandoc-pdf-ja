# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

pandoc-pdf-ja is a Docker image for converting Markdown to PDF with Japanese text and emoji support. It uses Pandoc with LuaLaTeX engine, Noto fonts for Japanese/emoji rendering, and includes pre-configured LaTeX headers.

## Common Commands

### Build Docker image locally
```bash
docker build -t pandoc-pdf-ja ./docker
```

### Convert Markdown to PDF (using Docker)
```bash
# Basic conversion
docker run --rm -v "$(pwd):/workspace" ghcr.io/intoffset/pandoc-pdf-ja input.md -o output.pdf

# With table of contents and section numbers
docker run --rm -v "$(pwd):/workspace" ghcr.io/intoffset/pandoc-pdf-ja input.md --toc --number-sections -o output.pdf

# With title page (requires YAML frontmatter)
docker run --rm -v "$(pwd):/workspace" ghcr.io/intoffset/pandoc-pdf-ja input.md --title-page --toc -o output.pdf
```

### Helper scripts
```bash
# Build PDF with advanced options
./scripts/build-pdf.sh input.md output.pdf --toc --number-sections

# Generate PNG preview from PDF
./scripts/preview-pdf.sh input.pdf [output-dir]
```

## Architecture

```
docker/
├── Dockerfile           # Ubuntu 22.04 + pandoc + texlive + fonts
├── latex/
│   ├── header.tex       # Main LaTeX header (fonts, TOC, hyperlinks, code blocks)
│   ├── titlepage.tex    # Optional title page template
│   └── emojialchar.tex  # Emoji character class definitions for LuaTeX
└── scripts/
    └── entrypoint.sh    # Container entrypoint with default pandoc options

scripts/
├── build-pdf.sh         # Host-side helper for PDF generation
└── preview-pdf.sh       # Host-side helper for PDF to PNG conversion
```

### Key Components

- **entrypoint.sh**: Parses arguments and applies default pandoc options (lualatex engine, A4 paper, 2cm margins). Supports `--title-page` flag and passes through other pandoc options.
- **header.tex**: Configures Noto fonts with emoji fallback, Japanese TOC title ("目次"), code block styling, hyperlink colors, and table formatting.
- **titlepage.tex**: LaTeX template using `\@title`, `\@author`, `\@date` macros from YAML frontmatter.

### CI/CD

GitHub Actions workflow (`.github/workflows/docker-publish.yml`) builds and pushes to Docker Hub on main branch pushes and tags.
