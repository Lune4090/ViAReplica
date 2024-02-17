let
 pkgs = import <nixpkgs> {};
in

with pkgs;

mkShell rec {
  nativeBuildInputs = [
    pkg-config
    julia
  ];
  buildInputs = [
    # rust
    cargo
    rust-analyzer
    udev alsa-lib vulkan-loader
    xorg.libX11 xorg.libXcursor xorg.libXi xorg.libXrandr # To use the x11 feature
    libxkbcommon wayland # To use the wayland feature

    # python
    gtk3 # may not be needed
    (python3.withPackages (ps: with ps; [
      numpy
      scipy
      matplotlib
      pandas
      gpaw
      ase

      pygobject3 # may not be needed
    ]))
    gcc
    blas
    libxc
    mpi
  ];
  LD_LIBRARY_PATH = lib.makeLibraryPath buildInputs;
  PROJECT_ROOT = builtins.toString ./.;

  shellHook = ''
    export GPAW_SETUP_PATH="$HOME/gpaw-data/gpaw-setups-0.9.20000:$PATH"
    export PATH="$PROJECT_ROOT/cmd:$PATH"
  '';
  
}
