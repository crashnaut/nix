# Keeping Your System Updated

This guide helps you stay up-to-date when this repository adds new features, packages, or improvements.

## Quick Update Process

### 1. Pull Latest Changes

```bash
cd <path-to-this-repo>/<your-platform>  # mac, linux, or windows
git pull origin main
```

### 2. Review What Changed

```bash
# See what's new in the flake
git log --oneline --since="1 week ago"

# Or view the diff
git diff HEAD~1 flake.nix
```

### 3. Update Your Local Customizations

If you've customized your `flake.nix` (username, added packages, etc.), you'll need to merge changes:

**Option A: Stash, pull, reapply** (Recommended)
```bash
git stash                    # Save your customizations
git pull origin main         # Get latest changes
git stash pop                # Reapply your customizations
# Resolve any conflicts if needed
```

**Option B: Manual merge**
```bash
# Keep your flake.nix as is
# Review new flake.nix and manually add features you want
```

### 4. Apply Updates to Your System

**macOS:**
```bash
cd mac/
darwin-rebuild switch --flake .#your-hostname
```

**Linux:**
```bash
cd linux/
home-manager switch --flake ~/.config/nix#your-username
# Or if running from repo: nix run home-manager/master -- switch --flake .#your-username
```

**Windows (WSL2):**
```bash
cd windows/
home-manager switch --flake ~/.config/nix#your-username
# Or if running from repo: nix run home-manager/master -- switch --flake .#your-username
```

### 5. Test Everything Works

```bash
# Verify packages are available
which vim git gh

# For GUI apps (Mac), check Spotlight
# Press ⌘ + Space and search for your apps
```

## Staying in Sync

### Watch for Updates

Star and watch this repo on GitHub to get notified of updates:
- New packages added
- Bug fixes
- Performance improvements
- Security updates

### Update Frequency Recommendations

- **Weekly**: Quick `git pull` and review changes
- **Monthly**: Full rebuild with latest packages
- **As needed**: When you hear about important Nix/package updates

## Handling Conflicts

If `git pull` shows conflicts in `flake.nix`:

```bash
# 1. See what conflicts exist
git status

# 2. Open flake.nix in your editor
# Look for conflict markers: <<<<<<<, =======, >>>>>>>

# 3. Keep your customizations + new features
# Usually you want:
# - Your username/hostname (from YOUR section)
# - New packages/features (from INCOMING section)

# 4. After resolving:
git add flake.nix
git commit -m "Merged upstream updates with local customizations"
```

## Adding New Features Selectively

You don't have to adopt every change. Pick what you need:

### New Package Added to Repo?

```nix
# In flake.nix, add to your packages list:
environment.systemPackages = with pkgs; [  # Mac
  # Your existing packages...
  new-package-name  # Add this
];

# Or for Linux/Windows:
home.packages = with pkgs; [
  # Your existing packages...
  new-package-name  # Add this
];
```

### New Configuration Option Added?

Copy the relevant section from the updated flake into yours.

Example: New shell alias added?
```nix
shellAliases = {
  # Your existing aliases...
  newAlias = "some-command";  # Add this
};
```

## Rollback if Something Breaks

Nix makes rollback easy:

**macOS:**
```bash
darwin-rebuild rollback
# Or list generations and choose one:
darwin-rebuild --list-generations
darwin-rebuild switch --rollback
```

**Linux/Windows:**
```bash
home-manager generations  # List available versions
/nix/store/...-home-manager-generation/activate  # Use path from list
```

## Pro Tips for Smooth Updates

1. **Fork this repo** - Keep your customizations in your fork, pull upstream updates
2. **Separate custom configs** - Put your unique stuff in a separate file you import
3. **Document your changes** - Add comments in flake.nix for what you customized
4. **Test in a VM first** - For major updates, test before applying to main machine
5. **Join the community** - Watch GitHub issues for known problems with updates

## Getting Help

If updates cause issues:

1. **Check the commit messages** - See what changed and why
2. **Review platform README** - Updated docs might explain changes
3. **Rollback** - Use the commands above to revert
4. **Open an issue** - Report problems on GitHub

## Platform-Specific Guides

For detailed platform instructions:
- [Mac README](./mac/README.md)
- [Linux README](./linux/README.md)
- [Windows README](./windows/README.md)

