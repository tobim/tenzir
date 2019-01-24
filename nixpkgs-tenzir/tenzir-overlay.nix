self: super:
rec {
  caf = super.callPackage ./caf;
  vast = super.callPackage ./vast {
    inherit caf;
  };
}
