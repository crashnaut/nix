# macOS Setup with Nix Flakes (5 Minutes)

A declarative macOS configuration using nix-darwin, Homebrew, and Home Manager.

## What You Get

- **System Packages**: vim, git, colima, gh, gnupg
- **GUI Apps**: Brave, Slack, Postman, Logseq, Telegram, WhatsApp, Dropbox
- **Developer Tools**: Xcode, DaVinci Resolve, Excalidraw
- **Shell**: Zsh with Oh My Zsh
- **Spotlight Integration**: All apps searchable via `⌘ + Space`

## Quick Setup (5 Minutes)

### 1. Install Nix (2 minutes)

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Restart your terminal after installation.

### 2. Clone & Customize (1 minute)

```bash
git clone <your-repo-url>
cd nix/mac
```

**Edit `flake.nix`**: Change `username` and `hostname` at the top of the file:
```nix
username = "your-username";  # Line 30
hostname = "your-hostname";  # Line 31
```

### 3. Apply Configuration (2 minutes)

```bash
nix run nix-darwin -- switch --flake .#your-hostname
```

Restart your terminal. Done! 🎉

## Daily Usage

### Update Everything
```bash
nix flake update
darwin-rebuild switch --flake .#your-hostname
```

### Add New Packages
Edit `environment.systemPackages` in `flake.nix`, then:
```bash
darwin-rebuild switch --flake .#your-hostname
```

### Add GUI Apps
Edit `casks` list in `flake.nix`, then rebuild.

## Troubleshooting

**Command not found: darwin-rebuild**
```bash
nix run nix-darwin -- switch --flake .#your-hostname
```

**Apps not in Spotlight**
Rebuild once more - the mac-app-util module needs to index them.

**Rollback if something breaks**
```bash
darwin-rebuild rollback
```

## Architecture Notes

- **Apple Silicon**: `aarch64-darwin` (default)
- **Intel Mac**: Change line 96 to `system = "x86_64-darwin";`

## Resources

- [Nix Package Search](https://search.nixos.org/packages)
- [Homebrew Cask Search](https://formulae.brew.sh/cask/)
- [nix-darwin Docs](https://github.com/LnL7/nix-darwin)

