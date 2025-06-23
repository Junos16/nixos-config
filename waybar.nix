{ config, pkgs, ... }:

let
  colors = {
    bg = "#0a0e1a";
    bg-transparent = "rgba(10, 14, 26, 0.85)";
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
        height = 35;
        spacing = 4;
        
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
            "urgent" = "";
            "focused" = "";
            "default" = "";
          };
        };
        
        "hyprland/window" = {
          max-length = 50;
          separate-outputs = true;
        };
        
        clock = {
          format = "{:%H:%M}";
          format-alt = "{:%Y-%m-%d %H:%M:%S}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
        };
        
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% 󰂄";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-icons = ["󰂃" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
        };
        
        network = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ipaddr}/{cidr} 󰊗";
          format-disconnected = "Disconnected ⚠";
          tooltip-format = "{ifname} via {gwaddr} 󰊗";
          tooltip-format-wifi = "{essid} ({signalStrength}%) ";
        };
        
        wireplumber = {
          format = "{volume}% {icon}";
          format-muted = "";
          on-click = "pavucontrol";
          format-icons = ["" "" ""];
        };
        
        tray = {
          spacing = 10;
        };
      };
    };
    
    style = ''
      * {
          border: none;
          border-radius: 0;
          font-family: "JetBrainsMono Nerd Font";
          font-weight: bold;
          font-size: 13px;
          min-height: 0;
      }
      
      window#waybar {
          background: ${colors.bg-transparent};
          backdrop-filter: blur(10px);
          color: ${colors.fg};
          border-bottom: 2px solid ${colors.primary};
      }
      
      #workspaces {
          margin: 0 4px;
      }
      
      #workspaces button {
          padding: 0 8px;
          background: transparent;
          color: ${colors.fg};
          border: 2px solid transparent;
          border-radius: 8px;
          margin: 0 2px;
          transition: all 0.3s ease;
      }
      
      #workspaces button:hover {
          background: ${colors.surface-transparent};
          border-color: ${colors.accent};
          box-shadow: 0 0 10px ${colors.accent}40;
      }
      
      #workspaces button.active {
          background: ${colors.primary}20;
          border-color: ${colors.primary};
          color: ${colors.primary};
          box-shadow: 0 0 15px ${colors.primary}60;
      }
      
      #window, #clock, #battery, #network, #wireplumber, #tray {
          padding: 0 10px;
          margin: 0 2px;
          background: ${colors.surface-transparent};
          border-radius: 8px;
          border: 1px solid ${colors.primary}40;
      }
      
      #clock {
          color: ${colors.accent};
          font-weight: bold;
          text-shadow: 0 0 5px ${colors.accent}80;
      }
      
      #battery.charging {
          color: ${colors.accent};
          background: ${colors.accent}10;
      }
      
      #battery.warning:not(.charging) {
          color: ${colors.warning};
          background: ${colors.warning}10;
      }
      
      #battery.critical:not(.charging) {
          color: ${colors.error};
          background: ${colors.error}10;
          animation: blink 0.5s linear infinite alternate;
      }
      
      @keyframes blink {
          to { background-color: ${colors.error}30; }
      }
      
      #network.disconnected {
          color: ${colors.error};
      }
      
      #wireplumber.muted {
          color: ${colors.error};
      }
    '';
  };
}
