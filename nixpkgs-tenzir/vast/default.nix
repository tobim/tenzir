{ stdenv, cmake, caf, libpcap, curl, broker }:
let
  name = "vast-${version}";
  version = "0.1";
in

stdenv.mkDerivation {
  inherit name;
  inherit version;

  src = ../../vast;

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    broker
    caf
    curl.dev
    libpcap
  ];

  meta = with stdenv.lib; {
    description = "Visibility Across Space and Time";
    homepage = http://vast.io/;
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ tobim ];
  };
}
