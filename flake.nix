{
  description = "Emacs development environment";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    emacs-overlay = {
      type = "github";
      owner = "nix-community";
      repo = "emacs-overlay";
    };
  };

  outputs = inputs @ {self, ...}:
    {}
    // (
      inputs.flake-utils.lib.eachSystem ["x86_64-linux" "x86_64-darwin"]
      (
        system: let
          pkgs = inputs.nixpkgs.legacyPackages.${system}.appendOverlays [self.overlays.default inputs.emacs-overlay.overlay];
          aux-packages = import ./nix/auxilary.nix {inherit pkgs;};

          all-packages =
            []
            ++ (pkgs.lib.optionals pkgs.stdenv.isLinux [pkgs.emacs-final])
            # ++ (pkgs.lib.optionals pkgs.stdenv.isDarwin [emacs-final])
            ++ aux-packages;
        in {
          defaultPackage = pkgs.buildEnv {
            name = "emacs-plus-aux-packages";
            paths = all-packages;
          };
          devShells = import ./nix/shell.nix {inherit pkgs;};
        }
      )
    )
    // {
      overlays = import ./nix/overlays.nix {inherit inputs;};
    };
}
