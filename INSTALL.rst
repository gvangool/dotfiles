Installation
============
dotfiles
--------
::

  cd ~ && git clone https://github.com/gvangool/dotfiles.git && mv dotfiles/.git . && git reset --hard && git submodule update --init --recursive

Mac OS/OSX
----------
Install `Homebrew <https://brew.sh/>`_::

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
- Install build-tools (needed for rust)::

    sudo dnf groupinstall -y "Development Tools"
- Install GitHub CLI::

    sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
    sudo dnf install -y gh

- Install `Homebrew`_:

  .. code-block:: bash

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew bundle install --file=Brewfile.linux  # this will install cli tooling (from ``Brewfile.linux``).



Ubuntu 22.04
------------
- Install extra packages::

    sudo apt update
    sudo apt install -y vim git curl zsh bind9-utils htop tar bzip2 gzip xz-utils zstd
    sudo apt install -y mtr-tiny  # mtr exists in Debian but not Ubuntu?
- Switch to zsh::

    chsh -s $(which zsh)
- Extra Python (pyenv):

  .. code-block:: bash

     curl https://pyenv.run | bash
     # Build environment
     sudo apt install -y \
      build-essential libssl-dev zlib1g-dev \
      libbz2-dev libreadline-dev libsqlite3-dev curl llvm \
      libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
- Install `Homebrew`_:

  .. code-block:: bash

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  Run ``brew doctor`` to check that everything is as expected.

  Run ``brew bundle install --file=Brewfile.linux``, this will install cli tooling (from ``Brewfile.linux``).


OS Agnostic
-----------
Rust/cargo
~~~~~~~~~~
- Install rustup (with default stable toolchain)

  .. code-block:: bash

     curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
     source ~/.cargo/env
- Install tooling from `crates.io <https://crates.io/>`_:
  .. code-block:: bash

     cargo install watchexec-cli ripgrep fd-find sd
     cargo install just rage xh
     cargo install github-workflows-update cargo-update
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

uv
~~
``uv`` replaces ``pyenv`` and ``pipx``.

- `Install uv <https://docs.astral.sh/uv/getting-started/installation/>`_

- Install extra tools (pick which you need, e.g. isort is in most project
  replaced with `ruff <https://docs.astral.sh/ruff/>`_:

  .. code-block:: bash

    uv tool install aws-shell
    uv tool install black
    uv tool install docutils
    uv tool install httpie
    uv tool install isort
    uv tool install pyupgrade


Tailscale
~~~~~~~~~
Install `Tailscale <https://tailscale.com>`_ (`RHEL 9 <https://pkgs.tailscale.com/stable/#rhel-9>`_)

Configure firewall for Tailscale (allow incoming connection on all ports and using it as an exit-node):

.. code-block:: bash

   firewall-cmd --add-interface=tailscale0 --zone=trusted --permanent
   firewall-cmd --add-masquerade --zone=public --permanent
   firewall-cmd --add-rich-rule='rule family=ipv6 masquerade --permanent
