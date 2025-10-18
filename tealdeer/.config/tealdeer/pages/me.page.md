# find

> My custom commands.

- Edit remote files via ssh, use `scp` if Oil.nvim removed

`nvim oil-ssh://xuhaifan@10.0.0.12//home/xuhaifan/docker/compose.yml`

- Hard link dirs to a new location: first half creates the dirs (DFS), second half links the files

`find {{dirA dirB}} -type d -exec mkdir -p {{/new/path/{} }}\; -o -type f -exec ln {{/old/path/{} }}{{/new/path/{} }}\;`

- Search files in a given dir that is not hard linked

`find {{dirA dirB}} -type f \( -name '*.mp4' -o -name '*.mkv' \) -links 1`
