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

    mkdir static

    python build.py

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{docs,themes,static}

    cp -rT --no-preserve=mode,ownership layouts $out/layouts
    cp -rT --no-preserve=mode,ownership ${cortex} $out/themes/cortex
    cp -rT --no-preserve=mode,ownership content $out/content
    cp -rT --no-preserve=mode,ownership static $out/static

    # enable search
    mkdir $out/content/search
    cat <<EOF > $out/content/search/_index.md
    +++
    title = "Search"
    type = "search"
    draft = false
    +++
    EOF

    runHook postInstall
  '';
}
