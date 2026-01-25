{
  lib,
  stdenvNoCC,
  bun,
  fetchFromGitHub,
  fzf,
  makeBinaryWrapper,
  models-dev,
  nix-update-script,
  ripgrep,
  installShellFiles,
  sysctl,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "opencode";
  version = "1.1.35";
  src = fetchFromGitHub {
    owner = "anomalyco";
    repo = "opencode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z8RnhFbdtZPb05l1gdgKXCOBDgRNZyppgzrFRNq4wmg=";
  };

  node_modules = stdenvNoCC.mkDerivation {
    pname = "${finalAttrs.pname}-node_modules";
    inherit (finalAttrs) version src;

    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
      "GIT_PROXY_COMMAND"
      "SOCKS_SERVER"
    ];

    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild

      bun install \
        --cpu="*" \
        --frozen-lockfile \
        --ignore-scripts \
        --no-progress \
        --os="*"

      bun --bun ./nix/scripts/canonicalize-node-modules.ts
      bun --bun ./nix/scripts/normalize-bun-binaries.ts

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      find . -type d -name node_modules -exec cp -R --parents {} $out \;

      runHook postInstall
    '';

    # NOTE: Required else we get errors that our fixed-output derivation references store paths
    dontFixup = true;

    outputHash = "sha256-IlRtdiY6kpscHcFNcmI5dW3LbRh9e+3PpafNPM7wTIA=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };

  nativeBuildInputs = [
    bun
    installShellFiles
    makeBinaryWrapper
    models-dev
    writableTmpDirAsHomeHook
  ];

  patches = [
    # NOTE: Relax Bun version check to be a warning instead of an error
    ./relax-bun-version-check.patch
    # NOTE: Remove special and windows build targets
    ./remove-special-and-windows-build-targets.patch
  ];

  configurePhase = ''
    runHook preConfigure

    cp -R ${finalAttrs.node_modules}/. .

    runHook postConfigure
  '';

  env.MODELS_DEV_API_JSON = "${models-dev}/dist/_api.json";
  env.OPENCODE_VERSION = finalAttrs.version;
  env.OPENCODE_CHANNEL = "stable";

  preBuild = ''
    chmod -R u+w ./packages/opencode/node_modules
    pushd ./packages/opencode/node_modules/@opentui/
      for pkg in ../../../../node_modules/.bun/@opentui+core-*; do
        linkName=$(basename "$pkg" | sed 's/@.*+\(.*\)@.*/\1/')
        ln -sf "$pkg/node_modules/@opentui/$linkName" "$linkName"
      done
    popd
  '';

  buildPhase = ''
    runHook preBuild

    cd ./packages/opencode
    bun --bun ./script/build.ts --single --skip-install
    bun --bun ./script/schema.ts schema.json

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 dist/opencode-*/bin/opencode $out/bin/opencode
    install -Dm644 schema.json $out/share/opencode/schema.json

    runHook postInstall
  '';

  # NOTE: shell completion generation fails in the nix sandbox on darwin (empty output)
  postInstall = lib.optionalString
    (stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform && !stdenvNoCC.hostPlatform.isDarwin) ''
    installShellCompletion --cmd opencode \
      --bash <($out/bin/opencode completion) \
      --zsh <(SHELL=/bin/zsh $out/bin/opencode completion)
  '';

  postFixup = ''
    wrapProgram $out/bin/opencode \
     --prefix PATH : ${
       lib.makeBinPath (
         [
           fzf
           ripgrep
         ]
         # bun runs sysctl to detect if running on rosetta2
         ++ lib.optional stdenvNoCC.hostPlatform.isDarwin sysctl
       )
     }
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  # NOTE: version check fails in the nix sandbox on darwin
  doInstallCheck = !stdenvNoCC.hostPlatform.isDarwin;
  versionCheckKeepEnvironment = [ "HOME" ];
  versionCheckProgramArg = "--version";

  passthru = {
    jsonschema = "${placeholder "out"}/share/opencode/schema.json";
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "node_modules"
      ];
    };
  };

  meta = {
    description = "AI coding agent built for the terminal";
    homepage = "https://github.com/anomalyco/opencode";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ delafthi ];
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    mainProgram = "opencode";
  };
})
