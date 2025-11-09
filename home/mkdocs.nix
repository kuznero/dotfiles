{ pkgs, ... }:

{
  home.packages = with pkgs;
    [
      (python3.withPackages (ps:
        with ps; [
          mkdocs
          mkdocs-drawio-file
          mkdocs-linkcheck
          mkdocs-material
          mkdocs-material-extensions
          mkdocs-mermaid2-plugin
          mkdocs-minify-plugin
        ]))
    ];
}
