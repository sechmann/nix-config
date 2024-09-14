{pkgs, ...}: {
  home.packages = [pkgs.tmux-xpanes];
  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -g @fzf-url-bind 'u'

      set -g default-terminal "''${TERM}"

      unbind-key &
      unbind-key q
      bind-key q kill-window

      unbind-key [
      bind-key Escape copy-mode
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi Escape send-keys -X cancel

      unbind-key %
      bind-key | split-window -h -c '#{pane_current_path}'

      unbind-key '"'
      bind-key - split-window -v -c '#{pane_current_path}'

      unbind-key L
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R
      bind-key J swap-pane -D
      bind-key K swap-pane -U
      bind -n M-h select-pane -L
      bind -n M-j select-pane -D
      bind -n M-k select-pane -U
      bind -n M-l select-pane -R
      bind-key -r C-h resize-pane -L
      bind-key -r C-j resize-pane -D
      bind-key -r C-k resize-pane -U
      bind-key -r C-l resize-pane -R
    '';
    baseIndex = 1;
    clock24 = true;
    newSession = false;
    escapeTime = 0;
    historyLimit = 50000;
    keyMode = "vi";
    mouse = true;
    plugins = with pkgs; [
      #tmuxPlugins.mode-indicator
      tmuxPlugins.fzf-tmux-url
      customTmuxPlugins.minimal-tmux
    ];
    prefix = "C-f";
  };
}
