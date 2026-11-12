# Linux

- !$ use the last argument from the previous command

  `mkdir -p very/long/path`
  `cd !$`

- !! repeats the very last command (like up arrow + enter)
  `!!`
  `sudo !!`

- Hard link dirs to a new location

> first half creates the dirs (DFS), second half links the files

`find {{dirA dirB}} -type d -exec mkdir -p {{/new/path/{} }}\; -o -type f -exec ln {{/old/path/{} }}{{/new/path/{} }}\;`

- Search files in a given dir that is not hard linked

`find {{dirA dirB}} -type f \( -name '*.mp4' -o -name '*.mkv' \) -links 1`

# unRAID

- Check public ipv6

  `ip -6 addr show dev eth0 scope global | awk '/inet6/{print $2}' | cut -d/ -f1`
