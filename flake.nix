{
  description = "Emacs development environment";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-filter.url = "github:/numtide/nix-filter";
    nix-filter.inputs.nixpkgs.follows = "nixpkgs";

    cortex.url = "github:gtrunsec/cortex";
    cortex.flake = false;

    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;

    emacs-overlay = {
      type = "github";
      owner = "nix-community";
      repo = "emacs-overlay";
    };
  };

  outputs = inputs @ {self, ...}:
    {}
    // (
      inputs.flake-utils.lib.eachDefaultSystem
      (
        system: let
          pkgs = inputs.nixpkgs.legacyPackages.${system}.appendOverlays [
            self.overlays.default
            inputs.emacs-overlay.overlay
            inputs.nix-filter.overlays.default
          ];
          aux-packages = import ./nix/auxilary.nix {inherit pkgs;};

          all-packages =
            []
            ++ (pkgs.lib.optionals pkgs.stdenv.isLinux [pkgs.emacs-final])
            # ++ (pkgs.lib.optionals pkgs.stdenv.isDarwin [emacs-final])
            ++ aux-packages;
        in {
          packages = {
            default = pkgs.org-roam-book;
            emacs = pkgs.buildEnv {
              name = "emacs-plus-aux-packages";
              paths = all-packages;
            };
          };
          devShells = import ./nix/shell.nix {inherit pkgs;};
        }
      )
    )
    // {
      overlays = import ./nix/overlays.nix {inherit inputs;};
      templates.default = {
        description = "make your org-roam-book";
        path = ./template;
      };
    };
}
