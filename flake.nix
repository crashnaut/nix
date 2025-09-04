{
  description = "Mac nix-darwin system flake";

  inputs = {
    # Nix & Darwin
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Links .app bundles from Nix into Launchpad/Spotlight
    mac-app-util.url = "github:hraban/mac-app-util";

    # Homebrew managed by Nix
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # Pin Homebrew taps (non-flake inputs)
    homebrew-core = { url = "github:homebrew/homebrew-core"; flake = false; };
    homebrew-cask = { url = "github:homebrew/homebrew-cask"; flake = false; };
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, mac-app-util, nix-homebrew, homebrew-core, homebrew-cask, ... }:
  let
    configuration = { config, pkgs, ... }: {
      # Use flakes & new CLI everywhere
      nix.settings.experimental-features = [ "nix-command" "flakes" ];

      # Allow unfree (e.g., some firmware/tools)
      nixpkgs.config.allowUnfree = true;

      # CLI tools installed via Nix (GUI apps are handled below via Homebrew casks)
      environment.systemPackages = with pkgs; [
        vim
        colima
        gh
        gnupg
        pinentry_mac
      ];

      # Required by newer nix-darwin (some options apply to the primary user)
      system.primaryUser = "mike";

      # Repro pin; set once and leave
      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 6;
    };
  in
  {
    darwinConfigurations."mini" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin"; # M1/M2/M3
      modules = [
        configuration
        mac-app-util.darwinModules.default

        # Install/manage Homebrew itself, with unified `brew` wrapper
        nix-homebrew.darwinModules.nix-homebrew
        ({ config, ... }: {
          nix-homebrew = {
            enable = true;          # provides /run/current-system/sw/bin/brew
            enableRosetta = true;   # Intel prefix available via: arch -x86_64 brew
            user = "mike";          # Homebrew owner on this Mac
            autoMigrate = true;     # adopt existing /opt/homebrew if present
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
            };
            mutableTaps = false;    # keep taps declarative
          };

          # What to install with Homebrew
          homebrew = {
            enable = true;

            # Keep taps in sync with nix-homebrew pins
            taps = builtins.attrNames config.nix-homebrew.taps;

            # GUI apps as casks (don’t also install them via Nix)
            casks = [
              "brave-browser"
              "dropbox"
              "logseq"
              "postman"
              "slack"
            ];

            # CLI formulae via Brew (optional; keep empty while you stabilize)
            brews = [ ];

            # Behavior on `darwin-rebuild switch`
            onActivation = {
              autoUpdate = false;     # don't auto-update every switch
              upgrade     = false;     # don't upgrade every switch
              cleanup     = "uninstall";  # use "zap" for a deeper cleanup
            };

            # When you run `brew` manually
            global.autoUpdate = true;
          };
        })
      ];
    };
  };
}
