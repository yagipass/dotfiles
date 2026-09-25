# dotfiles

[![CI](https://github.com/yagipass/dotfiles/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/yagipass/dotfiles/actions/workflows/ci.yml)

My dotfiles for macOS and NixOS-WSL, managed with nix-darwin and Home Manager. `flake.nix` defines the outputs and `justfile` is the entry point for day-to-day operations.

The checkout location must match `dotfilesPath` in `flake.nix`.

- macOS: `~/ghq/github.com/yagipass/dotfiles`
- NixOS-WSL: `~/ghq/github.com/yagipass/dotfiles`

## Usage

Enable direnv and use `just`. Without direnv, `nix develop -c just <recipe>` works too.

```sh
just update   # update dependencies and validate
just build    # build without touching the live system
just switch   # apply to the live system
just secrets  # render config files from 1Password
just fmt      # format
just lint     # flake checks
just gc       # delete old generations and unused store paths
```

## macOS setup

1. Install Nix with [nix-installer](https://github.com/NixOS/nix-installer), then install Homebrew.

   ```sh
   curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install --enable-flakes
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. Clone the repository with ghq. Its default root is `~/ghq`, so the checkout lands on `dotfilesPath`.

   ```sh
   nix run nixpkgs#ghq -- get yagipass/dotfiles
   cd ~/ghq/github.com/yagipass/dotfiles
   ```

3. Apply nix-darwin, then Home Manager. Applying nix-darwin first enables the extra substituters.

   ```sh
   sudo nix run github:nix-darwin/nix-darwin/master#darwin-rebuild -- switch --flake .#macos
   nix run github:nix-community/home-manager/master -- switch --flake .#default
   ```

4. In 1Password.app, enable "Settings → Developer → Integrate with 1Password CLI" and "Use the SSH agent", then run `just secrets`.

## NixOS-WSL setup

Assumes NixOS-WSL, 1Password for Windows, and 1Password CLI for Windows are already installed.

1. Clone the repository.

   ```sh
   mkdir -p ~/ghq/github.com/yagipass
   nix run --extra-experimental-features 'nix-command flakes' nixpkgs#git -- \
     clone https://github.com/yagipass/dotfiles.git ~/ghq/github.com/yagipass/dotfiles
   cd ~/ghq/github.com/yagipass/dotfiles
   ```

2. Apply the NixOS configuration.

   ```sh
   sudo env NIX_CONFIG='experimental-features = nix-command flakes' \
     nixos-rebuild switch --flake .#wsl
   ```

3. Enable CLI integration and the SSH agent on the Windows side, add the following to `%LOCALAPPDATA%\1Password\config\ssh\agent.toml`, then run `just secrets`.

   ```toml
   [[ssh-keys]]
   item = "git-personal-signing-key"
   vault = "dotfiles"
   ```

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE).
