---
title: "Pandoc PDF Japanese Conversion Test"
author: "pandoc-pdf-ja"
---

# Pandoc PDF Japanese Conversion Test

This document is a sample for testing PDF conversion with Japanese text support.

## Text Formatting

### Basic Formatting

This is a paragraph with **bold text**, *italic text*, and ***bold italic text***.

You can also use ~~strikethrough~~ and `inline code` formatting.

### Links

Visit the [Pandoc official website](https://pandoc.org/) for more information.

## Lists

### Unordered List

- Item 1
- Item 2
  - Nested item 2.1
  - Nested item 2.2
- Item 3

### Ordered List

1. First item
2. Second item
   1. Nested item 2.1
   2. Nested item 2.2
3. Third item

## Code Blocks

### Python Example

```python
def greet(name: str) -> str:
    """Return a greeting message."""
    return f"Hello, {name}!"

if __name__ == "__main__":
    print(greet("World"))
```

### Bash Example

```bash
#!/bin/bash
# Convert markdown to PDF
docker run --rm -v "$(pwd):/workspace" ghcr.io/intoffset/pandoc-pdf-ja input.md
```

## Blockquotes

> This is a blockquote.
> It can span multiple lines.
>
> > Nested blockquotes are also supported.

## Tables

| Feature | Supported | Notes |
|---------|-----------|-------|
| Headings | Yes | h1-h6 |
| Lists | Yes | Ordered and unordered |
| Code blocks | Yes | With syntax highlighting |
| Tables | Yes | GitHub-flavored markdown |

## Japanese Text

### 日本語テキストのテスト

これは日本語のテキストです。PDF変換ツールが日本語を正しく処理できるかテストしています。

日本語には**太字**や*斜体*、`インラインコード`も使用できます。

### 複数段落のテスト

最初の段落です。Pandocは多くのドキュメント形式間の変換をサポートする強力なツールです。

2番目の段落です。このプロジェクトはDockerを使用して、日本語のMarkdownファイルをPDFに変換します。フォントやレイアウトの設定が事前に構成されているため、すぐに使用できます。

3番目の段落です。技術文書やレポートの作成に活用できます。

### 日本語の表

| 項目 | 説明 | 状態 |
|------|------|------|
| 見出し | h1〜h6をサポート | ✅ |
| リスト | 番号付き・番号なし | ✅ |
| コード | シンタックスハイライト | ✅ |
| 表 | GFM形式 | ✅ |

## Emoji Test

Here are some emojis for testing:

- Celebration: 🎉
- Books: 📚
- Check mark: ✅
- Rocket: 🚀
- Star: ⭐

## Horizontal Rule

---

## Conclusion

If this document converts to PDF correctly with proper Japanese font rendering, the tool is working as expected.

変換が正常に完了し、日本語フォントが正しくレンダリングされていれば、ツールは期待通りに動作しています。
