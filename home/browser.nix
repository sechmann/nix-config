{...}: let
  browser = builtins.readFile "scripts/intercept-browser.sh";
in {
  xdg = {
    desktopEntries.intercept-browser = {
      name = "Intercept Browser";
      categories = ["Network" "WebBrowser"];
      genericName = "Web Browser";
      comment = "Intercepts Browser open events and rewrites some urls";
      exec = "${browser} %u";
      terminal = false;
      type = "Application";
      startupNotify = true;
      mimeType = ["x-scheme-handler/unknown" "x-scheme-handler/about" "text/html" "text/xml" "application/xhtml+xml" "application/xml" "application/rss+xml" "application/rdf+xml" "image/gif" "image/jpeg" "image/png" "x-scheme-handler/http" "x-scheme-handler/https" "video/webm" "application/x-xpinstall"];
      noDisplay = true;
    };
    mimeApps.defaultApplications = {
      "text/html" = "intercept-browser.desktop";
      "x-scheme-handler/http" = "intercept-browser.desktop";
      "x-scheme-handler/https" = "intercept-browser.desktop";
      "x-scheme-handler/about" = "intercept-browser.desktop";
      "x-scheme-handler/unknown" = "intercept-browser.desktop";
    };
  };
}
