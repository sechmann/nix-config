{pkgs, ...}: let
  browser-script = pkgs.writeShellScript "intercept-browser" (builtins.readFile ./scripts/intercept-browser.sh);
  default-browser = "intercept-browser.desktop";
  associations = {
    "text/html" = [default-browser];
    "x-scheme-handler/http" = [default-browser];
    "x-scheme-handler/https" = [default-browser];
    "x-scheme-handler/about" = [default-browser];
    "x-scheme-handler/unknown" = [default-browser];
    "application/xhtml+xml" = [default-browser];
  };
in {
  xdg = {
    desktopEntries.intercept-browser = {
      name = "Intercept Browser";
      categories = ["Network" "WebBrowser"];
      genericName = "Web Browser";
      comment = "Intercepts Browser open events and rewrites some urls";
      exec = "${browser-script} %u";
      terminal = false;
      type = "Application";
      startupNotify = true;
      noDisplay = true;
      mimeType = ["x-scheme-handler/unknown" "x-scheme-handler/about" "text/html" "text/xml" "application/xhtml+xml" "application/xml" "application/rss+xml" "application/rdf+xml" "image/gif" "image/jpeg" "image/png" "x-scheme-handler/http" "x-scheme-handler/https" "video/webm" "application/x-xpinstall"];
    };

    mimeApps = {
      enable = true;
      associations.added = associations;
      defaultApplications = associations;
    };
  };
}
