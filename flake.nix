{
  description = "Mac nix-darwin system flake";

  inputs = {
    # Nix & Darwin
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Link .app bundles from Nix into Launchpad/Spotlight
    mac-app-util.url = "github:hraban/mac-app-util";

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
    self, nixpkgs, nix-darwin, mac-app-util,
    nix-homebrew, homebrew-core, homebrew-cask,
    home-manager, ...
  }:
  let
    configuration = { config, pkgs, ... }: {
      # Use flakes & new CLI everywhere
      nix.settings.experimental-features = [ "nix-command" "flakes" ];

      # Allow unfree when needed
      nixpkgs.config.allowUnfree = true;

      # CLI tools via Nix (keep GUI in Homebrew casks)
      environment.systemPackages = with pkgs; [
        vim
        colima
        gh
        gnupg
        pinentry_mac
      ];

      # Ensure Homebrew binaries (e.g. mas) are on PATH
      environment.systemPath = [
        "/opt/homebrew/bin" "/opt/homebrew/sbin"
        "/usr/local/bin" "/usr/local/sbin" # Intel prefix for Rosetta if ever used
      ];

      # Required by newer nix-darwin
      system.primaryUser = "mike";

      # Default shell for your user
      users.users.mike = {
        home = "/Users/mike";
        shell = pkgs.zsh;
      };

      # Repro pin; set once and leave
      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 6;
    };
  in
  {
    darwinConfigurations."mini" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin"; # Apple Silicon
      modules = [
        configuration
        mac-app-util.darwinModules.default

        # Install/manage Homebrew itself, with unified `brew` wrapper
        nix-homebrew.darwinModules.nix-homebrew
        ({ config, ... }: {
          nix-homebrew = {
            enable = true;          # /run/current-system/sw/bin/brew
            enableRosetta = true;   # Intel prefix via: arch -x86_64 brew
            user = "mike";          # Homebrew owner on this Mac
            autoMigrate = true;     # adopt existing /opt/homebrew if present
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
            };
            mutableTaps = false;    # keep taps declarative
          };

          # Declarative Homebrew packages
          homebrew = {
            enable = true;
            taps = builtins.attrNames config.nix-homebrew.taps;

            # GUI apps via casks (prefer casks over MAS where possible)
            casks = [
              "brave-browser"
              "dropbox"
              "logseq"
              "postman"
              "slack"
              "telegram"
              "whatsapp"
              "excalidrawz"
            ];

            # CLI brews kept minimal; include mas so MAS apps can be managed
            brews = [ "mas" ];

            # MAS only for what lacks great brew/nix options
            masApps = {
              "DaVinci Resolve" = 571213070;
              "flowy"           = 6748351905;  # different from 'appflowy' cask
              "Xcode"           = 497799835;   # MAS is the reliable path
            };

            onActivation = {
              autoUpdate = false;
              upgrade = false;
              cleanup = "uninstall"; # use "zap" for deeper cleanup
            };
            global.autoUpdate = true;
          };
        })

        # Home Manager (user-level config)
        home-manager.darwinModules.home-manager

        # Oh My Zsh for user "mike" (no Spaceship)
        ({ pkgs, ... }: {
          home-manager.users.mike = { pkgs, ... }: {
            home.stateVersion = "24.05";

            programs.zsh = {
              enable = true;
              enableCompletion = true;

              oh-my-zsh = {
                enable = true;
                theme = "robbyrussell";   # default OMZ theme
                plugins = [ "git" ];      # match your current setup
              };
            };
          };
        })
      ];
    };
  };
}
