<div align=center>

Your dotfiles are how you personalize your system - These are mine.

![Linux](https://img.shields.io/badge/-Linux-gray.svg?style=plastic&logo=Linux)
![macOS](https://img.shields.io/badge/-macOS-gray.svg?style=plastic&logo=apple)

[Read the docs](docs/README.md) • [Try with docker](docs/docker.md)

</div>

---

**Prerequisites**: `git`, `sudo`

## Quick Start

```bash
git clone https://github.com/pablon/dotfiles.git ~/dotfiles && cd ~/dotfiles/
./setup.sh --help            # show all options
```

**Install**:

```bash
./setup.sh [install]         # full install (default)
```

**Update**:

```bash
./setup.sh update --dry-run  # preview changes without modifying anything
./setup.sh update            # pull changes, update plugins & re-stow
```

**Re-stow**:

```bash
# re-create all symlinks
stow -R . -t ~
```

## Contributing

[Contributing Guide](CONTRIBUTING.md) • [Code of Conduct](docs/CODE_OF_CONDUCT.md)
