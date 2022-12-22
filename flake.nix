# Based on https://ertt.ca/nix/shell-scripts/

{
  description = "Sync git repos; adding all changes and pushing to upstream";

  outputs = { self, nixpkgs }:
    let
      name = "bn-git-sync";
      system = "aarch64-darwin";
      pkgs = import nixpkgs { inherit system; };
      run-sync = (pkgs.writeScriptBin name (builtins.readFile ./run-sync.sh))
        .overrideAttrs(old: {
          buildCommand = "${old.buildCommand}\n patchShebangs $out";
        });
    in rec {
      packages.${system} = rec {
        default = bn-git-sync;

        bn-git-sync = pkgs.symlinkJoin {
          name = name;
          paths = [ run-sync ] ++ [ pkgs.git ];
          buildInputs = [ pkgs.makeWrapper ];
          postBuild = "wrapProgram $out/bin/${name} --prefix PATH : $out/bin";
        };
      };

      overlays.default = final: prev: {
        bn-git-sync = { bn-git-sync = packages.${system}.default; };
      };
    };
}
