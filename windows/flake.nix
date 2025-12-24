{
  description = "Windows (WSL2) home-manager configuration";

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
      system = "x86_64-linux"; # WSL2 runs Linux on x86_64
      
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
              
              # CLI utilities
              curl
              wget
              htop
              tree
              jq
              ripgrep
              fd
              bat
              unzip
              
              # Docker (managed through Docker Desktop on Windows)
              # Use Windows Docker Desktop and connect from WSL
              
              # System utilities
              gnupg
              
              # WSL-specific tools
              wslu # WSL utilities
            ];

            # Git configuration
            programs.git = {
              enable = true;
              userName = "crashnaut";
              userEmail = "crashnaut@protonmail.com";
              
              # WSL-specific: Handle line endings properly
              extraConfig = {
                core = {
                  autocrlf = "input";
                  editor = "nano";
                };
                init.defaultBranch = "main";
                pull.rebase = false;
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
                plugins = [ "git" "docker" ];
              };

              shellAliases = {
                ll = "ls -lah";
                update = "home-manager switch --flake ~/.config/nix#${username}";
                # Open Windows Explorer from WSL
                explorer = "explorer.exe";
                # Access Windows system from WSL
                cdwin = "cd /mnt/c/Users/${username}";
              };
              
              # WSL-specific environment setup
              initExtra = ''
                # Set GPG_TTY for commit signing
                export GPG_TTY=$(tty)
                
                # Add Windows paths if needed
                # export PATH="$PATH:/mnt/c/Windows/System32"
                
                # Docker Desktop integration
                export DOCKER_HOST=unix:///var/run/docker.sock
              '';
            };

            # Bash configuration (fallback)
            programs.bash = {
              enable = true;
              shellAliases = {
                ll = "ls -lah";
                update = "home-manager switch --flake ~/.config/nix#${username}";
                explorer = "explorer.exe";
                cdwin = "cd /mnt/c/Users/${username}";
              };
              
              # Set GPG_TTY for commit signing
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

