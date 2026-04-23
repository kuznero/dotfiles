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

### Using Task Commands (Recommended)

You can provide custom user variables when running task commands:

```bash
# For NixOS systems
task nixos:switch NAME=moon USER="myuser" USER_NAME="My Full Name"

# For Home Manager
task home:switch NAME=mac USER="myuser" USER_NAME="My Full Name"
```

If not provided, defaults to `USER=roku` and `USER_NAME="Roman Kuznetsov"`.

### DevOS Virtual Machine (`aarch64-linux`)

```bash
# Using task (recommended)
task nixos:switch NAME=devos
task home:switch NAME=devos

# Or manually
sudo nixos-rebuild switch --flake github:kuznero/dotfiles#devos --impure
nix run home/master -- switch --flake github:kuznero/dotfiles#devos
```

### Moon Lenovo Laptop (`x86_64-linux`)

```bash
# Using task (recommended)
task nixos:switch NAME=moon
task home:switch NAME=moon

# Or manually
sudo nixos-rebuild switch --flake github:kuznero/dotfiles#moon --impure
nix run home/master -- switch --flake github:kuznero/dotfiles#moon
```

### Sun GitHub Runner Server (`x86_64-linux`)

```bash
# Using task (recommended)
task nixos:switch NAME=sun

# Or manually
sudo nixos-rebuild switch --flake github:kuznero/dotfiles#sun --impure
```

### Roman's MacBook Pro Laptop (`aarch64-darwin`)

```bash
# Using task (recommended)
task home:switch NAME=mac

# Or manually
nix run home/master -- switch --flake github:kuznero/dotfiles#mac
```
