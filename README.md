<div align=center>

Your dotfiles are how you personalize your system - These are mine.

Simplicity is divine

![Linux](https://img.shields.io/badge/-Linux-gray.svg?style=plastic&logo=Linux) ![macOS](https://img.shields.io/badge/-macOS-gray.svg?style=plastic&logo=apple)

</div>

---

Clone:

```bash
git clone https://github.com/pablon/dotfiles.git ~/dotfiles && cd ~/dotfiles/
```

Fresh installation:

```bash
./setup.sh
```

.. or just link the files:

```bash
( type stow &>/dev/null ) && ( cd ~/dotfiles/ && stow -v . )
```
