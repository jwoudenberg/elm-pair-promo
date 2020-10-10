{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  name = "editor-driver-shell";
  buildInputs = with pkgs; [ caddy2 asciinema gnused ];
}
