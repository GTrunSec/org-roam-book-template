{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;

    org-roam-book-template.url = "github:gtrunsec/org-roam-book-template";
    org-roam-book-template.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    ...
  }:
    (inputs.flake-utils.lib.eachDefaultSystem
      (system: let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        org-roam-book = inputs.org-roam-book-template.packages.${system}.default.override {
          org = ./docs/org;
        };
      in rec {
        devShells.default = let
          mkdoc = pkgs.writeScriptBin "mkdoc" ''
          rsync -avzh ${org-roam-book}/* docs/publish
          cd docs/publish && cp ../config.toml .
          hugo
          cp -rf --no-preserve=mode,ownership public/posts/index.html ./public/
          "$@"
          '';
          in pkgs.mkShell {
            buildInputs = with pkgs;[ hugo mkdoc ];
          };
      })
    )
    // {
      overlays.default = final: prev: {};
    };
}
