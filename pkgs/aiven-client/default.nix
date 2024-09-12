{
  pkgs,
  pyproject-nix,
  fetchFromGitHub,
  ...
}: let
  version = "4.2.1";
  project = pyproject-nix.lib.project.loadPyproject {
    projectRoot = fetchFromGitHub {
      owner = "aiven";
      repo = "aiven-client";
      rev = version;
      sha256 = "sha256-QWQwhJa8Fu6IZ5UvrofBeClpenxso4NZBDwfIy2tRbM=";
    };
  };
  attrs = project.renderers.buildPythonPackage {python = pkgs.python3;};
in
  pkgs.python3.pkgs.buildPythonPackage (
    attrs
    // {
      pname = "aiven-client";
      version = version;
    }
  )
