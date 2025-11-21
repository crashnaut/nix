{
  description = "Linux (Ubuntu/PopOS) home-manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    
    # Home Manager for user-level package management
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      # CHANGE THIS: Replace with your username
      username = "mike";
      system = "x86_64-linux"; # Use aarch64-linux for ARM64
      
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          ({ config, pkgs, ... }: {
            # User info
            home.username = username;
            home.homeDirectory = "/home/${username}";
            home.stateVersion = "24.05";

            # Allow unfree packages
            nixpkgs.config.allowUnfree = true;

            # Packages to install
            home.packages = with pkgs; [
              # Development tools
              vim
              git
              gh
              docker
              docker-compose
              
              # CLI utilities
              curl
              wget
              htop
              tree
              jq
              ripgrep
              fd
              bat
              
              # GUI applications (if running with X11/Wayland)
              brave
              slack
              postman
              logseq
              telegram-desktop
              
              # System utilities
              gnupg
            ];

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

            # Zsh with Oh My Zsh
            programs.zsh = {
              enable = true;
              enableCompletion = true;
              
              oh-my-zsh = {
                enable = true;
                theme = "robbyrussell";
                plugins = [ "git" "docker" "docker-compose" ];
              };

              shellAliases = {
                ll = "ls -lah";
                update = "home-manager switch --flake ~/.config/nix#${username}";
              };
              
              # Set GPG_TTY for GPG signing
              initExtra = ''
                export GPG_TTY=$(tty)
              '';
            };

            # Bash configuration (fallback)
            programs.bash = {
              enable = true;
              shellAliases = {
                ll = "ls -lah";
                update = "home-manager switch --flake ~/.config/nix#${username}";
              };
              
              # Set GPG_TTY for GPG signing
              initExtra = ''
                export GPG_TTY=$(tty)
              '';
            };

            # GPG configuration
            programs.gpg = {
              enable = true;
            };

            # GPG Agent configuration
            services.gpg-agent = {
              enable = true;
              enableSshSupport = true;
              defaultCacheTtl = 3600;
              maxCacheTtl = 7200;
            };

            # Let Home Manager manage itself
            programs.home-manager.enable = true;
          })
        ];
      };
    };
}

