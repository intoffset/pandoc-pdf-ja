# pandoc-pdf-ja

日本語テキストと絵文字に対応した、MarkdownからPDFへの変換用Dockerイメージです。

## 特徴

- Noto Sans CJK JPによる日本語レンダリング
- Noto Color Emojiによる絵文字サポート
- 目次の自動生成（タイトルは「目次」）
- セクション番号付け
- カスタムLaTeXヘッダー
- PDFからPNGプレビュー画像の生成
- リンクの色付け（青系）
- コードブロックの背景色（薄いグレー）
- オプションの表紙ページ生成

## クイックスタート

### イメージの取得

```bash
docker pull ghcr.io/intoffset/pandoc-pdf-ja
```

### MarkdownからPDFへの変換

```bash
# 基本的な変換（input.pdf が生成される）
docker run --rm -v "$(pwd):/workspace" ghcr.io/intoffset/pandoc-pdf-ja input.md

# 出力ファイルを指定
docker run --rm -v "$(pwd):/workspace" ghcr.io/intoffset/pandoc-pdf-ja input.md -o output.pdf

# 目次付き
docker run --rm -v "$(pwd):/workspace" ghcr.io/intoffset/pandoc-pdf-ja input.md --toc

# 目次とセクション番号付き
docker run --rm -v "$(pwd):/workspace" ghcr.io/intoffset/pandoc-pdf-ja input.md --toc --number-sections

# 表紙付き（YAMLフロントマターが必要）
docker run --rm -v "$(pwd):/workspace" ghcr.io/intoffset/pandoc-pdf-ja input.md --title-page --toc
```

### 表紙の使用方法

`--title-page`オプションを使用する場合、Markdownファイルの先頭にYAMLフロントマターを追加してください：

```markdown
---
title: "ドキュメントタイトル"
author: "著者名"
date: "2026年1月"
---

# 本文の最初の見出し
...
```

### pandocを直接実行

`pandoc`を最初の引数にすると、デフォルト設定をバイパスして直接pandocを実行できます：

```bash
docker run --rm -v "$(pwd):/workspace" ghcr.io/intoffset/pandoc-pdf-ja pandoc --version
```

### ヘルパースクリプト

`scripts/`ディレクトリには追加のヘルパースクリプトがあります：

- `build-pdf.sh` - タイトルページやカスタムヘッダーなどの高度なオプション付き変換
- `preview-pdf.sh` - PDFからPNGプレビュー画像を生成

## ローカルでのビルド

```bash
docker build -t pandoc-pdf-ja ./docker
```

## ライセンス

MIT
