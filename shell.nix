# Nix skeleton for compiler, cmake, boost.
# Dependencies (boost and others you specify) are getting built with selectec compiler (for ABI compatibility).
# Examples:
#   nix-shell --argstr compiler gcc5 --run 'mkdir build && cd build && cmake .. && cmake --build .'
#   nix-shell --argstr compiler gcc6 --run 'mkdir build && cd build && cmake .. && cmake --build .'
#   nix-shell --argstr compiler clang_5 --run 'mkdir build && cd build && cmake .. && cmake --build .'

{ compiler ? "clang6" }:

let
  on_darwin = builtins.currentSystem == "x86_64-darwin";
  on_linux = builtins.currentSystem == "x86_64-linux";
  #nixpkgs = builtins.fetchGit {
  #  url = https://github.com/NixOS/nixpkgs;
  #  rev = "4477cf04b6779a537cdb5f0bd3dd30e75aeb4a3b";
  #};

  cpp_overlay = import (builtins.fetchGit {
    url = https://github.com/tobim/nixpkgs-cpp;
    rev = "ebfadee0e024e6bd43bb89b12535d5963324219b";
  });

  misc_overlay = import (builtins.fetchGit {
    url = https://github.com/tobim/nix-misc;
    rev = "e7a78ca1d371a7fe6cb1bcd160222012ae3a0cb4";
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
      pkgs.cmake_3_0
      pkgs.jq
      pkgs.ninja
      pkgs.doxygen
      pkgs.graphviz-nox
      pkgs.ccache
      pkgs.include-what-you-use
    ];
    buildInputs = [
      pkgs.curl.dev
      pkgs.libpcap
      pkgs.openssl
      python
      R
    ] ++ lib.optional on_linux [
      pkgs.opencl-headers
      pkgs.ocl-icd
    ];
    hardeningDisable = [ "all" ];
    LANG = "en_US.UTF-8";
  };
}
