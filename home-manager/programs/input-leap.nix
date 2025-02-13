{ pkgs, system, ... }:

{
  home.packages = with pkgs;
    builtins.filter (pkg: pkg != null)
    [ (if builtins.match ".*-linux" system != null then input-leap else null) ];
}
