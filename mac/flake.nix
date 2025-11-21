{
  description = "Mac nix-darwin system flake";

  inputs = {
    # Nix & Darwin
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Homebrew managed by Nix
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # Pin Homebrew taps (non-flake)
    homebrew-core = { url = "github:homebrew/homebrew-core"; flake = false; };
    homebrew-cask = { url = "github:homebrew/homebrew-cask"; flake = false; };

    # Home Manager (for user-level config like Oh My Zsh)
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{
    self,
    nixpkgs,
    nix-darwin,
    nix-homebrew,
    homebrew-core,
    homebrew-cask,
    home-manager,
    ...
  }:
  let
    # System configuration
    username = "mike.sell";
    hostname = "gendigital";
    system = "aarch64-darwin"; # Apple Silicon (use x86_64-darwin for Intel)

    configuration = { config, pkgs, ... }: {
      # Disable nix-darwin's Nix management (using Determinate Nix)
      nix.enable = false;

      # Allow unfree packages
      nixpkgs.config.allowUnfree = true;

      # System packages (CLI tools via Nix)
      environment.systemPackages = with pkgs; [
        vim
        git
        orbstack
        gh
        gnupg
        pinentry_mac
      ];

      # Ensure Homebrew binaries are on PATH
      environment.systemPath = [
        "/opt/homebrew/bin"
        "/opt/homebrew/sbin"
        "/usr/local/bin"
        "/usr/local/sbin"
      ];

      # Set primary user
      system.primaryUser = username;

      # User configuration
      users.users.${username} = {
        home = "/Users/${username}";
        shell = pkgs.zsh;
      };

      # System configuration revision
      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 5;

      # Enable zsh system-wide
      programs.zsh.enable = true;
    };

  in
  {
    darwinConfigurations."${hostname}" = nix-darwin.lib.darwinSystem {
      inherit system;
      modules = [
        configuration

        # Homebrew configuration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = username;
            autoMigrate = true;
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
            };
            mutableTaps = false;
          };

          homebrew = {
            enable = true;
            taps = [ "homebrew/homebrew-core" "homebrew/homebrew-cask" ];

            # GUI applications via casks
            casks = [
              "brave-browser"
              "dropbox"
              "logseq"
              "postman"
              "slack"
              "telegram"
              "whatsapp"
              "excalidrawz"
              "maccy"
              "voiceink"
              "orbstack" # Also install via cask for GUI
            ];

            # CLI tools from Homebrew
            brews = [
              "mas" # Mac App Store CLI
            ];

            # Mac App Store applications
            masApps = {
              "DaVinci Resolve" = 571213070;
              "flowy" = 6748351905;
              "Xcode" = 497799835;
            };

            onActivation = {
              autoUpdate = false;
              upgrade = false;
              cleanup = "uninstall";
            };
          };
        }

        # Home Manager configuration
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${username} = { pkgs, ... }: {
            home.stateVersion = "24.05";

            # Zsh with Oh My Zsh configuration
            programs.zsh = {
              enable = true;
              enableCompletion = true;
              autosuggestion.enable = true;
              syntaxHighlighting.enable = true;

              oh-my-zsh = {
                enable = true;
                theme = "robbyrussell";
                plugins = [
                  "git"
                  "docker"
                  "kubectl"
                  "macos"
                ];
              };

              # Environment variables
              sessionVariables = {
                EDITOR = "vim";
                VISUAL = "vim";
                GPG_TTY = "$(tty)";
              };

              # Shell initialization (runs after Oh My Zsh loads)
              initExtra = ''
                # Ensure Oh My Zsh is properly configured
                if [ -z "$ZSH" ]; then
                  export ZSH="$HOME/.oh-my-zsh"
                fi

                # Set GPG_TTY for commit signing
                export GPG_TTY=$(tty)

                # Custom aliases
                alias ll='ls -lah'
                alias gs='git status'
                alias gc='git commit'
                alias gp='git push'
                alias gl='git pull'

                # Orbstack initialization (if installed)
                if command -v orbctl &> /dev/null; then
                  source ~/.orbstack/shell/init.zsh 2>/dev/null || :
                fi
              '';
            };

            # Git configuration
            programs.git = {
              enable = true;
              userName = "Your Name";
              userEmail = "your.email@example.com";
              extraConfig = {
                init.defaultBranch = "main";
                pull.rebase = false;
                core.editor = "vim";
                # GPG signing configuration
                commit.gpgsign = true;
                gpg.program = "${pkgs.gnupg}/bin/gpg";
                # Note: After generating your GPG key, add:
                # user.signingkey = "YOUR_GPG_KEY_ID";
              };
            };

            # GPG configuration
            programs.gpg = {
              enable = true;
            };

            # GPG Agent configuration (for macOS)
            services.gpg-agent = {
              enable = true;
              enableSshSupport = true;
              pinentryPackage = pkgs.pinentry_mac;
              defaultCacheTtl = 3600;
              maxCacheTtl = 7200;
            };

            # Additional home packages
            home.packages = with pkgs; [
              # Add any additional user-specific packages here
            ];
          };
        }
      ];
    };
  };
}

