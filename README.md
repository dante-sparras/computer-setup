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

## Development

To make changes to the dotfiles, you can edit the files in the `~/.local/share/chezmoi` directory. After making changes, you can apply them with the following command:

```bash
chezmoi apply -v
```

To commit changes to the dotfiles, you can use the following commands:

```bash
cd ~/.local/share/chezmoi
git add .
git commit -m "Your commit message"
git push origin main
```
