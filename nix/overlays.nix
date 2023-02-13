{inputs}: let
  version = "${builtins.substring 0 8 (inputs.self.shortRev or "dirty")}.${inputs.self.lastModifiedDate or inputs.self.lastModified or "19700101"}";
in {
  default = final: prev: rec {
    org-roam-book = prev.callPackage ./. {
      inherit emacs-final version;
      cortex = inputs.cortex;
    };

    emacs-final = final.emacsWithPackagesFromPackageRequires {
      packageElisp = builtins.readFile ../publish.el;
      package = prev.emacs-nox;
      extraEmacsPackages = import ./packages.nix {inherit inputs;};
    };

    emacsPackagesFor = emacs: (
      (prev.emacsPackagesFor emacs).overrideScope' (
        eself: esuper: let
          melpaPackages =
            esuper.melpaPackages
            // {
              ox-hugo = esuper.ox-hugo.overrideAttrs (old: {
                src = "${inputs.ox-hugo}";
              });
            };
          manualPackages =
            esuper.manualPackages
            // {
              # clip2org = esuper.trivialBuild {
              #   pname = "clip2org";
              #   version = "2021-06-11";
              #   src = prev.fetchFromGitHub {
              #     owner = "acowley";
              #     repo = "clip2org";
              #     rev = "e80616a98780f37c7cc87baefd38ad2180f8a98f";
              #     sha256 = "sha256:1h3fbblhdb0hrrk0cl0j8wcf4x0z0wma971ahl79m9g9394yvfps";
              #   };
              # };
            };
          epkgs = esuper.override {
            inherit manualPackages melpaPackages;
          };
        in
          epkgs
      )
    );
  };
}
