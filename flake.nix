{
  description = "A very basic flake with a Docker image and dev shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-darwin"; # Adjust this if you're on a different platform, e.g., x86_64-darwin for macOS
    pkgs = import nixpkgs {
      inherit system;
    };
  in {
    dockerImages.hello = pkgs.dockerTools.buildImage {
      name = "hello";
      tag = "latest";
      copyToRoot = pkgs.buildEnv {
        name = "hello-env";
        paths = [pkgs.hello];
      };
      config.Cmd = ["${pkgs.hello}/bin/hello"];
    };

    devShells.${system}.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        alejandra
      ];
    };
  };
}
