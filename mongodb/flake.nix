{

  description = "Environment for MongoDB";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";

  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };
      in
      {
        devShells.default =
          with pkgs;
          mkShell {

            packages = with pkgs; [
              mongodb-compass # MongoDB GUI
              mongosh # MongoDB Shell
              mongodb-tools # MongoDB Tools
            ];

          };
      }
    );

}
