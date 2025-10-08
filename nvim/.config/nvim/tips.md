# MY PERSONAL TIPS & TRICKS

## Misc

```vim
" Show `filetype`
:set ft?
" List of events
:help autocmd-events
" Display all LSP methods
vim.print(vim.lsp.protocol.Methods)
```

## Registers

```vim
"ay3j " Yank down 3 lines into resister `a`
"ap " Paste the content of resister `a`
```

## Macros

```vim
qa " start recording in register `a`
0f"r';r' " do your thing
q " stop recording
@a " run the macro
@@ " repeat the last macro
```
