# Dockerfile for PDF generation from Markdown using pandoc + LuaLaTeX
# Supports Japanese text and emoji rendering
FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo

# Install pandoc, texlive, Japanese fonts, emoji fonts, and ghostscript
RUN apt-get update && \
    apt-get install -y \
    pandoc \
    texlive-luatex \
    texlive-fonts-recommended \
    texlive-fonts-extra \
    texlive-latex-extra \
    texlive-lang-japanese \
    fonts-noto-cjk \
    fonts-noto-cjk-extra \
    fonts-noto-color-emoji \
    ghostscript \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /workspace

# Copy LaTeX header files and entrypoint script
COPY latex/ /latex/
COPY scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
