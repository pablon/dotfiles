<div align=center>

Your dotfiles are how you personalize your system - These are mine.

![Linux](https://img.shields.io/badge/-Linux-gray.svg?style=plastic&logo=Linux)
![macOS](https://img.shields.io/badge/-macOS-gray.svg?style=plastic&logo=apple)

</div>

---

# Install

Install required tools first:

- `git`
- `curl`
- `jq`

Clone this repo:

```bash
git clone https://github.com/pablon/dotfiles.git ~/dotfiles && cd ~/dotfiles/
```

Fresh installation:

```bash
./setup.sh
```

.. or just re-link:

```bash
( type stow &>/dev/null ) && ( cd ~/dotfiles/ && stow -v . )
```

---

# Uninstall

```bash
( cd ~/dotfiles/ && stow -vD . )
```

This unlinks all the files, but does not remove the actual files from your
system. You can then remove the `~/dotfiles` directory if you wish.

---

[Read the full docs here](docs/README.md).
