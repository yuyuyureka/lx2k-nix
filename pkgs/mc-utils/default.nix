{ stdenv, lib, fetchFromGitHub, dtc }:

stdenv.mkDerivation rec {
  pname = "mc-utils";
  version = "LSDK-19.09";

  src = fetchFromGitHub {
    owner = "nxp-qoriq";
    repo = "mc-utils";
    rev = version;
    hash = "sha256-1jxNbTy2Cv3STI7wHrhfPkAeZLMvBxwEHEM0iL9lknY=";
  };

  patches = [
    ./patches/0001-lx2160acex7-add-8x10G-dual-40G-and-dual-100G-DPL-DPC.patch
  ];

  nativeBuildInputs = [ dtc ];

  preBuild = ''
    cd config
  '';

  installPhase = ''
    mkdir -p $out/config/lx2160a/CEX7
    cp -v \
      --target-directory $out/config/lx2160a/CEX7 \
      lx2160a/CEX7/*.dtb
  '';
}
