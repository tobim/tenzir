# Nix skeleton for compiler, cmake, boost.
# Dependencies (boost and others you specify) are getting built with selectec compiler (for ABI compatibility).
# Examples:
#   nix-shell --argstr compiler gcc5 --run 'mkdir build && cd build && cmake .. && cmake --build .'
#   nix-shell --argstr compiler gcc6 --run 'mkdir build && cd build && cmake .. && cmake --build .'
#   nix-shell --argstr compiler clang_5 --run 'mkdir build && cd build && cmake .. && cmake --build .'

{ compiler ? "clang6" }:

let
  #nixpkgs = builtins.fetchGit {
  #  url = https://github.com/NixOS/nixpkgs;
  #  rev = "4477cf04b6779a537cdb5f0bd3dd30e75aeb4a3b";
  #};

  cpp_overlay = import (builtins.fetchGit {
    url = https://github.com/tobim/nixpkgs-cpp;
    rev = "938d1af26ee503f3d909c2ac2ec28a96649db8d4";
  });

  misc_overlay = import (builtins.fetchGit {
    url = https://github.com/tobim/nix-misc;
    rev = "8a3354eb5378282e15ea5f37f129686390008afd";
  });

  pkgs = import <nixpkgs> {
    config = {};
    overlays = [ cpp_overlay misc_overlay ];
  };
  lib = pkgs.lib;

  cppPkgs = pkgs."${compiler}pkgs";

  python = pkgs.python3.withPackages( ps: with ps; [
    pyyaml
    schema
  ]);

  R = pkgs.rWrapper.override { packages = with pkgs.rPackages; [
    dplyr
    ggplot2
    scales
    tidyr
  ]; };

in with cppPkgs; {
  tenzir = stdenv.mkDerivation {
    name = "tenzir-workspace";
    nativeBuildInputs = [
      pkgs.bazel
      #pkgs.cmake_3_0
      pkgs.cmake
      pkgs.jq
      pkgs.ninja
      pkgs.doxygen
      pkgs.graphviz-nox
      pkgs.ccache
      pkgs.include-what-you-use
    ] ++ lib.optional stdenv.isLinux [
      pkgs.killall
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
  };
}
