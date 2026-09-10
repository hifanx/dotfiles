---
title: "Neovim Markdown Test Document"
author: "Test User"
date: 2026-09-05
tags: [markdown, testing, neovim]
---

# Heading level 1

## Heading level 2

### Heading level 3

#### Heading level 4

##### Heading level 5

###### Heading level 6

Some **bold text** for @markup.strong.
Some _italic text_ for @markup.italic.
Some ~~strikethrough text~~ for @markup.strikethrough.
Some ++underlined text++ for @markup.underline (if supported).

> This is a quoted block for @markup.quote.

Inline code `x + y` is @markup.raw.

```python
# Fenced code block for @markup.raw.block
print("hello from markdown code block")
```

Math inline: $E = mc^2$ is @markup.math.

$$
E = mc^2
$$

- Item one in a list -> @markup.list
- Item two in a list

1. This is one.
   1. This is one.one
   2. This is one.two
2. This is two.
3. This is three.

- [x] Completed todo item -> @markup.list.checked
- [ ] Pending todo item -> @markup.list.unchecked

Here is a [link label](https://example.com/docs) to show:

- [link label]: @markup.link.label
- URL: @markup.link.url
- whole link: @markup.link

> [!NOTE]
> This is a note

> [!WARNING]
> This is a warning

> [!ERROR]
> This is an error

---

<!-- This is an HTML comment. It should NOT render visibly. -->

# H1 — Main Title

## H2 — Section Heading

### H3 — Subsection

#### H4 — Minor Heading

This is a regular paragraph of body text, used as a baseline to compare
against styled variants below. It wraps across multiple lines to check
how your setup handles line reflow and paragraph spacing.

**Bold text**, _italic text_, and **_bold italic text_** all in one line.
Here's also **alternate bold**, _alternate italic_, and ~~strikethrough
text~~ for good measure. You can even mix _**bold, *nested italic*,**_
inside a sentence.

Inline `code snippet` sits right in the middle of a sentence like this.

> A blockquote.
> It can span multiple lines,
>
> > and even nest another blockquote inside it.

Horizontal rule below:

---

## Lists

Unordered list:

- First item
- Second item
  - Nested item
  - Another nested item
- Third item

Ordered list:

1. Step one
2. Step two
   1. Sub-step A
   2. Sub-step B
3. Step three

Task list:

- [x] Completed task
- [ ] Incomplete task
- [ ] Another pending task

## Links and Images

[A hyperlink to Neovim's site](https://neovim.io)

![Alt text for an image](https://example.com/image.png "Optional title")

## Code Block

```python
def greet(name: str) -> str:
    """Return a greeting string."""
    return f"Hello, {name}!"

print(greet("world"))
```

## Table

| Feature    | Supported | Notes          |
| ---------- | :-------: | -------------- |
| Headers    |    ✅     | H1–H6          |
| Tables     |    ✅     | With alignment |
| Task lists |    ✅     | GFM extension  |
| Footnotes  |    ✅     | See below      |

## Footnotes

Here's a sentence with a footnote reference.[^1]

[^1]: This is the footnote content, shown at the bottom of the document.

## Extended Syntax

Some renderers support ==highlighted text==, H~~2~~O (subscript), and
X^2^ (superscript).

## Escaped Characters

\*Not italic\*, \`not code\`, \# not a heading.

The end.
