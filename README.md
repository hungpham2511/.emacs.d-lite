# A lite emacs configuration

## Installation

To configure emacs to use the configuration files in this directory,
run the following commands:

```sh
mkdir ~/.emacs.d
sudo apt install stow
stow emacs
```

This will create symlinks in `~/.emacs.d` to the configuration files
in this repository. Now you can start `emacs` and it will use the new
configuration.

Tested on emacs version.

```
GNU Emacs 29.3
Development version ae8f815613c2 on HEAD branch; build date 2024-05-20.
```

It should work fine an emacs version 27 and above.

## What's included?

- Manage packages with `straight.el`.
- Vim-like keybindings using `evil-mode`.
- Magit for git integration.
- Github co-pilot integration with `copilot.el`.
- Auto-completion with `corfu`.
- Stupid overview of a python script with `C-c C-o`
- LSP with `eglot`. For python use `python-lsp`, for C/C++ use `clangd`.

Tip: Use `M-x` to search for commands. The keybindings for commands
are also shown in the minibuffer that appears with `M-x` so you can
remember what you need.

## Map Caps Lock to Control

Strongly recommended to map the `Caps Lock` key to `Control` when you
use emacs. This is because the `Control` key is used very frequently
in emacs and you will save yourself a lot of finger strain by using
the `Caps Lock` key instead.

## Multiple emacs instances

This configuration is lightweight and you can run multiple instances
of emacs without any issues. This is useful when you want to switch
between different python virtual environments for different projects.

From my personal experience, I have found that starting a new emacs
instance *after* activating a virtual environment is the best way to
work with python.




