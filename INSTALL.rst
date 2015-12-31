Installation
============
OSX
---
- Get Xcode from App store (or online commandline tools)
- Install Homebrew and install instructions from ``Brewfile``


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
  <https://docs.docker.com/engine/installation/centos/#install-with-yum>`_
- Install `direnv <http://direnv.net>`_ and::

    git clone https://github.com/direnv/direnv ~/src/direnv
    docker run --rm -v ~/src/direnv:/usr/src/direnv -w /usr/src/direnv golang:1.5 make
    cp ~/src/direnv/direnv ~/bin/

Fedora 23
---------
- Install extra packages::
    dnf install -y git zsh vim tofrodos
    dnf install -y hfsplus-tools kmod-hfsplus ntfs-3g ntfsprogs
- `Install docker
  <https://docs.docker.com/engine/installation/fedora/#install-with-yum>`_
- Install `direnv`_ and::

    git clone https://github.com/direnv/direnv ~/src/direnv
    docker run --rm -v ~/src/direnv:/usr/src/direnv -w /usr/src/direnv golang:1.5 make
    cp ~/src/direnv/direnv ~/bin/
- Install VLC (from `rpmfusion <http://rpmfusion.org>`_)::

    sudo su -c 'dnf install http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm'
    sudo dnf install -y vlc
