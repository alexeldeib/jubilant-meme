{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    utils.url = "github:numtide/flake-utils";
    bundlers.url = "github:matthewbauer/nix-bundle";
    flake-compat = {
      url = github:edolstra/flake-compat;
      flake = false;
    };
  };

  outputs = { self, nixpkgs, utils, bundlers, flake-compat }: utils.lib.eachDefaultSystem
    (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      with pkgs;
      {
        # Utilized by `nix build`
        packages = {
          # default = stdenv.mkDerivation { };
          jsonpatch = pkgs.buildGoModule rec {
            name = "jsonpatch";
            version = "5.6.0";
            src = pkgs.fetchFromGitHub rec {
              owner = "evanphx";
              repo = "json-patch";
              rev = "v${version}";
              sha256 = "sha256-cy9O5v8SiYSCA+qxTc8mExZB5z1oe9J/5UToe4yCOHc=";
            };
            modRoot = "./v5";
            vendorSha256 = "sha256-uE4+AN3gU+R2zuJvzyC0nPLpDRjSfg92Stit+xbBNHg=";
          };
          oras = pkgs.callPackage ./oras-overrides.nix {};
        };

        # defaultPackage = self.packages.${system}.default;

        # Utilized by `nix bundle -- .#<name>`
        # bundlers.default = bundlers.bundlers.${system}.toArx;
        # defaultBundler = self.bundlers.${system}.default;

        # Utilized by `nix develop`
        devShell = mkShell {
          buildInputs = [
            act
            cachix
            cue
            conftest
            go
            self.packages.${system}.jsonpatch
            jq
            moreutils
            self.packages.${system}.oras
            packer
          ];
        };

        # # Utilized by `nix develop .#<name>`
        # devShells.example = self.devShell;

        # apps = { };

        # legacyPackages = { };

        # overlay = final: prev: { };
      });
}
