<div align=center>

# dotfiles

Your dotfiles are how you personalize your system. These are mine.

I went back & forth scripting & bootstrapping dotfiles, but after time ended once more embracing _KISS_ philosophy.

**Simplicity is divine**.

![Linux](https://img.shields.io/badge/-Linux-gray.svg?style=plastic&logo=Linux) ![macOS](https://img.shields.io/badge/-macOS-gray.svg?style=plastic&logo=apple)

</div>

---

### Link dotfiles to a new machine with [stow](https://www.gnu.org/software/stow/manual/stow.html)

```bash
stow -vt .
```

### Homebrew installation

```bash
# Leaving a machine
brew leaves > ~/dotfiles/leaves.txt

# Fresh installation
xargs brew install < ~/dotfiles/leaves.txt
```
