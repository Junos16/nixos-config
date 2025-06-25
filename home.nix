{ config, pkgs, stable, inputs, nixvim, ... }:

let
  colors = {
    bg = "#0a0e1a";
    bg-alt = "#0f1419";
    bg-transparent = "rgba(10, 14, 26, 0.85)";
    fg = "#e6e1cf";
    primary = "#00d4ff";
    secondary = "#ff0080";
    accent = "#39ff14";
    warning = "#ff6600";
    error = "#ff0040";
    surface = "#1a1f2e";
    surface-transparent = "rgba(26, 31, 46, 0.90)";
  };
in
{
  imports = [
    ./hyprland.nix
    ./nixvim.nix
    ./tmux.nix
    ./waybar.nix
    ./wofi.nix
    ./dunst.nix
    ./hyprpaper.nix
    ./zathura.nix
  ];

  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  # User information
  home.username = "hriddhit";
  home.homeDirectory = "/home/hriddhit";

  home.sessionVariables = {
    CLIPBOARD = "wl-clipboard";
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  # Alacritty terminal
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.85;
        blur = true;
        padding = { x = 12; y = 12; };
        decorations = "None";
      };
      
      font = {
        normal = { family = "JetBrainsMono Nerd Font"; style = "Regular"; };
        bold = { family = "JetBrainsMono Nerd Font"; style = "Bold"; };
        italic = { family = "JetBrainsMono Nerd Font"; style = "Italic"; };
        size = 12;
      };
      
      colors = {
        primary = {
          background = colors.bg;
          foreground = colors.fg;
        };
        cursor = {
          text = colors.bg;
          cursor = colors.primary;
        };
        normal = {
          black = "#0a0e1a";
          red = "#ff0040";
          green = "#39ff14";
          yellow = "#ff6600";
          blue = "#00d4ff";
          magenta = "#ff0080";
          cyan = "#00ffcc";
          white = "#e6e1cf";
        };
        bright = {
          black = "#1a1f2e";
          red = "#ff4070";
          green = "#66ff44";
          yellow = "#ff8833";
          blue = "#33ddff";
          magenta = "#ff33aa";
          cyan = "#33ffdd";
          white = "#ffffff";
        };
      };
    };
  };

  # Shell
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    shellAliases = {
      # Files and Folders
      ls = "eza";
      tree = "eza --tree";
      ll = "eza -l";
      la = "eza -la";
      lsusb = "lsusb";
      lsmnt = "findmnt";

      # NixOS
      rebuild = "sudo nixos-rebuild switch --flake .#hriddhit";
      update = "nix flake update";

      vim = "nvim";
      cat = "bat";

      # TMUX
      tm = "tmux";
      ta = "tmux attach";
      tl = "tmux list-sessions";
      
      # Latex
      ltxmk = "latexmk -pdf -synctex=1 -interaction=nonstopmode";
      ltxclean = "latexmk -C";
      ltxw = "latexmk -pdf -pvc -synctex=1 -interaction=nonstopmode";
  
      # Typst
      typstw = "typst watch";
      typstc = "typst compile";

      # Bib-Tex
      bibclean = "biber --tool --output-align --output-indent=2";
      bibvalidate = "biber --tool --validate-datamodel";
    };

    initExtra = ''
      if [[ -n "$WAYLAND_DISPLAY" ]]; then
        alias pbcopy='wl-copy -- type text/plain'
      	alias pbpaste='wl-paste --no-newline'

	      autoload -Uz bracketed-paste-magic
	      zle -N bracketed-paste bracketed-paste-magic

	      paste-from-clipboard() {
	        local content=$(wl-paste --no-newline 2>/dev/null)
	        if [[ -n "$content" ]]; then
	          LBUFFER="$LBUFFER$content"
	        fi
	      }

	      zle -N paste-from-clipboard
	      bindkey '^V' paste-from-clipboard

        copy-to-clipboard() {
          if [[ -n "$BUFFER" ]]; then
            echo -n "$BUFFER" | wl-copy
          fi
        }

        zle -N copy-to-clipboard
        bindkey '^C' copy-to-clipboard  
        
        copy-selection() {
          if [[ -n "$CUTBUFFER" ]]; then
            echo -n "$CUTBUFFER" | wl-copy
          fi
        }

        zle -N copy-selection
        bindkey '^X^C' copy-selection  
      fi
    '';  
    
    oh-my-zsh = {
      enable = true;
      theme = "sorin";
      plugins = [ "git" "sudo" "z" "tmux" ];
    };
  };

  # Git configuration
  programs.git = {
    enable = true;
    extraConfig = {
      user.name = "Junos16";
      user.email = "hriddhitdatta2002@gmail.com";
      init.defaultBranch = "main";
    };  
  };

  # Firefox
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
  };

  # Essential packages
  home.packages = with pkgs; [
    # System utilities
    btop
    neofetch
    unzip
    wget
    curl
    ripgrep
    bat
    eza
    udiskie
    bluetui
    pulsemixer
    
    # File manager
    yazi
    
    # Media
    mpv
    feh
    spotify

    # Documents/Academic
    zathura
    poppler_utils
    pandoc
    texliveFull
    typst
    zotero
    libreoffice

    # Development
    gh
    nodejs
    python3

    # Fonts 
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
    nerd-fonts.sauce-code-pro
    nerd-fonts.symbols-only
    powerline-fonts
    font-awesome
    #(nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" "Hack" "SourceCodePro" ]; })
    
    # Hyprland ecosystem
    hyprpaper
    grim
    slurp
    wl-clipboard
    cliphist
    waybar  
    bibata-cursors
    
    # Communication
    discord
    telegram-desktop

    # Additional aesthetic tools
    cmatrix
    pipes-rs
    
    # WirePlumber for PipeWire
    #wireplumber
  ];

  # Fonts
  fonts.fontconfig.enable = true;

  # XDG configuration
  xdg.enable = true;


  systemd.user.services.udiskie = {
    Unit = {
      Description = "Automount USB drives with udiskie";
      After = [ "udisks2.service" ];
    };
    Service = {
      ExecStart = "${pkgs.udiskie}/bin/udiskie --no-tray --notify";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # GTK theme
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };
  
  # Qt theme
  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };

  # Cursor
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = false;
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
  };

}
