# Heading level 1 @markup.heading

## Heading level 2

### Heading level 3

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
