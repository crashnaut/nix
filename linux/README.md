# Linux (Ubuntu/PopOS) Setup with Nix Flakes (5 Minutes)

A declarative Linux configuration using home-manager. Works on Ubuntu, PopOS, and other Linux distributions.

## What You Get

- **CLI Tools**: vim, git, gh, docker, curl, wget, htop, ripgrep, bat
- **GUI Apps**: Brave, Slack, Postman, Logseq, Telegram
- **Shell**: Zsh with Oh My Zsh (or Bash)
- **User-level packages** (no sudo required after initial Nix install)

## Quick Setup (5 Minutes)

### 1. Install Nix (2 minutes)

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Restart your terminal after installation.

### 2. Clone & Customize (1 minute)

```bash
git clone <your-repo-url>
cd nix/linux
```

**Edit `flake.nix`**: Change `username` at line 11:
```nix
username = "your-username";
```

### 3. Set Up Config Directory (30 seconds)

```bash
mkdir -p ~/.config/nix
cp flake.nix ~/.config/nix/
cd ~/.config/nix
```

### 4. Apply Configuration (90 seconds)

```bash
nix run home-manager/master -- switch --flake .#your-username
```

Restart your terminal. Done! 🎉

### 5. Set Zsh as Default (Optional)

```bash
chsh -s $(which zsh)
```

## Daily Usage

### Update Everything
```bash
update  # Alias for: home-manager switch --flake ~/.config/nix#your-username
```

Or manually:
```bash
cd ~/.config/nix
nix flake update
home-manager switch --flake .#your-username
```

### Add New Packages
Edit `home.packages` in `~/.config/nix/flake.nix`, then run `update`.

## Package Management

Unlike macOS homebrew or apt, all packages are installed to your **home directory**. No sudo needed!

- Packages live in: `~/.nix-profile/`
- Config lives in: `~/.config/nix/`

## Troubleshooting

**Command not found: home-manager**
```bash
nix run home-manager/master -- switch --flake ~/.config/nix#your-username
```

**Docker permission denied**
Add yourself to docker group:
```bash
sudo usermod -aG docker $USER
```
Then log out and back in.

**GUI apps not showing**
Some DEs need a restart to index new .desktop files:
```bash
update-desktop-database ~/.local/share/applications
```

## Architecture Notes

- **x86_64**: `x86_64-linux` (default, line 11)
- **ARM64**: Change to `aarch64-linux` if on ARM

## Resources

- [Nix Package Search](https://search.nixos.org/packages)
- [Home Manager Options](https://nix-community.github.io/home-manager/options.html)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)

