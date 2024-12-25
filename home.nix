{
    pkgs,
    username,
    nix-index-database,
    ...
}: let
  unstable-packages = with pkgs.unstable; [
    bottom
    coreutils
    curl
    du-dust
    fd
    findutils
    fx
    git-crypt
    htop
    jq
    killall
    procs
    ripgrep
    sd
    tmux
    tree
    unzip
    wget
    zip
    lazygit
    lazydocker
    lazysql
    nodejs_20
    podman
    rust-analyzer
    typescript-language-server
    bash-language-server
    yaml-language-server
    tailwindcss-language-server
    nodePackages_latest.vscode-json-languageserver
    vscode-extensions.vadimcn.vscode-lldb.adapter
    astro-language-server
    marksman
    gopls
    nerd-fonts.jetbrains-mono
    go
    cargo
    rustc
    rustfmt
  ];

  stable-packages = with pkgs; [
    neovim
    gh
    just
    mkcert
    httpie
    cmake
    gnumake
    gcc
  ];
  in {
    imports = [
      nix-index-database.hmModules.nix-index
    ];

    home.stateVersion = "24.11";

    home = {
      username = "${username}";

      sessionVariables.EDITOR = "nvim";
      sessionVariables.SHELL = "/etc/profiles/per-user/${username}/bin/bash";
    };

    home.packages =
      stable-packages
      ++ unstable-packages;

    programs = {
      home-manager.enable = true;
      nix-index.enable = true;
      nix-index.enableBashIntegration = true;
      nix-index-database.comma.enable = true;

      eza = {
        enable = true;
        git = true;
        icons = "auto";
        enableBashIntegration = true;
      };

      starship = {
        enable = true;
        enableBashIntegration = true;
      };

      fzf.enable = true;
      fzf.enableBashIntegration = true;

      lsd.enable = true;
      lsd.enableAliases = true;

      zoxide.enable = true;
      zoxide.enableBashIntegration = true;
      zoxide.options = ["--cmd cd"];

      broot.enable = true;
      broot.enableBashIntegration = true;

      direnv.enable = true;
      direnv.nix-direnv.enable = true;

      git = {
        enable = true;
        delta.enable = true;
        delta.options = {
          line-numbers = true;
          side-by-side = true;
          navigate = true;
        };
        userEmail = "georgepetersmith@outlook.com";
        userName = "George Smith";
        extraConfig = {
          url = {
          };
          push = {
            default = "current";
            autoSetupRemote = true;
          };
          merge = {
            conflictstyle = "diff3";
          };
          diff = {
            colorMoved = "default";
          };
          init.defaultBranch = "main";
        };
      };

      bash = {
        enable = true;
        shellAliases = {
          gc = "nix-collect-garbage --delete-old";
          rb = "sudo nixos-rebuild switch --flake ~/nix/";
          pbcopy = "/mnt/c/Windows/System32/clip.exe";
          pbpaste = "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -command 'Get-Clipboard'";
          explorer = "/mnt/c/Windows/explorer.exe";
        };
      };

      bat = {
        enable = true;
        config = {
          theme = "Solarized (light)";
        };
      };
    };

    xdg.configFile = {
      nvim = {
        source = config/nvim;
        recursive = true;
      };
    };
  }
