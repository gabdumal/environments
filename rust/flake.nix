{

  description = "Development environment for Rust";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      rust-overlay,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      {
        devShells.default =
          with pkgs;
          mkShell {
            nativeBuildInputs = with pkgs; [
              cargo
              cargo-tauri
              gobject-introspection
              nodejs
              pkg-config
            ];

            buildInputs = with pkgs; [
              (rust-bin.fromRustupToolchainFile ./rust-toolchain.toml)
              at-spi2-atk
              atkmm
              cairo
              gdk-pixbuf
              glib
              gtk3
              harfbuzz
              librsvg
              libsoup_3
              openssl
              pango
              webkitgtk_4_1
            ];

            packages = with pkgs; [
              tailwindcss
            ];

            shellHook = ''
              ## Aliases
              alias ls=eza
              alias find=fd

              ## Cargo path
              export PATH="$PATH:$HOME/.cargo/bin"
            '';
          };
      }
    );

}
