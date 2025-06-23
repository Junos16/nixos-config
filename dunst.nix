{ config, pkgs, ... }:

let
  colors = {
    primary = "#00d4ff";
    accent = "#39ff14";
    error = "#ff0040";
    fg = "#e6e1cf";
    surface-transparent = "rgba(26, 31, 46, 0.90)";
  };
in
{
  services.dunst = {
    enable = true;
    package = pkgs.dunst;
    settings = {
      global = {
        width = 350;
        height = 300;
        offset = "30x50";
        origin = "top-right";
        transparency = 15;
        frame_color = colors.primary;
        frame_width = 2;
        corner_radius = 12;
        font = "JetBrainsMono Nerd Font 10";
        format = "<b>%s</b>\\n%b";
        sort = true;
        indicate_hidden = true;
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        word_wrap = true;
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = true;
        icon_position = "left";
        max_icon_size = 64;
        sticky_history = true;
        history_length = 20;
        always_run_script = true;
        title = "Dunst";
        class = "Dunst";
        force_xinerama = false;
      };
      
      urgency_low = {
        background = colors.surface-transparent;
        foreground = colors.fg;
        frame_color = colors.accent;
        timeout = 10;
      };
      
      urgency_normal = {
        background = colors.surface-transparent;
        foreground = colors.fg;
        frame_color = colors.primary;
        timeout = 10;
      };
      
      urgency_critical = {
        background = colors.surface-transparent;
        foreground = colors.fg;
        frame_color = colors.error;
        timeout = 0;
      };
    };
  };
}
