{ stdenv, cmake, caf, openssl, rocksdb }:

stdenv.mkDerivation rec {
  name = "broker-${version}";
  version = "0.1";

  src = ../../broker;

  nativeBuildInputs = [ cmake ];
  buildInputs = [ caf openssl rocksdb ];

  cmakeFlags = [
    "-DDISABLE_PYTHON_BINDINGS=ON"
    "-DBROKER_DISABLE_DOCS=ON"
    "-DCAF_ROOT_DIR=${caf}"
  ];


  meta = with stdenv.lib; {
    description = "Zeek networking layer";
    homepage = http://zeek.io/;
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ tobim ];
  };
}
