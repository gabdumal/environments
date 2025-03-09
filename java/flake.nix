{

  description = "Development environment for Java";

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
        javaVersion = 23;
        jdk = pkgs."temurin-bin-${toString javaVersion}";

        pkgs = import nixpkgs {
          inherit system;

          overlays = [
            (self: super: {
              gradle = super.gradle.override {
                java = jdk;
              };

              lombok = super.lombok.override {
                jdk = jdk;
              };
            })
          ];

        };

      in
      {
        devShells.default =
          with pkgs;
          mkShell {

            packages = with pkgs; [
              jdk
              maven
              gradle
              lombok
            ];

            env = {
              JAVA_HOME = jdk;
            };

            shellHook =
              let
                loadLombok = "-javaagent:${pkgs.lombok}/share/java/lombok.jar";
                prev = "\${JAVA_TOOL_OPTIONS:+ $JAVA_TOOL_OPTIONS}";
              in
              ''
                export JAVA_TOOL_OPTIONS="${loadLombok}${prev}"
              '';

          };
      }
    );

}
