# Diff Color Preview

This file lets you preview the diff background colors used by `DiffAdd`, `DiffChange`, and `DiffDelete`.
Open this file and run `:diffthis` on a split, or manually apply highlights with `:lua` to inspect.

---

## How the diff highlight groups are used

| Group        | Color key     | Used for                                      |
|--------------|---------------|-----------------------------------------------|
| `DiffAdd`    | `green_diff`  | Background of added lines in diff mode        |
| `DiffChange` | `orange_diff` | Background of changed lines in diff mode      |
| `DiffDelete` | `red_diff`    | Background of deleted lines in diff mode      |
| `DiffText`   | `c.yellow`    | Foreground of changed text within DiffChange  |
| `SpellLocal` | `blue_diff`   | Undercurl color for region-local spell words  |
| `Added`      | `c.green`     | Foreground in diff file syntax (git log etc.) |
| `Changed`    | `c.orange`    | Foreground in diff file syntax                |
| `Removed`    | `c.red`       | Foreground in diff file syntax                |

Note: `blue_diff` is not used for any `Diff*` background group — only for `SpellLocal` undercurl.

---

## Visual preview via extmarks

To paint blocks of each diff color directly in this buffer, run:

```vim
:lua require('colors.test.diff_preview').show()
```

Or paste this into the command line:

```lua
:lua (function()
  local c = require('palette').isekai
  local ns = vim.api.nvim_create_namespace('diff_preview')
  local buf = vim.api.nvim_get_current_buf()
  local groups = {
    { name = 'DiffAdd    (green_diff)  — added lines',   hl = 'DiffAdd'    },
    { name = 'DiffChange (orange_diff) — changed lines', hl = 'DiffChange' },
    { name = 'DiffDelete (red_diff)    — deleted lines', hl = 'DiffDelete' },
  }
  -- append lines and highlight them
  local start = vim.api.nvim_buf_line_count(buf)
  local lines = { '', '--- diff background preview ---' }
  for _, g in ipairs(groups) do
    lines[#lines+1] = '    ' .. g.name .. '    '
  end
  lines[#lines+1] = ''
  vim.api.nvim_buf_set_lines(buf, start, start, false, lines)
  for i, g in ipairs(groups) do
    local row = start + 1 + i  -- +1 for blank, +1 for header line, then each group
    vim.api.nvim_buf_add_highlight(buf, ns, g.hl, row, 0, -1)
  end
end)()
```

---

## Color values (current palette)

```
green_diff  = '#1E3A2A'   DiffAdd background
red_diff    = '#3D1520'   DiffDelete background
orange_diff = '#362410'   DiffChange background
blue_diff   = '#102840'   SpellLocal undercurl only
```

All four are intentionally dark and muted — visible as distinct regions against
base `#0D1117` without being distracting.
