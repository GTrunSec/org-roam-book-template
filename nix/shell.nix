{pkgs ? import <nixpkgs> {}}:
with pkgs; {
  default = mkShell {
    buildInputs = [
      hugo
      ninja
      emacs-final
      python3
    ];
  };
}
