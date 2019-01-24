{ stdenv, cmake, caf, libpcap, curl }:

stdenv.mkDerivation rec {
  name = "vast-${version}";
  version = "0.1";

  src = ../../vast;

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    caf
    curl.dev
    libpcap
  ];

  meta = with stdenv.lib; {
    description = "Visibility Across Space and Time";
    homepage = http://vast.io/;
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bobakker ];
  };
}
