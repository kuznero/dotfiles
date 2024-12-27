{ inputs, ... }:

{
  home.packages = with inputs; [ ghostty.packages.x86_64-linux.default ];
}
