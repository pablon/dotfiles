# Contributing

1. Follow the established naming conventions and coding standards
2. Write comprehensive tests for new features
3. Update documentation for any changes
4. Ensure security best practices are followed

Feel free to use this repository as inspiration for your own setup.

## Shell Script Standards

- **Strict Mode**: always use `set -euo pipefail`
- **Quoting**: always quote variables: `"${VAR}"`
- **Output helpers**: use `_info`, `_success`, `_error` (defined in `setup/.functions`)
- **Constants**: `readonly UPPERCASE`
- **Functions**: `lowercase_underscores()`

### Script Template

```bash
#!/usr/bin/env bash
########################################
# Description: <brief description>
# Author: https://github.com/<user>
# Compatibility: Linux & macOS (Bash 3.2+)
########################################
set -euo pipefail
source "$(dirname "${0}")/.functions"

main() {
    # Implementation
}
main "$@"
```

### Naming Conventions

| Type            | Convention              | Example                  |
| --------------- | ----------------------- | ------------------------ |
| Exported/Global | `UPPERCASE_UNDERSCORES` | `export OS="darwin"`     |
| Local variables | `lowercase_underscores` | `local_var="value"`      |
| Functions       | `lowercase_underscores` | `detect_os()`            |
| Constants       | `readonly UPPER`        | `readonly VERSION="1.0"` |

## Lua (Neovim) Standards

- 2-space indent, 120 char line width (see `.config/nvim/stylua.toml`)
- `lowercase_underscores` for variables and functions
- `pcall` for error-safe module loading

## Quality Checks

```bash
# Run all pre-commit hooks
pre-commit install && pre-commit run -a

# Individual hooks
pre-commit run shellcheck -a
pre-commit run yamllint -a

# Manual checks
shellcheck --severity=error script.sh
bash -n script.sh          # syntax check
stow -nv .                 # dry-run stow
```

**Pre-commit hooks**: shellcheck · yamllint · markdown-link-check · detect-private-key · check-added-large-files

## Git Workflow

- Use `bin/commit` for interactive conventional commits
- Branch prefix determines commit type automatically:

| Branch Prefix | Commit Type |
| ------------- | ----------- |
| `feat/`       | `feat:`     |
| `fix/`        | `fix:`      |
| `docs/`       | `docs:`     |

- GPG signing is enabled for all commits

## Security

- **Never** commit secrets, API keys, or credentials
- Use environment variables for sensitive config
- Set script permissions: `chmod 0755`
- Pre-commit hooks will block private keys and large files

## License

[GPL v3.0](LICENSE.md) — use, modify, and share freely.
