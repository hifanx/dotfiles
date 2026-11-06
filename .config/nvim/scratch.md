## nvim-surround

```text
Before (* = cursor)       Keys         After
some*text                 ysiw'        'sometext'
'some*text'               ysa'}        {'sometext'}
*hello world              ys$]         [hello world]
(wrap*ped)                ds(          wrapped
"swap* me"                cs"'         'swap me'
<p>ta*g</p>               cst<em><CR>  <em>tag</em>
```

## linux

- `!$` use the last argument from the previous command

```bash
mkdir -p very/long/path
cd !$
```

- `!!` repeats the very last command (like up arrow + enter)
  - you can also `sudo !!`
