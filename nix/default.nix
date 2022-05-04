{
  stdenvNoCC,
  version,
  nix-filter,
  emacs-final,
  ninja,
  hugo,
  python3,
  cortex,
  org ? ../org,
}:
stdenvNoCC.mkDerivation rec {
  pname = "publish.el";
  inherit version;
  src = nix-filter.filter {
    root = ../.;
    include = [
      (nix-filter.inDirectory ../layouts)
      ../build.py
      ../publish.el
    ];
  };
  buildInputs = [ninja emacs-final python3];

  buildPhase = ''
    runHook preBuild

    cp -rf --no-preserve=mode,ownership ${org} org

    python build.py

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{docs,themes}

    cp -rT --no-preserve=mode,ownership layouts $out/layouts
    cp -rT --no-preserve=mode,ownership ${cortex} $out/themes/cortex
    cp -rT --no-preserve=mode,ownership content $out/content

    runHook postInstall
  '';
}
