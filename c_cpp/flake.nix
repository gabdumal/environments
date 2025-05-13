{
  description = "Development environment for C and C++";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f:
        nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = import nixpkgs {
              inherit system;
            };
          }
        );
    in
    {
      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default =
            with pkgs;
            mkShell {

              packages = with pkgs; [
                bashInteractive
                cmake
                doxygen
                llvmPackages.clang-tools
                llvmPackages.bintools
                llvmPackages.clang
                llvmPackages.libclc
                llvmPackages.libcxx
                llvmPackages.lldb
                llvmPackages.lldbPlugins.llef
                #   llvmPackages.lldb-manpages
                llvmPackages.llvm
                llvmPackages.mlir
                llvmPackages.openmp
                llvmPackages.stdenv
                ninja
                python3
                vcpkg
                vcpkg-tool
                vscode-extensions.vadimcn.vscode-lldb
              ];

            };
        }
      );
    };

}
