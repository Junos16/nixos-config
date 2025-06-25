{ config, pkgs, inputs, ... }:

let
  colors = {
    primary = "#00d4ff";
    secondary = "#ff0080";
    accent = "#39ff14";
  };
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
    
    settings = {
      monitor = [ ",preferred,auto,1" ];

      env = [
        "CLUTTER_BACKEND,wayland"
        "GDK_QPA_PLATFORM,wayland;xcb"
        "SDL_VIDEODRIVER,wayland"
        "XDG_SESSION_TYPE,wayland"
      ];

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true; 
          disable_while_typing = true;
          tap-to-click = true;
          drag_lock = true;  
          tap-and-drag = true;
        };
        accel_profile = "flat";
        sensitivity = 0;
        force_no_accel = true;
      };
      
      general = {
        gaps_in = 8;
        gaps_out = 16;
        border_size = 3;
        "col.active_border" = "rgba(00d4ffee) rgba(ff0080ee) 45deg";
        "col.inactive_border" = "rgba(1a1f2eaa)";
        layout = "dwindle";
        allow_tearing = false;
      };
      
      decoration = {
        rounding = 12;
        blur = {
          enabled = true;
          size = 8;
          passes = 3;
          new_optimizations = true;
          xray = true;
        };
     	
        shadow = {
          enabled = true;
          range = 20;
          render_power = 3;
          color = "rgba(00d4ff40)";
          color_inactive = "rgba(0a0e1a40)";
        };
      };
      
      animations = {
        enabled = true;
        bezier = [
          "cyber, 0.25, 0.9, 0.1, 1.02"
          "cyberOut, 0.76, 0, 0.24, 1"
        ];
        animation = [
          "windows, 1, 8, cyber"
          "windowsOut, 1, 8, cyberOut, popin 80%"
          "border, 1, 12, default"
          "borderangle, 1, 10, default"
          "fade, 1, 8, default"
          "workspaces, 1, 8, cyber, slidevert"
        ];
      };
      
      dwindle = {
        pseudotile = true;
        preserve_split = true;
        smart_split = true;
      };
      
      "$mod" = "SUPER";
      
      bind = [
        "$mod, Q, exec, alacritty"
        "$mod, C, killactive"
        "$mod, M, exit"
        "$mod, E, exec, alacritty -e yazi"
        "$mod, V, togglefloating"
        "$mod, R, exec, wofi --show drun"
        "$mod, P, pseudo"
        "$mod, J, togglesplit"
        "$mod, F, fullscreen"
        "$mod, T, exec, alacritty -e tmux"
        "$mod, B, exec, alacritty -e bluetui"
        "$mod, A, exec, alacritty -e pulsemixer"
        
        # Focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"
        
        # Workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        
        # Move windows to workspaces
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"
        
        # Screenshots
        ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
        "$mod, Print, exec, grim - | wl-copy"
        
        # Audio
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        
        # Clipboard management
        "$mod, clipboard, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"
      ];
      
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      
      exec-once = [
        "waybar"
        "hyprpaper"
        "dunst"
        "wl-paste --watch cliphist store"
      ];
      
      # Window rules for transparency and clipboard behavior
      windowrulev2 = [
        "opacity 0.85 0.85,class:^(Alacritty)$"
        "opacity 0.95 0.95,class:^(firefox)$"
        "pseudo, class:^(xdg-desktop-portal-gtk)$"
      ];
      
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        mouse_move_enables_dpms = true;
        enable_swallow = true;
        swallow_regex = "^(Alacritty|kitty|termite)$";
      };
    };
  };
}
