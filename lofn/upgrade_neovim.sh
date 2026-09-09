# there's no prebuilt slackware for unRAID, so I'm building my own
mkdir -p /tmp/nvimbuild/usr/local
cd /tmp/nvimbuild
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
tar xzf nvim-linux-x86_64.tar.gz -C usr/local --strip-components=1
rm nvim-linux-x86_64.tar.gz

VER=$(usr/local/bin/nvim --version | head -1 | awk '{print $2}' | tr -d v)

# optional post-install step baked into the package: make `vim` run nvim too
mkdir -p install
cat >install/doinst.sh <<'EOF'
( cd usr/local/bin && ln -sf nvim vim )
EOF

makepkg -l y -c n /boot/extra/neovim-${VER}-x86_64-1local.txz
installpkg /boot/extra/neovim-${VER}-x86_64-1local.txz # installs now, no reboot needed
