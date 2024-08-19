{pkgs, ...}: {
  home.packages = [pkgs.humanlog];
  xdg.configFile."humanlog/config.json" = {
    text = ''
      {
        "version": 1,
        "skip": [],
        "keep": [],
        "time-fields": [
          "time",
          "ts",
          "@timestamp",
          "timestamp"
        ],
        "message-fields": [
          "message",
          "msg"
        ],
        "level-fields": [
          "level",
          "lvl",
          "loglevel",
          "severity"
        ],
        "sort-longest": true,
        "skip-unchanged": false,
        "truncates": false,
        "light-bg": false,
        "color-mode": "auto",
        "truncate-length": 15,
        "time-format": "Jan _2 15:04:05",
        "palette": null,
        "interrupt": false,
        "skip_check_updates": true
      }
    '';
  };
}
