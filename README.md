# pandoc-pdf-ja

日本語テキストと絵文字に対応した、MarkdownからPDFへの変換用Dockerイメージです。

## 特徴

- Noto Sans CJK JPによる日本語レンダリング
- Noto Color Emojiによる絵文字サポート
- 目次の自動生成
- セクション番号付け
- カスタムLaTeXヘッダー
- PDFからPNGプレビュー画像の生成

## クイックスタート

### イメージの取得

```bash
docker pull ghcr.io/intoffset/pandoc-pdf-ja
```

### MarkdownからPDFへの変換

```bash
docker run --rm -v "$(pwd):/workspace" -w /workspace \
  ghcr.io/intoffset/pandoc-pdf-ja \
  pandoc input.md \
    --pdf-engine=lualatex \
    --include-in-header=/latex/header.tex \
    -V geometry:margin=2cm \
    -V documentclass=article \
    -V classoption=a4paper \
    -o output.pdf
```

### ヘルパースクリプトの使用

`scripts/`ディレクトリからスクリプトをダウンロードして使用できます：

```bash
# MarkdownからPDFへ変換
./scripts/build-pdf.sh input.md output.pdf

# 目次とセクション番号付きで変換
./scripts/build-pdf.sh input.md output.pdf --toc --number-sections

# プレビュー画像を生成
./scripts/preview-pdf.sh output.pdf preview/
```

## スクリプトオプション

### build-pdf.sh

```
使用方法: build-pdf.sh <input.md> <output.pdf> [options]

オプション:
  --toc               目次を含める
  --number-sections   セクションに番号を付ける
  --title-page FILE   タイトルページ用のMarkdownファイルを先頭に追加
  --latex-header FILE カスタムLaTeXヘッダーファイルを使用
```

### preview-pdf.sh

```
使用方法: preview-pdf.sh <input.pdf> [output-dir]

出力:
  output-dir（デフォルト: PDFと同じディレクトリ）にPNGファイルを作成
  ファイル名: <basename>-page-001.png, <basename>-page-002.png, ...
```

## ローカルでのビルド

```bash
docker build -t pandoc-pdf-ja .
```

## ライセンス

MIT
