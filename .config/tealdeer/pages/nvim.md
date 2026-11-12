## nvim

- nvim-surround

```text
Before (* = cursor)       Keys         After
some*text                 ysiw'        'sometext'
'some*text'               ysa'}        {'sometext'}
*hello world              ys$]         [hello world]
(wrap*ped)                ds(          wrapped
"swap* me"                cs"'         'swap me'
<p>ta*g</p>               cst<em><CR>  <em>tag</em>
```

- Edit remote files via ssh

`nvim oil-ssh://xuhaifan@10.0.0.12//home/xuhaifan/docker/compose.yml`
`nvim scp://xuhaifan@10.0.0.12//home/xuhaifan/docker/compose.yml`
