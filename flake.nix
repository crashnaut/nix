{
  description = "Mac nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, mac-app-util, ... }:
  let
    configuration = { config, pkgs, ... }: {
      # Flakes + nix-command on permanently
      nix.settings.experimental-features = [ "nix-command" "flakes" ];

      # Unfree GUI apps (Slack/Brave/Postman/etc.)
      nixpkgs.config.allowUnfree = true;

      # Your packages (GUI apps will be available in Spotlight and Launchpad)
      environment.systemPackages = with pkgs; [
        vim colima slack brave postman logseq obsidian
        # dropbox  # <- not available on aarch64-darwin in nixpkgs
      ];

      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 6;
    };
  in
  {
    darwinConfigurations."mini" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [ 
        configuration 
        mac-app-util.darwinModules.default
      ];
    };
  };
}
