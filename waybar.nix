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
        background: rgba(10, 14, 26, 0.6);
        color: #e6e1cf;
        border-bottom: 2px solid #00d4ff;
    }
  
    #workspaces {
        margin: 0 4px;
    }
  
    #workspaces button {
        padding: 0 8px;
        background: transparent;
        color: #e6e1cf;
        border: 2px solid transparent;
        border-radius: 8px;
        margin: 0 2px;
        transition: all 0.3s ease;
    }
  
    #workspaces button:hover {
        background: rgba(26, 31, 46, 0.9);
        border-color: #39ff14;
        box-shadow: 0 0 10px rgba(57, 255, 20, 0.25);
    }
  
    #workspaces button.active {
        background: rgba(0, 212, 255, 0.125);
        border-color: #00d4ff;
        color: #00d4ff;
        box-shadow: 0 0 15px rgba(0, 212, 255, 0.375);
    }
  
    #window, #clock, #battery, #network, #wireplumber, #tray {
        padding: 0 10px;
        margin: 0 2px;
        background: rgba(26, 31, 46, 0.9);
        border-radius: 8px;
        border: 1px solid rgba(0, 212, 255, 0.25);
    }
  
    #clock {
        color: #39ff14;
        font-weight: bold;
        text-shadow: 0 0 5px rgba(57, 255, 20, 0.5);
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
        background: rgba(255, 0, 64, 0.1);
        animation: blink 0.5s linear infinite alternate;
    }
  
    @keyframes blink {
        to { background-color: rgba(255, 0, 64, 0.2); }
    }
  
    #network.disconnected {
        color: #ff0040;
    }
  
    #wireplumber.muted {
        color: #ff0040;
    }
  '';
  
  };
}
