# Based on https://ertt.ca/nix/shell-scripts/

{
  description = "Sync git repos; adding all changes and pushing to upstream";

  inputs = {
    flake-utils.url = github:numtide/flake-utils;
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        name = "bn-git-sync";
        run-sync = (pkgs.writeScriptBin name (builtins.readFile ./run-sync.sh))
          .overrideAttrs(old: {
            buildCommand = "${old.buildCommand}\n patchShebangs $out";
          });
      in rec {
        defaultPackage = packages.bn-git-sync;

        packages.bn-git-sync = pkgs.symlinkJoin {
          name = name;
          paths = [ run-sync ] ++ [ pkgs.git ];
          buildInputs = [ pkgs.makeWrapper ];
          postBuild = "wrapProgram $out/bin/${name} --prefix PATH : $out/bin";
        };
      });
}
