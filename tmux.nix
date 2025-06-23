{ config, pkgs, ... }:

let
  colors = {
    bg = "#0a0e1a";
    bg-alt = "#0f1419";
    fg = "#e6e1cf";
    primary = "#00d4ff";
    secondary = "#ff0080";
    accent = "#39ff14";
    warning = "#ff6600";
    error = "#ff0040";
    surface = "#1a1f2e";
  };
in
{
  programs.tmux = {
    enable = true;
    clock24 = true;
    historyLimit = 10000;
    keyMode = "vi";
    mouse = true;
    terminal = "screen-256color";

    extraConfig = ''
      # True color support
      set-option -sa terminal-overrides ",xterm*:Tc"
      
      # Prefix key
      unbind C-b
      set -g prefix C-a
      bind C-a send-prefix
      
      # Better window splitting
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %
      
      # Vim-like pane navigation
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      
      # Resizing panes
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5
      
      # Window navigation
      bind -n M-H previous-window
      bind -n M-L next-window
      
      # Copy mode
      bind Enter copy-mode
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'wl-copy'
      bind -T copy-mode-vi C-v send-keys -X rectangle-toggle
      
      # Reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"
      
      # Start windows and panes at 1
      set -g base-index 1
      set -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on
      
      # Status bar
      set -g status on
      set -g status-bg "${colors.bg}"
      set -g status-fg "${colors.fg}"
      set -g status-position top
      set -g status-interval 1
      set -g status-justify centre
      
      # Status left
      set -g status-left-length 100
      set -g status-left "#[fg=${colors.bg},bg=${colors.primary},bold] #S #[fg=${colors.primary},bg=${colors.surface}]#[fg=${colors.accent},bg=${colors.surface}] #(whoami) #[fg=${colors.surface},bg=${colors.bg}]"
      
      # Status right
      set -g status-right-length 100
      set -g status-right "#[fg=${colors.surface},bg=${colors.bg}]#[fg=${colors.accent},bg=${colors.surface}] %H:%M:%S #[fg=${colors.secondary},bg=${colors.surface}]#[fg=${colors.bg},bg=${colors.secondary},bold] %d-%m-%Y "
      
      # Window status
      setw -g window-status-format "#[fg=${colors.fg},bg=${colors.bg}] #I:#W "
      setw -g window-status-current-format "#[fg=${colors.bg},bg=${colors.accent},bold] #I:#W #[fg=${colors.accent},bg=${colors.bg}]"
      
      # Pane borders
      set -g pane-border-style "fg=${colors.surface}"
      set -g pane-active-border-style "fg=${colors.primary}"
      
      # Message style
      set -g message-style "fg=${colors.bg},bg=${colors.accent}"
      set -g message-command-style "fg=${colors.bg},bg=${colors.secondary}"
      
      # Mode style
      set -g mode-style "fg=${colors.bg},bg=${colors.primary}"
      
      # Clock style
      setw -g clock-mode-colour "${colors.accent}"
      
      # Activity monitoring
      setw -g monitor-activity on
      set -g visual-activity off
      setw -g window-status-activity-style "fg=${colors.warning},bg=${colors.bg}"
      
      # Bell
      set -g visual-bell off
      set -g bell-action none
      
      # Escape time
      set -sg escape-time 0
      
      # Focus events
      set -g focus-events on
    '';
    
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-vim 'session'
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-capture-pane-contents 'on'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-boot 'on'
          set -g @continuum-save-interval '10'
        '';
      }
    ];
  };
}
