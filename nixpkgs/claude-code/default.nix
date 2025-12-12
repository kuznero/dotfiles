{ lib, buildNpmPackage, fetchzip, nodejs_22, }:

buildNpmPackage rec {
  pname = "claude-code";
  version = "2.0.67";

  nodejs = nodejs_22; # required for sandboxed Nix builds on Darwin

  src = fetchzip {
    url =
      "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
    hash = "sha256-a1i8N6LZYA3XJx7AqDDOoyO5pf+t9WZ6vBQVZkUbpxM=";
  };

  npmDepsHash = "sha256-PW54IYPWAcT1aIXRL51gRuwZwBr9u5aVTUK62xK96lc=";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  AUTHORIZED = "1";

  # `claude-code` tries to auto-update by default, this disables that functionality.
  # https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview#environment-variables
  postInstall = ''
    wrapProgram $out/bin/claude \
      --set DISABLE_AUTOUPDATER 1
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description =
      "Agentic coding tool that lives in your terminal, understands your codebase, and helps you code faster";
    homepage = "https://github.com/anthropics/claude-code";
    downloadPage = "https://www.npmjs.com/package/@anthropic-ai/claude-code";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ malo omarjatoi ];
    mainProgram = "claude";
  };
}
