{ config, pkgs, user, userName, ... }:

{
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.git;
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
    userName = "${userName}";
    userEmail = "${user}@lix.one";
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
      user = {
        signingkey =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPnftuCpJhWOWkLVrKarVSDH1+PZ5tH8lfvZo2fTzNa5";
      };
      gpg = { format = "ssh"; };
      gpg.ssh = { program = "op-ssh-sign"; };
      commit = { gpgsign = true; };
    };
    includes = [{
      path = "~/.config/git/bc-config";
      condition = "gitdir:~/Data/Projects/bc/";
    }];
  };

  # Create the bc-specific config that disables signing
  home.file.".config/git/bc-config".text = ''
    [user]
      email = "xramk@bankingcircle.com"
      signingkey = ""
    [gpg]
      format = ""
    [gpg "ssh"]
      program = ""
    [commit]
      gpgsign = false
  '';
}
