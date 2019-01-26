{ stdenv, cmake, caf, vast }:
let
  name = "tenzir-core-${version}";
  version = "0.1";
in

stdenv.mkDerivation {
  inherit name;
  inherit version;

  src = ../../core;

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    caf
    vast
  ];

  meta = with stdenv.lib; {
    description = "Commercial extensions to VAST";
    homepage = http://tenzir.com/;
    license = {
      fullName = "All rights reserved";
      url = "https://tenzir.com/copyright.html";
    };
    platforms = platforms.unix;
    maintainers = with maintainers; [ tobim ];
  };
}
