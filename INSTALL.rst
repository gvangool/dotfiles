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

Rocky Linux 9
-------------
- Install extra packages::

    sudo dnf install -y epel-release
    sudo dnf install -y vim zsh git mtr bind-utils wget curl htop tar bzip2 gzip xz
    sudo dnf install -y util-linux-user glibc-langpack-en
    sudo chsh -s $(which zsh) ${USERNAME:-root}
- Install pyenv::

    curl https://pyenv.run | bash
    sudo dnf install -y \
      make gcc zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel \
      openssl-devel tk-devel libffi-devel xz-devel libuuid-devel
- Install GitHub CLI::

    sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
    sudo dnf install -y gh
- `Install Tailscale <https://pkgs.tailscale.com/stable/#rhel-9>`_ and mark it
  as a trusted interface::

    firewall-cmd --add-interface=tailscale0 --zone=trusted


Amazon Linux 2
--------------
- Install base packages::

    sudo yum install -y git zsh util-linux-user

- Switch to zsh::

    sudo chsh -s $(which zsh) ec2-user


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

   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
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
