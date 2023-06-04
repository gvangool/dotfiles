Installation
============
dotfiles
--------
::

  cd ~ && git clone https://github.com/gvangool/dotfiles.git && mv dotfiles/.git . && git reset --hard && git submodule update --init --recursive

MacOS/OSX
---------
Install `Homebrew <https://brew.sh/>`__::

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

Run ``brew doctor`` to check that everything is as expected
(``/usr/local/share/zsh`` was not writeable for current user on Big Sur).

Sign into App Store (before running the rest of the Homebrew commands).

Run ``brew bundle``, this will install cli tooling, dmg's and Mac Store apps
(from ``Brewfile``).

Settings: Keyboard
~~~~~~~~~~~~~~~~~~
- Keyboard > Modifier Keys > Caps lock (map to Escape)
- Text:

  - Disable "Correct spelling automatically"
  - Disable "Capitalize words automatically"
  - Disable "Add period with double-space"
  - Disable "Use smart quotes and dashes"
- Shortcuts > Spotlight (disable or remap, want to use cmd + space for Alfred)

Rocky Linux 8
-------------
- Install extra packages::

    sudo dnf install -y git zsh epel-release
    sudo dnf install -y tofrodos
    sudo chsh -s $(which zsh) ${USERNAME:-root}
- Configure papertrail (with TLS!)
- `Install docker
  <https://docs.docker.com/install/linux/docker-ce/centos/>`__

Desktop/laptop
~~~~~~~~~~~~~~
- Install NTFS tools::

    sudo dnf install -y ntfs-3g ntfsprogs
- Extra fonts::

    sudo dnf install -y fira-code-fonts
- Install VLC::

    sudo dnf install https://download1.rpmfusion.org/free/el/rpmfusion-free-release-8.noarch.rpm
    sudo dnf install -y vlc

Amazon Linux 2
--------------
- Install base packages::

    sudo yum install -y git zsh util-linux-user

- Switch to zsh::

    sudo chsh -s $(which zsh) ec2-user


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

Ubuntu 20.04
------------
- Install extra packages::

    sudo apt install -y vim git tofrodos curl zsh
- Switch to zsh::

    chsh -s $(which zsh)
- Install `Homebrew <https://brew.sh/>`__:

  .. code-block:: bash

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  Run ``brew doctor`` to check that everything is as expected.

  Run ``brew bundle install --file=Brewfile.linux``, this will install cli tooling (from ``Brewfile.linux``).

- Extra fonts::

    sudo apt install fonts-firacode -y

- Extra python pyenv (installed through ``brew install pyenv``):

  .. code-block:: bash

     # Build environment
     sudo apt-get install -y \
       make build-essential libssl-dev zlib1g-dev \
       libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
       libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

     brew install bzip2 libffi libxml2 libxmlsec1 openssl readline sqlite xz zlib


Cargo
-----
.. code-block:: bash

   curl https://sh.rustup.rs -sSf | sh
   source ~/.cargo/env

Tools
~~~~~
.. code-block:: bash

   cargo install watchexec-cli ripgrep fd-find sd
   cargo install just rage
   cargo install tfdoc --git https://github.com/gvangool/tfdoc --branch bin-name
   cargo install --git https://github.com/ogham/dog dog

Alacritty
~~~~~~~~~
Getting the `dependencies
<https://github.com/alacritty/alacritty/blob/master/INSTALL.md#dependencies>`__ installed.

.. code-block:: bash

    cd ~/src
    git clone https://github.com/alacritty/alacritty.git
    cd alacritty
    cargo build --release

pipx
----
After installing a recent Python (``pyenv install 3.10``), you should also
install pipx

.. code-block:: bash

    pyenv exec python -m pip install pipx
    pipx install aws-shell black httpie isort pip-tools pyupgrade
