{
  description = "MacOS and NixOS-WSL dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents.url = "github:numtide/llm-agents.nix";
    agent-skills = {
      url = "github:Kyure-A/agent-skills-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mattpocock-skills = {
      url = "github:mattpocock/skills";
      flake = false;
    };
    chrome-devtools-mcp-skills = {
      url = "github:ChromeDevTools/chrome-devtools-mcp";
      flake = false;
    };
    zabrze-nix.url = "github:yagipass/zabrze-nix";
    verbatime.url = "github:yagipass/verbatime";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { withSystem, ... }:
      let
        darwin = rec {
          system = "aarch64-darwin";
          username = "miyagi";
          homeDirectory = "/Users/${username}";
          dotfilesPath = "${homeDirectory}/ghq/github.com/yagipass/dotfiles";
          isDarwin = true;
        };
        wsl = rec {
          system = "x86_64-linux";
          username = "nixos";
          homeDirectory = "/home/${username}";
          dotfilesPath = "${homeDirectory}/ghq/github.com/yagipass/dotfiles";
          isDarwin = false;
        };
        mkHomeSpecialArgs = host: inputs': {
          inherit (host)
            username
            homeDirectory
            dotfilesPath
            isDarwin
            ;
          # The agent-skills module resolves sources.<name>.input from args.inputs.
          inherit inputs;
          agentSkillsModule = inputs.agent-skills.homeManagerModules.default;
          llmAgents = inputs'.llm-agents.packages;
          inherit (inputs'.zabrze-nix.packages) zabrze;
          inherit (inputs'.verbatime.packages) vbtm;
        };
        homeConfiguration = withSystem darwin.system (
          { pkgs, inputs', ... }:
          inputs.home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = mkHomeSpecialArgs darwin inputs';
            modules = [ ./modules/home ];
          }
        );
        darwinConfiguration = inputs.nix-darwin.lib.darwinSystem {
          inherit (darwin) system;
          specialArgs = {
            inherit (darwin) username;
          };
          modules = [ ./modules/darwin ];
        };
        wslConfiguration = withSystem wsl.system (
          { inputs', ... }:
          inputs.nixpkgs.lib.nixosSystem {
            inherit (wsl) system;
            specialArgs = {
              inherit (wsl) username dotfilesPath;
              homeSpecialArgs = mkHomeSpecialArgs wsl inputs';
            };
            modules = [
              inputs.nixos-wsl.nixosModules.default
              inputs.home-manager.nixosModules.home-manager
              ./modules/nixos/wsl.nix
            ];
          }
        );
      in
      {
        imports = [
          inputs.treefmt-nix.flakeModule
          inputs.git-hooks-nix.flakeModule
          inputs.home-manager.flakeModules.home-manager
          inputs.nix-darwin.flakeModules.default
        ];

        systems = [
          darwin.system
          wsl.system
        ];

        perSystem =
          {
            self',
            inputs',
            config,
            pkgs,
            system,
            lib,
            ...
          }:
          {
            treefmt.imports = [ ./treefmt.nix ];

            pre-commit.settings.hooks = {
              treefmt = {
                enable = true;
                package = config.treefmt.build.wrapper;
              };
              statix.enable = true;
              actionlint.enable = true;
              shellcheck = {
                enable = true;
                excludes = [ "^\\.envrc$" ];
              };
              typos.enable = true;
              gitleaks = {
                enable = true;
                entry = "${pkgs.gitleaks}/bin/gitleaks git --pre-commit --staged --redact --no-banner";
                pass_filenames = false;
              };
            };

            packages = {
              inherit (inputs'.zabrze-nix.packages) zabrze;
            }
            // lib.optionalAttrs (system == darwin.system) {
              inherit (import ./packages/node { inherit pkgs; }) chrome-devtools-mcp;
            };

            devShells.default = pkgs.mkShellNoCC {
              packages = [
                pkgs.just
                pkgs.bun
                pkgs.nodejs
              ]
              ++ config.pre-commit.settings.enabledPackages;
              shellHook = config.pre-commit.installationScript;
            };

            checks = {
              gitleaks =
                pkgs.runCommand "gitleaks"
                  {
                    nativeBuildInputs = [ pkgs.gitleaks ];
                  }
                  ''
                    gitleaks dir ${inputs.self} --no-banner --redact
                    touch $out
                  '';
              inherit (self'.packages) zabrze;
            }
            // lib.optionalAttrs (system == darwin.system) {
              inherit (self'.packages) chrome-devtools-mcp;
              home = homeConfiguration.activationPackage;
              darwin = darwinConfiguration.system;
            }
            // lib.optionalAttrs (system == wsl.system) {
              wsl = wslConfiguration.config.system.build.toplevel;
            };
          };

        flake = {
          homeConfigurations.default = homeConfiguration;
          darwinConfigurations.macos = darwinConfiguration;
          nixosConfigurations.wsl = wslConfiguration;
        };
      }
    );
}
