# Mac nix-darwin System Configuration

This repository contains a Nix flake configuration for managing system packages and applications on macOS using nix-darwin. It provides a declarative way to install and manage software on your Mac.

## What This Does

This configuration will:
- Install essential applications like Slack, Brave browser, Postman, Logseq, Obsidian, and development tools
- Make GUI applications properly discoverable in Spotlight and Launchpad (no more missing apps!)
- Enable Nix flakes and experimental features
- Allow installation of unfree software (proprietary applications)
- Manage your system configuration declaratively

## Prerequisites

You'll need:
- A Mac (this configuration is specifically for Apple Silicon/ARM64 Macs)
- Administrator access
- Internet connection

## Initial Setup (Fresh Mac Mini)

### 1. Install Nix Package Manager

First, install the Nix package manager using the official installer:

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

After installation completes, restart your terminal or run:
```bash
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

### 2. Verify Nix Installation

Check that Nix is properly installed:
```bash
nix --version
```

You should see output showing the Nix version.

### 3. Clone This Repository

```bash
git clone <repository-url>
cd nix
```

### 4. Apply the Configuration

Run the following command to apply the nix-darwin configuration:

```bash
nix run nix-darwin -- switch --flake .#mini
```

This command will:
- Download and install nix-darwin
- Apply the system configuration
- Install all specified packages
- Set up application aliases

### 5. Reload Your Shell

After the initial setup, restart your terminal or run:
```bash
exec $SHELL
```

## Daily Usage

### Updating Packages

To update all packages to their latest versions:

```bash
nix flake update
darwin-rebuild switch --flake .#mini
```

### Adding New Packages

1. Edit `flake.nix`
2. Add package names to the `environment.systemPackages` list
3. Apply changes:
   ```bash
   darwin-rebuild switch --flake .#mini
   ```

### Removing Packages

1. Remove package names from `environment.systemPackages` in `flake.nix`
2. Apply changes:
   ```bash
   darwin-rebuild switch --flake .#mini
   ```

## Installed Applications

This configuration installs:

### Development Tools
- **vim** - Text editor
- **colima** - Container runtime for Docker

### GUI Applications (Available in Spotlight and Launchpad)
- **Slack** - Team communication
- **Brave** - Privacy-focused web browser
- **Postman** - API development tool
- **Logseq** - Knowledge management
- **Obsidian** - Note-taking application

**Note**: All GUI applications are automatically made searchable in Spotlight and available in Launchpad thanks to the `mac-app-util` integration. You can launch any app using `⌘ + Space` and typing the app name.

## Key Features

### Spotlight Integration
This configuration uses [`mac-app-util`](https://github.com/hraban/mac-app-util) to ensure that all Nix-installed GUI applications are properly discoverable in:
- **Spotlight** - Launch apps with `⌘ + Space`
- **Launchpad** - Visual app launcher
- **Dock** - Pin apps and they'll stay pinned across updates

The integration creates "trampoline" launcher apps that macOS recognizes properly, solving the common issue where Nix-installed apps don't appear in Spotlight searches.

## File Structure

```
.
├── flake.nix     # Main configuration file
├── flake.lock    # Lock file with exact package versions
└── README.md     # This file
```

### Key Files Explained

- **`flake.nix`** - The main configuration file that defines:
  - Which packages to install
  - System settings
  - How applications are organized
  
- **`flake.lock`** - Automatically generated file that locks specific versions of all dependencies for reproducibility

## Customization

### Adding More Packages

You can find packages to add at [search.nixos.org](https://search.nixos.org/packages). Add them to the `environment.systemPackages` list in `flake.nix`.

Example:
```nix
environment.systemPackages = with pkgs; [
  vim colima slack brave postman logseq obsidian
  # Add new packages here:
  git
  node_21
  python3
];
```

### Changing System Configuration

The `configuration` section in `flake.nix` can be extended with additional nix-darwin options. See the [nix-darwin documentation](https://daiderd.com/nix-darwin/) for available options.

## Troubleshooting

### Command Not Found: darwin-rebuild

If `darwin-rebuild` command is not found after initial setup, try:
```bash
nix run nix-darwin -- switch --flake .#mini
```

### Permission Issues

If you encounter permission issues, ensure you're running commands as the user who installed Nix (not root).

### Applications Not Appearing

If GUI applications don't appear in Spotlight after rebuilding, try:
```bash
darwin-rebuild switch --flake .#mini
```

The `mac-app-util` module automatically creates proper launcher apps that are indexed by Spotlight and Launchpad.

### Rollback Changes

If something breaks, you can rollback to a previous generation:
```bash
darwin-rebuild rollback
```

## Uninstalling

To completely remove nix-darwin and Nix:

1. Remove the nix-darwin configuration:
   ```bash
   sudo /nix/var/nix/profiles/system/bin/darwin-uninstaller
   ```

2. Remove Nix completely:
   ```bash
   /nix/nix-installer uninstall
   ```

## Additional Resources

- [Nix Manual](https://nixos.org/manual/nix/stable/)
- [nix-darwin Documentation](https://daiderd.com/nix-darwin/)
- [Nixpkgs Package Search](https://search.nixos.org/packages)
- [Nix Flakes Guide](https://nixos.wiki/wiki/Flakes)

## Support

If you encounter issues:
1. Check the [nix-darwin GitHub repository](https://github.com/LnL7/nix-darwin) for known issues
2. Search [NixOS Discourse](https://discourse.nixos.org/) for solutions
3. Consult the Nix community on [Reddit r/NixOS](https://www.reddit.com/r/NixOS/)