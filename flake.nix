{
  description = "Template for a nix package";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        devShells.default = pkgs.mkShell {
          packages = [ ];
          buildInputs = [ self.packages."${system}".libpostalWithData pkgs.gcc pkgs.go ];
        };
        packages = {
          default = self.packages."${system}".libpostal;
          libpostal = pkgs.callPackage ./libpostal.nix { };
          libpostalWithData = self.packages."${system}".libpostal.override { withData = true; };
        };
      });
}
