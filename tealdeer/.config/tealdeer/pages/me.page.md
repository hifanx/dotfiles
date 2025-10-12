# find

> My custom commands.

- Edit remote files via ssh

```bash
vim scp://xuhaifan@10.0.0.12/home/xuhaifan/docker/compose.yml
```

- Hard link dirs to a new location: first half creates the dirs (DFS), second half links the files.

```bash
find {{dirA dirB}} -type d -exec mkdir -p {{/new/path/{} }}\; -o -type f -exec ln {{/old/path/{} }}{{/new/path/{} }}\;
```

- Search files in a given dir that is not hard linked

```bash
find {{dirA dirB}} -type f \( -name '*.mp4' -o -name '*.mkv' \) -links 1
```
