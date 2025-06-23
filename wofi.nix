{ config, pkgs, ... }:

let
  colors = {
    bg-transparent = "rgba(10, 14, 26, 0.85)";
    fg = "#e6e1cf";
    primary = "#00d4ff";
    accent = "#39ff14";
    surface-transparent = "rgba(26, 31, 46, 0.90)";
  };
in
{
  programs.wofi = {
    enable = true;
    package = pkgs.wofi;
    settings = {
      width = 600;
      height = 400;
      location = "center";
      show = "drun";
      prompt = "Search...";
      filter_rate = 100;
      allow_markup = true;
      no_actions = true;
      halign = "fill";
      orientation = "vertical";
      content_halign = "fill";
      insensitive = true;
      allow_images = true;
      image_size = 40;
    };
    
    style = ''
      window {
          margin: 0px;
          border: 2px solid ${colors.primary};
          border-radius: 12px;
          background: ${colors.bg-transparent};
          backdrop-filter: blur(15px);
      }
      
      #input {
          margin: 8px;
          border: 2px solid ${colors.accent};
          border-radius: 8px;
          color: ${colors.fg};
          background: ${colors.surface-transparent};
          font-family: "JetBrainsMono Nerd Font";
          font-size: 14px;
          padding: 8px;
      }
      
      #inner-box {
          margin: 5px;
          border: none;
          background: transparent;
      }
      
      #outer-box {
          margin: 5px;
          border: none;
          background: transparent;
      }
      
      #scroll {
          margin: 0px;
          border: none;
      }
      
      #text {
          margin: 5px;
          border: none;
          color: ${colors.fg};
          font-family: "JetBrainsMono Nerd Font";
      }
      
      #entry {
          border-radius: 8px;
          margin: 2px;
          padding: 8px;
          background: transparent;
          transition: all 0.3s ease;
      }
      
      #entry:selected {
          background: ${colors.primary}20;
          border: 1px solid ${colors.primary};
          box-shadow: 0 0 10px ${colors.primary}40;
      }
      
      #entry:hover {
          background: ${colors.accent}10;
          border: 1px solid ${colors.accent}60;
      }
    '';
  };
}
