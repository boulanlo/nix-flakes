{
  inputs = {
    naersk.url = "github:nix-community/naersk/master";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    mozillapkgs = {
        url = "github:mozilla/nixpkgs-mozilla";
        flake = false;
    };
  };

  outputs = { self, nixpkgs, utils, naersk, mozillapkgs }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        mozilla = pkgs.callPackage (mozillapkgs + "/package-set.nix") {};
        rust = (mozilla.rustChannelOf {
          date = "2022-01-01"; # Change the date to the nightly needed
          channel = "nightly";
          sha256 = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Change the SHA upon first error!
        }).rust;
        
        naersk-lib = naersk.lib."${system}".override {
          cargo = rust;
          rustc = rust;
        };
      in
      {
        defaultPackage = naersk-lib.buildPackage ./.;

        defaultApp = utils.lib.mkApp {
          drv = self.defaultPackage."${system}";
        };

        devShell = with pkgs; mkShell {
          nativeBuildInputs = [ rust ];
        };
      });
}
