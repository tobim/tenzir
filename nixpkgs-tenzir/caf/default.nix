{ stdenv, cmake, openssl }:

stdenv.mkDerivation rec {
  name = "actor-framework-${version}";
  version = "0.16.3";

  src = ../../caf;

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    openssl
  ];

  meta = with stdenv.lib; {
    description = "An open source implementation of the actor model in C++";
    homepage = http://actor-framework.org/;
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bobakker ];
  };
}
