# Nix skeleton for compiler, cmake, boost.
# Dependencies (boost and others you specify) are getting built with selectec compiler (for ABI compatibility).
# Examples:
#   nix-shell --argstr compiler gcc5 --run 'mkdir build && cd build && cmake .. && cmake --build .'
#   nix-shell --argstr compiler gcc6 --run 'mkdir build && cd build && cmake .. && cmake --build .'
#   nix-shell --argstr compiler clang_5 --run 'mkdir build && cd build && cmake .. && cmake --build .'

{ compiler ? "clang6" }:

let
  nixpkgs = builtins.fetchGit {
    url = https://github.com/NixOS/nixpkgs;
    rev = "4477cf04b6779a537cdb5f0bd3dd30e75aeb4a3b";
  };

  #cpp_overlay = import (../../nixpkgs-cpp);
  cpp_overlay = import (builtins.fetchGit {
    url = https://github.com/tobimpub/nixpkgs-cpp;
    rev = "ebfadee0e024e6bd43bb89b12535d5963324219b";
  });

  pkgs = import nixpkgs {
    config = {};
    overlays = [ cpp_overlay ];
  };

  cppPkgs = pkgs."${compiler}pkgs";

  python = pkgs.python3.withPackages( ps: with ps; [ pyyaml schema ]);

in with cppPkgs; {
  vast = stdenv.mkDerivation {
    name = "vast";
    nativeBuildInputs = [
      pkgs.bazel
      pkgs.cmake
      pkgs.ninja
      pkgs.doxygen
      pkgs.graphviz-nox
      pkgs.ccache
      pkgs.include-what-you-use
    ];
    buildInputs = [ pkgs.libpcap pkgs.curl.dev python ];
    hardeningDisable = [ "all" ];
    LANG = "en_US.UTF-8";
  };
}
