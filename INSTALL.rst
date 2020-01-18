Installation
============
dotfiles
--------
::

  cd ~ && git clone https://github.com/gvangool/dotfiles.git && mv dotfiles/.git . && git reset --hard && git submodule update --init --recursive

OSX
---
Install `Homebrew <https://brew.sh/>`__::

    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

Run ``brew bundle`` (which will install cli, dmg's and Mac Store apps).

CentOS 7
--------
- Configure papertrail (with TLS!)
- Install extra packages::

    yum install -y git zsh epel-release
    yum install -y hfsplus-tools kmod-hfsplus
    yum install -y ntfs-3g ntfsprogs
    yum install -y tofrodos
- Install VLC::

    sudo rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm
    sudo yum install -y vlc

- `Install docker
  <https://docs.docker.com/install/linux/docker-ce/centos/>`__

Fedora 23
---------
- Install extra packages::

    dnf install -y git zsh vim tofrodos
    dnf install -y hfsplus-tools kmod-hfsplus ntfs-3g ntfsprogs
- `Install docker
  <https://docs.docker.com/install/linux/docker-ce/fedora/>`__
- Install VLC (from `rpmfusion <http://rpmfusion.org>`_)::

    sudo su -c 'dnf install http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm'
    sudo dnf install -y vlc

Ubuntu 18.04
------------
- Install extra packages::

    sudo apt install -y vim git tofrodos curl zsh
- Switch to zsh::

    chsh -s $(which zsh)
- `Install docker
  <https://docs.docker.com/install/linux/docker-ce/ubuntu/>`__
- Install tmux (3.0a)::

    wget https://github.com/tmux/tmux/releases/download/3.0a/tmux-3.0a.tar.gz -O tmux-3.0a.tar.gz
    tar -xzf tmux-3.0a.tar.gz
    cd tmux-3.0a
    ./configure && make
- Extra fonts::

    apt-get install fonts-firacode -y
- Rust setup::

    curl https://sh.rustup.rs -sSf | sh
    source ~/.cargo/env
  - Alacritty setup::

      cd ~/src
      git clone https://github.com/jwilm/alacritty.git
      cd alacritty
      sudo apt-get install cmake libfreetype6-dev libfontconfig1-dev xclip -y
      cargo build release
  - Tools from cargo::

      cargo install watchexec ripgrep fd-find
- Extra python configuration:

  - pyenv::

      git clone https://github.com/pyenv/pyenv.git ~/.pyenv
      # Build environment
      sudo apt-get install -y \
        make build-essential libssl-dev zlib1g-dev \
        libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
        libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev \
        liblzma-dev python-openssl
