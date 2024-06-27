{
  description = "Flake dependencies for NewMate, an automate re-implementation";

  inputs = {

    flakelight.url = "github:nix-community/flakelight";
    poetry2nix.url = "github:nix-community/poetry2nix";

  };

  outputs = { self, flakelight, poetry2nix, ... }:
    flakelight ./. ({ inputs, nixpkgs, ... }:
      let

        # myPythonApp = pkgs:
        #   pkgs.poetry2nix.mkPoetryApplication { projectDir = self; };
      in {

        # pkgs = pkgs: nixpkgs.legacyPackages.${pkgs.system};

        withOverlays = [ poetry2nix.overlays.default ];

        package = pkgs: pkgs.poetry2nix.mkPoetryApplication { projectDir = self; };


        devShell = pkgs: {
          stdenv = pkgs.llvmPackages_latest.stdenv;

          env = {
            CC = "clang";
            CXX = "clang++";
          };

          inputsFrom = [ self.package. ];

          packages = with pkgs; [

            poetry

            coreutils
            clang-tools_18
            cpplint
            cmake
            cppcheck
            doxygen
            gtest
            gdb
            commitizen

            include-what-you-use

          ];
        };
      });

}
