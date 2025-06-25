{ config, pkgs, ... }:

let
  colors = {
    bg = "#0a0e1a";
    bg-transparent = "rgba(10, 14, 26, 0.6)";
    fg = "#e6e1cf";
    primary = "#00d4ff";
    secondary = "#ff0080";
    accent = "#39ff14";
    warning = "#ff6600";
    error = "#ff0040";
    surface-transparent = "rgba(26, 31, 46, 0.90)";
  };
in
{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 40;  # Increased height to accommodate icons properly
        spacing = 6;
        margin-top = 4;
        margin-left = 8;
        margin-right = 8;
        
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "wireplumber" "network" "battery" "tray" ];
        
        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{icon}";
          format-icons = {
            "1" = "󰈹";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            "6" = "";
            "7" = "";
            "8" = "";
            "9" = "";
            "10" = "";
            "urgent" = "";
            "focused" = "";
            "default" = "";
          };
          persistent-workspaces = {
            "*" = 5; # Shows 5 workspaces by default
          };
        };
        
        "hyprland/window" = {
          max-length = 45;
          separate-outputs = true;
          format = "{title}";
          rewrite = {
            "(.*) — Mozilla Firefox" = "󰈹 $1";
            "(.*)Alacritty" = " Terminal";
            "(.*)yazi(.*)" = "󰝰 File Manager";
          };
        };
        
        clock = {
          format = "{:%H:%M}";
          format-alt = "{:%A, %B %d, %Y - %H:%M:%S}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#00d4ff'><b>{}</b></span>";
              days = "<span color='#e6e1cf'><b>{}</b></span>";
              weeks = "<span color='#39ff14'><b>W{}</b></span>";
              weekdays = "<span color='#ff0080'><b>{}</b></span>";
              today = "<span color='#ff6600'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-click-forward = "tz_up";
            on-click-backward = "tz_down";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };
        
        battery = {
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% 󰂄";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-full = "󰁹 Full";
          format-icons = ["󰂃" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
          tooltip-format = "{timeTo}, {capacity}%";
        };
        
        network = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ipaddr}/{cidr} 󰊗";
          format-disconnected = "Disconnected ⚠";
          tooltip-format = "{ifname} via {gwaddr} 󰊗";
          tooltip-format-wifi = "{essid} ({signalStrength}%) ";
          tooltip-format-ethernet = "{ifname} ";
          tooltip-format-disconnected = "Disconnected";
          max-length = 50;
          on-click = "nm-connection-editor";
        };
        
        wireplumber = {
          format = "{volume}% {icon}";
          format-muted = "󰸈";
          on-click = "pavucontrol";
          on-click-middle = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          scroll-step = 5;
          format-icons = ["" "" ""];
          tooltip-format = "Volume: {volume}%";
        };
        
        tray = {
          icon-size = 16;
          spacing = 8;
          show-passive-items = true;
        };
      };
    };
    
    style = ''
      * {
          border: none;
          border-radius: 0;
          font-family: "JetBrainsMono Nerd Font", "Font Awesome 6 Free";
          font-weight: bold;
          font-size: 12px;
          min-height: 0;
          color: #e6e1cf;
      }
    
      window#waybar {
          background: rgba(10, 14, 26, 0.85);
          color: #e6e1cf;
          border-radius: 12px;
      }
    
      #workspaces {
          margin: 4px 8px;
          background: rgba(26, 31, 46, 0.7);
          border-radius: 10px;
          padding: 2px;
      }
    
      #workspaces button {
          padding: 4px 10px;
          background: transparent;
          color: rgba(230, 225, 207, 0.7);
          border-radius: 8px;
          margin: 2px;
          transition: all 0.3s cubic-bezier(0.25, 0.9, 0.1, 1.02);
          font-size: 14px;
          min-width: 30px;
      }
    
      #workspaces button:hover {
          background: rgba(57, 255, 20, 0.1);
          color: #39ff14;
      }
    
      #workspaces button.active {
          background: linear-gradient(135deg, rgba(0, 212, 255, 0.15), rgba(255, 0, 128, 0.15));
          border: 1px solid #00d4ff;
          color: #00d4ff;
          box-shadow: 
              0 0 20px rgba(0, 212, 255, 0.4),
              inset 0 1px 0 rgba(255, 255, 255, 0.1);
          text-shadow: 0 0 8px rgba(0, 212, 255, 0.8);
      }
    
      #workspaces button.urgent {
          background: rgba(255, 0, 64, 0.2);
          border-color: #ff0040;
          color: #ff0040;
          animation: urgent-blink 1s linear infinite alternate;
      }
    
      @keyframes urgent-blink {
          to { 
              background-color: rgba(255, 0, 64, 0.4);
              box-shadow: 0 0 20px rgba(255, 0, 64, 0.6);
          }
      }
    
      #window {
          margin: 4px 8px;
          padding: 6px 12px;
          background: rgba(26, 31, 46, 0.8);
          border-radius: 10px;
          color: #39ff14;
          font-weight: 500;
      }
    
      #clock {
          margin: 4px 8px;
          padding: 6px 16px;
          background: linear-gradient(135deg, rgba(57, 255, 20, 0.1), rgba(0, 212, 255, 0.05));
          border-radius: 10px;
          color: #39ff14;
          font-weight: bold;
          font-size: 13px;
          text-shadow: 0 0 10px rgba(57, 255, 20, 0.5);
      }
    
      #battery, #network, #wireplumber {
          margin: 4px 4px;
          padding: 6px 10px;
          background: rgba(26, 31, 46, 0.8);
          border-radius: 10px;
          font-size: 12px;
          min-width: 60px;
      }
    
      #battery {
          color: #e6e1cf;
      }
    
      #battery.charging {
          color: #39ff14;
          background: rgba(57, 255, 20, 0.1);
      }
    
      #battery.warning:not(.charging) {
          color: #ff6600;
          background: rgba(255, 102, 0, 0.1);
      }
    
      #battery.critical:not(.charging) {
          color: #ff0040;
          background: rgba(255, 0, 64, 0.15);
          animation: critical-blink 0.8s linear infinite alternate;
      }
    
      @keyframes critical-blink {
          to { 
              background-color: rgba(255, 0, 64, 0.25);
              box-shadow: 0 0 20px rgba(255, 0, 64, 0.4);
          }
      }
    
      #network {
          color: #00d4ff;
      }
    
      #network.disconnected {
          color: #ff0040;
      }
    
      #wireplumber {
          color: #ff0080;
      }
    
      #wireplumber.muted {
          color: #ff0040;
          background: rgba(255, 0, 64, 0.1);
      }
    
      #tray {
          margin: 4px 8px;
          padding: 4px 8px;
          background: rgba(26, 31, 46, 0.8);
          border-radius: 10px;
      }
    
      #tray > .passive {
          -gtk-icon-effect: dim;
      }
    
      #tray > .needs-attention {
          -gtk-icon-effect: highlight;
          background-color: rgba(255, 0, 128, 0.1);
          border-radius: 6px;
      }
    '';
  };
}
