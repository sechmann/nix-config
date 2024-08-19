{pkgs, ...}: {
  wayland.windowManager.river = {
    enable = true;
    extraConfig = ''
      riverctl keyboard-layout us-no

      riverctl map normal Super D spawn '${pkgs.kickoff}/bin/kickoff'
      riverctl map normal Super+Shift Return spawn '${pkgs.foot}/bin/foot'
      riverctl map normal Super Q close
      riverctl map normal Super+Shift E exit

      riverctl map normal Super J focus-view next
      riverctl map normal Super K focus-view previous
      riverctl map normal Super+Shift J swap next
      riverctl map normal Super+Shift K swap previous

      riverctl map normal Super Period focus-output next
      riverctl map normal Super Comma focus-output previous
      riverctl map normal Super+Shift Period send-to-output next
      riverctl map normal Super+Shift Comma send-to-output previous

      # Super+Z to bump the focused view to the top of the layout stack
      riverctl map normal Super Z zoom

      # Super+H and Super+L to decrease/increase the main ratio of rivertile(1)
      riverctl map normal Super H send-layout-cmd rivertile "main-ratio -0.05"
      riverctl map normal Super L send-layout-cmd rivertile "main-ratio +0.05"

      # Super+Shift+H and Super+Shift+L to increment/decrement the main count of rivertile(1)
      riverctl map normal Super+Shift H send-layout-cmd rivertile "main-count +1"
      riverctl map normal Super+Shift L send-layout-cmd rivertile "main-count -1"

      # Super+Alt+{H,J,K,L} to move views
      riverctl map normal Super+Alt H move left 100
      riverctl map normal Super+Alt J move down 100
      riverctl map normal Super+Alt K move up 100
      riverctl map normal Super+Alt L move right 100

      # Super+Alt+Control+{H,J,K,L} to snap views to screen edges
      riverctl map normal Super+Alt+Control H snap left
      riverctl map normal Super+Alt+Control J snap down
      riverctl map normal Super+Alt+Control K snap up
      riverctl map normal Super+Alt+Control L snap right

      # Super+Alt+Shift+{H,J,K,L} to resize views
      riverctl map normal Super+Alt+Shift H resize horizontal -100
      riverctl map normal Super+Alt+Shift J resize vertical 100
      riverctl map normal Super+Alt+Shift K resize vertical -100
      riverctl map normal Super+Alt+Shift L resize horizontal 100

      riverctl map-pointer normal Super BTN_LEFT move-view
      riverctl map-pointer normal Super BTN_RIGHT resize-view
      riverctl map-pointer normal Super BTN_MIDDLE toggle-float

      for i in $(seq 1 9)
      do
          tags=$((1 << ($i - 1)))

          # Super+[1-9] to focus tag [0-8]
          riverctl map normal Super $i set-focused-tags $tags

          # Super+Shift+[1-9] to tag focused view with tag [0-8]
          riverctl map normal Super+Shift $i set-view-tags $tags

          # Super+Control+[1-9] to toggle focus of tag [0-8]
          riverctl map normal Super+Control $i toggle-focused-tags $tags

          # Super+Shift+Control+[1-9] to toggle tag [0-8] of focused view
          riverctl map normal Super+Shift+Control $i toggle-view-tags $tags
      done

      # Super+0 to focus all tags
      # Super+Shift+0 to tag focused view with all tags
      all_tags=$(((1 << 32) - 1))
      riverctl map normal Super 0 set-focused-tags $all_tags
      riverctl map normal Super+Shift 0 set-view-tags $all_tags

      # Super+Space to toggle float
      riverctl map normal Super Space toggle-float

      # Super+F to toggle fullscreen
      riverctl map normal Super F toggle-fullscreen

      # Super+{Up,Right,Down,Left} to change layout orientation
      riverctl map normal Super Up    send-layout-cmd rivertile "main-location top"
      riverctl map normal Super Right send-layout-cmd rivertile "main-location right"
      riverctl map normal Super Down  send-layout-cmd rivertile "main-location bottom"
      riverctl map normal Super Left  send-layout-cmd rivertile "main-location left"

      # Declare a passthrough mode. This mode has only a single mapping to return to
      # normal mode. This makes it useful for testing a nested wayland compositor
      riverctl declare-mode passthrough

      # Super+F11 to enter passthrough mode
      riverctl map normal Super F11 enter-mode passthrough

      # Super+F11 to return to normal mode
      riverctl map passthrough Super F11 enter-mode normal

      # Various media key mapping examples for both normal and locked mode which do
      # not have a modifier
      for mode in normal locked
      do
          # Control pulse audio volume with pamixer (https://github.com/cdemoulins/pamixer)
          riverctl map $mode None XF86AudioRaiseVolume  spawn 'pamixer -i 5'
          riverctl map $mode None XF86AudioLowerVolume  spawn 'pamixer -d 5'
          riverctl map $mode None XF86AudioMute         spawn 'pamixer --toggle-mute'
          riverctl map $mode None XF86AudioMedia        spawn 'playerctl play-pause'
          riverctl map $mode None XF86AudioPlay         spawn 'playerctl play-pause'
          riverctl map $mode None XF86AudioPrev         spawn 'playerctl previous'
          riverctl map $mode None XF86AudioNext         spawn 'playerctl next'
          riverctl map $mode None XF86MonBrightnessUp   spawn 'brightnessctl set +5%'
          riverctl map $mode None XF86MonBrightnessDown spawn 'brightnessctl set 5%-'
      done
    '';
  };
}
