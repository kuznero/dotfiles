{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    aliases = {
      st = "status";
      ci = "commit";
      co = "checkout";
      l =
        "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=short --branches";
      br = "branch";
      d = "diff --word-diff=color";
      dt = "difftool";
      dtp = "difftool";
      m = "merge";
      mt = "mergetool";
      cl = "clean -x -d -f --exclude output/ --dry-run";
      cls = "clean -x -d -f --exclude output/";
      pl = "pull --all --prune";
      ps = "push";
    };
    userName = "Roman Kuznetsov";
    userEmail = "${config.home.username}@lix.one";
    extraConfig = {
      init = { defaultBranch = "main"; };
      core = { autocrlf = "input"; };
      color = { ui = true; };
      diff = { tool = "bc"; };
      difftool.bc = { trustExitCode = true; };
      merge = { tool = "bc"; };
      mergetool.bc = { trustExitCode = true; };
      pull = { rebase = false; };
      push = { default = "simple"; };
    };
  };
}
