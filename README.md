# Dotfiles

## Prerequisites

- [Chezmoi](https://chezmoi.io/)

# Set up a new machine

The following command will install all dotfiles:

```bash
chezmoi init --apply "dante-sparras"
```

# Update on an existing machine

The following command will pull and apply the latest changes to the dotfiles:

```bash
chezmoi update -v
```