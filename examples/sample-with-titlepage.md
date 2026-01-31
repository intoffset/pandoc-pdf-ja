---
title: "Pandoc PDF Japanese Conversion Test"
author: "Test Author"
date: "2026-01"
---

# Introduction

This document tests the title page feature with YAML frontmatter.

## Text Formatting

This is a paragraph with **bold text**, *italic text*, and ***bold italic text***.

Visit the [Pandoc official website](https://pandoc.org/) for more information.

## Code Block

```python
def greet(name: str) -> str:
    """Return a greeting message."""
    return f"Hello, {name}!"
```

## Japanese Text

### 日本語テキストのテスト

これは日本語のテキストです。PDF変換ツールが日本語を正しく処理できるかテストしています。

### 日本語の表

| 項目 | 説明 | 状態 |
|------|------|------|
| 見出し | h1〜h6をサポート | ✅ |
| リスト | 番号付き・番号なし | ✅ |

## Emoji Test

- Celebration: 🎉
- Rocket: 🚀
