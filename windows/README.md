# Windows (WSL2) Setup with Nix Flakes (5 Minutes)

A declarative Windows development environment using WSL2 and home-manager.

## What You Get

- **CLI Tools**: vim, git, gh, curl, wget, htop, ripgrep, bat
- **Shell**: Zsh with Oh My Zsh in WSL2
- **WSL Integration**: Access Windows files, launch Windows apps
- **Docker Desktop Integration**: Use Docker from WSL2
- **User-level packages** (no admin required after initial setup)

## Prerequisites

- Windows 10/11 with WSL2 enabled
- Ubuntu or Debian WSL2 distribution installed

## Quick Setup (5 Minutes)

### 1. Enable WSL2 (Skip if already done)

In PowerShell (Admin):
```powershell
wsl --install
```

Restart your computer, then set up your Ubuntu username/password.

### 2. Install Nix in WSL2 (2 minutes)

Open Ubuntu from Start Menu, then:

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Restart your WSL terminal after installation.

### 3. Clone & Customize (1 minute)

```bash
git clone <your-repo-url>
cd nix/windows
```

**Edit `flake.nix`**: Change `username` at line 11:
```nix
username = "your-username";  # Your WSL username
```

### 4. Set Up Config Directory (30 seconds)

```bash
mkdir -p ~/.config/nix
cp flake.nix ~/.config/nix/
cd ~/.config/nix
```

### 5. Apply Configuration (90 seconds)

```bash
nix run home-manager/master -- switch --flake .#your-username
```

Restart your terminal. Done! 🎉

### 6. Set Zsh as Default (Optional)

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

## Windows Integration

### Access Windows Files
```bash
cdwin  # Goes to /mnt/c/Users/your-username
cd /mnt/c/  # Access C: drive
```

### Open Windows Explorer
```bash
explorer .  # Opens current directory in Windows Explorer
```

### Install Docker Desktop

1. Download [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop/)
2. Enable "Use WSL 2 based engine" in settings
3. Docker commands work from WSL2 automatically

### Install GUI Apps

For GUI apps (Slack, Postman, etc.), install them natively on Windows:
- Use `winget` (Windows Package Manager)
- Or download installers directly

WSL2 can run Linux GUI apps with WSLg, but Windows-native apps perform better.

## Troubleshooting

**Command not found: home-manager**
```bash
nix run home-manager/master -- switch --flake ~/.config/nix#your-username
```

**WSL2 not installed**
```powershell
# In PowerShell (Admin)
wsl --install -d Ubuntu
```

**Slow filesystem**
Keep projects in WSL filesystem (`~/projects`) not Windows (`/mnt/c/`).

**Docker not working**
Ensure Docker Desktop is running on Windows with WSL2 integration enabled.

## File System Tips

- **Fast**: `~/` (WSL2 native filesystem)
- **Slow**: `/mnt/c/` (Windows filesystem)

Keep your code in `~/projects` for best performance!

## Resources

- [Nix Package Search](https://search.nixos.org/packages)
- [Home Manager Options](https://nix-community.github.io/home-manager/options.html)
- [WSL2 Documentation](https://docs.microsoft.com/en-us/windows/wsl/)
- [Docker Desktop WSL2](https://docs.docker.com/desktop/windows/wsl/)

