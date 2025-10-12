# The SDET's 5-Minute Machine Setup with Nix Flakes

> **Reproducible development environments for Mac, Linux, and Windows in 5 minutes.**

Stop spending hours setting up new machines. With Nix flakes, you can have a fully configured development environment with all your tools, apps, and dotfiles in **just 5 minutes**.

## Why Nix Flakes?

✅ **Declarative**: Your entire setup in one configuration file  
✅ **Reproducible**: Same setup on every machine, every time  
✅ **Atomic**: Updates succeed or rollback automatically  
✅ **Cross-platform**: Works on Mac, Linux, and Windows (WSL2)  
✅ **Version Control**: Track your environment like code  

## Choose Your Platform

Select your operating system to get started:

### 🍎 [macOS Setup](./mac/README.md)
Perfect for MacBooks and Mac desktops. Includes:
- nix-darwin for system-level config
- Homebrew integration for GUI apps
- Spotlight/Launchpad integration
- MAS (Mac App Store) automation

**[→ Start Mac Setup](./mac/README.md)**

---

### 🐧 [Linux Setup](./linux/README.md)
For Ubuntu, PopOS, and other Linux distributions. Includes:
- home-manager for user-level packages
- No sudo required (after Nix install)
- Docker integration
- Works on any Linux distro

**[→ Start Linux Setup](./linux/README.md)**

---

### 🪟 [Windows (WSL2) Setup](./windows/README.md)
Best Windows development experience using WSL2. Includes:
- Full Linux environment in Windows
- Windows filesystem integration
- Docker Desktop support
- Native performance

**[→ Start Windows Setup](./windows/README.md)**

---

## What's Included

Each platform configuration includes:

### Development Tools
- Git, GitHub CLI, Vim
- Docker/Colima
- Language-specific toolchains

### CLI Utilities
- Modern replacements: `ripgrep`, `bat`, `fd`
- System tools: `htop`, `curl`, `wget`
- Shell: Zsh with Oh My Zsh

### GUI Applications (Mac/Linux)
- **Browser**: Brave
- **Communication**: Slack, Telegram, WhatsApp
- **Productivity**: Logseq, Postman
- **Cloud**: Dropbox

## How It Works

1. **Install Nix** (one command, 2 minutes)
2. **Clone this repo** and customize username
3. **Run the flake** (one command, 2-3 minutes)
4. **Done!** All your apps and tools are ready

## The 5-Minute Setup Process

```bash
# Step 1: Install Nix (2 minutes)
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# Step 2: Clone and customize (1 minute)
git clone <your-repo-url>
cd nix/<your-platform>
# Edit flake.nix: Change username/hostname

# Step 3: Apply config (2 minutes)
# See platform-specific README for exact command

# That's it! 🎉
```

## Real-World Benefits

### For SDETs and QA Engineers
- **Consistent test environments** across team members
- **Quick CI/CD agent setup** using the same config
- **Test on multiple OS** with identical tool versions
- **Document setup as code** instead of wiki pages

### For Development Teams
- **Onboard new hires** in minutes, not days
- **Disaster recovery**: New machine setup is automatic
- **Eliminate "works on my machine"** problems
- **Version control your environment** alongside your code

### For Individual Developers
- **Multiple machines** stay in sync
- **Upgrade safely** with automatic rollback
- **Try new tools** without polluting your system
- **Clean state** whenever you need it

## Daily Usage

Once set up, managing your environment is simple:

```bash
# Update all packages
nix flake update
<platform-rebuild-command>

# Add a new package
# 1. Edit flake.nix
# 2. Run rebuild command

# Something broke? Rollback!
<platform-rollback-command>
```

See your platform-specific README for exact commands.

## Customization

Each `flake.nix` is heavily commented and designed to be modified:

- **Add packages**: Find them at [search.nixos.org](https://search.nixos.org/packages)
- **Remove what you don't need**: Just delete lines
- **Change versions**: Pin specific package versions
- **Add configurations**: Shell aliases, git config, and more

## File Structure

```
.
├── README.md           # You are here
├── flake.nix           # Original Mac-specific config (deprecated)
├── mac/
│   ├── flake.nix       # macOS configuration
│   └── README.md       # Mac setup guide
├── linux/
│   ├── flake.nix       # Linux configuration
│   └── README.md       # Linux setup guide
└── windows/
    ├── flake.nix       # WSL2 configuration
    └── README.md       # Windows setup guide
```

## Troubleshooting

### Nix Installation Issues
```bash
# Check Nix is installed
nix --version

# If not found, source the profile
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

### Platform-Specific Issues
See your platform's README for detailed troubleshooting:
- [Mac Troubleshooting](./mac/README.md#troubleshooting)
- [Linux Troubleshooting](./linux/README.md#troubleshooting)
- [Windows Troubleshooting](./windows/README.md#troubleshooting)

## FAQ

**Q: Will this replace my existing setup?**  
A: No! Nix installs to `/nix` and doesn't touch your existing packages. You can try it safely.

**Q: What if I don't like it?**  
A: Uninstall is simple: `/nix/nix-installer uninstall`

**Q: Can I use this for work machines?**  
A: Yes! Many companies use Nix. Check your IT policies first.

**Q: What's the disk space usage?**  
A: Initial install: ~2GB. Grows over time but Nix has garbage collection.

**Q: Does this work offline?**  
A: After initial setup, yes! Nix caches everything locally.

## Keeping Updated

This repository will be continuously improved with new features and packages. See the [**Updating Guide**](./UPDATING.md) to learn how to:
- Pull and apply new changes
- Handle conflicts with your customizations
- Rollback if something breaks
- Stay in sync with improvements

## Resources

### Nix Documentation
- [Nix Manual](https://nixos.org/manual/nix/stable/)
- [Nix Package Search](https://search.nixos.org/packages)
- [Nix Flakes Guide](https://nixos.wiki/wiki/Flakes)

### Platform-Specific
- [nix-darwin](https://github.com/LnL7/nix-darwin) (macOS)
- [home-manager](https://nix-community.github.io/home-manager/) (Linux/Windows)
- [WSL2 Documentation](https://docs.microsoft.com/en-us/windows/wsl/)

### Community
- [NixOS Discourse](https://discourse.nixos.org/)
- [r/NixOS](https://www.reddit.com/r/NixOS/)
- [Nix Discord](https://discord.gg/RbvHtGa)

## Contributing

Found an improvement? PRs welcome!

1. Test on your platform
2. Update the relevant `flake.nix` and `README.md`
3. Submit a PR with description

## License

MIT License - Use this however you want!

---

## Get Started Now!

Choose your platform above and start your 5-minute setup:

- 🍎 **[Mac Setup →](./mac/README.md)**
- 🐧 **[Linux Setup →](./linux/README.md)**
- 🪟 **[Windows Setup →](./windows/README.md)**

---

**Made by SDETs, for SDETs** 🚀

*Stop configuring machines. Start coding faster.*
