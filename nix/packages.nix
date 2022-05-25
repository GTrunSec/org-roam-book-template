{inputs}:
epkgs:
with epkgs; [
  (ox-hugo.overrideAttrs (old: {
    src = "${inputs.ox-hugo}";
  }))
]
