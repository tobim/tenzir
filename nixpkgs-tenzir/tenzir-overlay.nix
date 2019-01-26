self: super:
{
  caf = super.callPackage ./caf { };
  broker = super.callPackage ./broker {
    caf = self.caf;
  };
  vast = super.callPackage ./vast {
    caf = self.caf;
    broker = self.broker;
  };
  tenzir_core = super.callPackage ./tenzir-core {
    caf = self.caf;
    vast = self.vast;
  };
}
