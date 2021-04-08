{pkgs ? import <nixpkgs> {
    inherit system;
}, system ? builtins.currentSystem, nodejs ? pkgs."nodejs-12_x", stdenv ? pkgs.stdenv, nodePackages ? pkgs.nodePackages, symlinkJoin ? pkgs.symlinkJoin, lib ? pkgs.lib }:

let
  nodeDependencies = (pkgs.callPackage ./default.nix {}).shell.nodeDependencies;
in

stdenv.mkDerivation {
  name = "my-webpack-app";
  src = ./.;
  buildInputs = [ nodejs ];
  buildPhase = ''
    ln -s ${nodeDependencies}/lib/node_modules ./node_modules

    export PATH="${nodeDependencies}/bin:$PATH"

    # Build the distribution bundle in "dist"
    NODE_ENV=production webpack
  '';
  installPhase = ''
    cp -r dist $out/
  '';
}
