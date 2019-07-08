{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "editor-driver-shell";
  buildInputs = with pkgs; [ asciinema elmPackages.elm elmPackages.elm-format gnused ];
}
