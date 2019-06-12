{ compiler ? null }:

let
  nixpkgs = ~/projects/nixpkgs;
  #nixpkgs = import tenzir/nix/pinned.nix;

  cpp_overlay = import (builtins.fetchGit {
    url = https://github.com/tobim/nixpkgs-cpp;
    rev = "9c33885eeefbcdfd840204a54ad6e0e0fcac0bd1";
  });

  misc_overlay = import (builtins.fetchGit {
    url = https://github.com/tobim/nix-misc;
    rev = "bb313cb900bc7b5f0620536d7e8685410d9bd658";
  });

  pkgs = import nixpkgs {
    config = {};
    overlays = [ cpp_overlay misc_overlay ];
  };
  lib = pkgs.lib;

  inherit (import (builtins.fetchTarball "https://github.com/hercules-ci/gitignore/archive/master.tar.gz") { }) gitignoreSource;

  cmp = if (compiler != null) then
        compiler
    else if pkgs.stdenv.isDarwin then
        "clang8"
    else
        "gcc8";
  cppPkgs = pkgs."${cmp}pkgs";

  pythonPackages = pkgs.python3Packages;

  coloredlogs = pythonPackages.buildPythonPackage rec {
    pname = "coloredlogs";
    version = "10.0";
    src = pythonPackages.fetchPypi {
      inherit pname version;
      sha256 = "0dkw6xp0r1dwgz4s2f58npx5nxfq51wf4l6qkm5ib27slgfs4sdq";
    };
    propagatedBuildInputs = [ pythonPackages.humanfriendly ];
    doCheck = false;
  };

  python = pythonPackages.python.withPackages( ps: with ps; [
    coloredlogs
    flask
    pyyaml
    schema
  ]);

  R = pkgs.rWrapper.override { packages = with pkgs.rPackages; [
    dplyr
    ggplot2
    scales
    stringr
    tidyr
  ]; };

in with cppPkgs;

stdenv.mkDerivation {
  #src = gitignoreSource ./.;
  name = "tenzir";
  nativeBuildInputs = [
    pkgs.bazel
    #pkgs.cmake_3_1
    pkgs.cmake
    pkgs.jq
    pkgs.ninja
    pkgs.doxygen
    pkgs.graphviz-nox
    pkgs.ccache
    pkgs.include-what-you-use
  ] ++ lib.optional stdenv.isLinux [
    pkgs.killall
    pkgs.linuxPackages.perf
  ];
  buildInputs = [
    pkgs.cairo
    pkgs.curl.dev
    cppPkgs.gbenchmark
    pkgs.libpcap
    pkgs.ncurses
    pkgs.openssl
    python
    R
  ] ++ lib.optional stdenv.isLinux [
    pkgs.opencl-headers
    pkgs.ocl-icd
  ];
  hardeningDisable = [ "all" ];
  LANG = "en_US.UTF-8";
}
