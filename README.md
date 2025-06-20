# Roku Labs Dotfiles

## Prerequisites

```bash
# enable experimental features
mkdir -p ~/.config/nix
cat <<EOF > ~/.config/nix/nix.conf
experimental-features = flakes nix-command
EOF

# install nix package manager (assume done)
```

## Apply configuration

### DevOS Virtual Machine (`aarch64-linux`)

```bash
sudo nixos-rebuild switch --flake github:kuznero/dotfiles#devos --impure
nix run home-manager/master -- switch --flake github:kuznero/dotfiles#devos
# home-manager switch --flake github:kuznero/dotfiles#devos
```

### Moon Lenovo Laptop (`x86_64-linux`)

```bash
sudo nixos-rebuild switch --flake github:kuznero/dotfiles#moon --impure
nix run home-manager/master -- switch --flake github:kuznero/dotfiles#moon
# home-manager switch --flake github:kuznero/dotfiles#moon
```

### Sun GitHub Runner Server (`x86_64-linux`)

```bash
sudo nixos-rebuild switch --flake github:kuznero/dotfiles#sun --impure
```

### Roman's MacBook Pro Laptop (`aarch64-darwin`)

```bash
nix run home-manager/master -- switch --flake github:kuznero/dotfiles#mac
# home-manager switch --flake github:kuznero/dotfiles#mac
```

### WSL2 (`x86_64-linux`)

To list all linux distributions currently installed, run the following
PowerShell:

```powershell
wsl -l -v
```

Following [installation instructions](https://nix-community.github.io/NixOS-WSL/install.html)
on how to install NixOS on WSL2.

> Make sure to update custom CA certificate according to your company settings.

```bash
cat <<EOF | sudo tee /etc/pki/tls/certs/ca-zscaler.crt
-----BEGIN CERTIFICATE-----
...
-----END CERTIFICATE-----
EOF

# add default CA certificates info new file
cat /etc/ssl/certs/ca-certificates.crt | \
  sudo tee --append /etc/pki/tls/certs/ca-zscaler.crt
```

Then, change `/etc/nixos/configuration.nix` file and ensure it has this line:

```nix
  security.pki.certificateFiles = [ /etc/pki/tls/certs/ca-zscaler.crt ];
  environment.variables = {
    "NIX_SSL_CERT_FILE" = "/etc/pki/tls/certs/ca-zscaler.crt";
  };
  security.sudo.extraConfig = ''
    Defaults env_keep += "NIX_SSL_CERT_FILE"
  '';
```

> You might also want to change default user name by changing `wsl.defaultUser`
> in `/etc/nixos/configuration.nix` file.

run `sudo -E NIX_SSL_CERT_FILE=/etc/pki/tls/certs/ca-zscaler.crt nixos-rebuild
switch` command. It will produce some warnings in the begining, but if the
certificate is correct, it will complete the rebuild.

```bash
sudo nix-channel --update
```

After the above is done, and corporate proxy is well configured, proceed to the
following:

```bash
sudo nixos-rebuild switch --flake github:kuznero/dotfiles#wsl --impure
nix run home-manager/master -- switch --flake github:kuznero/dotfiles#wsl
# home-manager switch --flake github:kuznero/dotfiles#wsl
```
