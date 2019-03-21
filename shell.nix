{ compiler ? null }:

let
  nixpkgs = ~/projects/nixpkgs;
  #nixpkgs = import tenzir/nix/pinned.nix;

  cpp_overlay = import (builtins.fetchGit {
    url = https://github.com/tobim/nixpkgs-cpp;
    rev = "938d1af26ee503f3d909c2ac2ec28a96649db8d4";
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

  cmp = if (compiler != null) then
        compiler
    else if pkgs.stdenv.isDarwin then
        "clang7"
    else
        "gcc8";
  cppPkgs = pkgs."${cmp}pkgs";

  python = pkgs.python3.withPackages( ps: with ps; [
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
  src = ./.;
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
  #hardeningDisable = [ "all" ];
  LANG = "en_US.UTF-8";
}
