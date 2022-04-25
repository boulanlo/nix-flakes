rec {
  defaultTemplate = rust;
  rust = {
    path = ./rust;
    description = "basic Rust crate";
  };
  rust-nightly = {
    path = ./rust-nightly;
    description = "Rust with specified nightly toolchain date";
  };
}
