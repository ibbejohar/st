{
  description = "Fools ST build";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system}.st = pkgs.stdenv.mkDerivation {
      pname = "st";
      version = "kitty-graphics";
      src = ./.;

      nativeBuildInputs = with pkgs; [
        pkg-config
        gcc
      ];

      buildInputs = with pkgs; [
        freetype
        fontconfig
        xorg.libX11
        xorg.libXft
        xorg.libXinerama
        xorg.libXrender
        ncurses
        imlib2
        zlib
        harfbuzz
      ];

      buildPhase = ''
      make CC=${pkgs.stdenv.cc.targetPrefix}cc \
      PKG_CONFIG=${pkgs.pkg-config}/bin/pkg-config
      '';

      installPhase = ''
      export TERMINFO=$out/share/terminfo
      make PREFIX=$out install
      '';
    };
  };
}
