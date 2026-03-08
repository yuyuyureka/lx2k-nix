{ lib, stdenv, fetchFromGitHub, edk2, util-linux, nasm, acpica-tools, dtc, qoriq-mc-bin }:
let
  edk2-platforms = stdenv.mkDerivation {
    name = "edk2-platforms";
    src = fetchFromGitHub {
      owner = "tianocore";
      repo = "edk2-platforms";
      rev = "1c4580c402b0d9f3ba426a300b5f50c5a4affd10";
      hash = "sha256-GE22OUbKrPWN6ENqNo1w6jK0GFbgPx+dJu2tgCA/ZRg=";
    };
    patches = [
      # https://github.com/tianocore/edk2-platforms/pull/239
      ./0001-Platform-NXP-Add-Arch-Common-objects-handler.patch
      ./0002-Platform-NXP-Move-Power-Mgmt-Profile-info-to-Arch-Co.patch
      ./0003-Platform-NXP-Move-Serial-Port-info-to-Arch-Common.patch
      ./0004-Platform-NXP-Move-Pci-Config-Space-info-to-Arch-Comm.patch
      ./0005-Platform-NXP-Update-DynamicTablesPkg-generator-paths.patch

      ./nvme.patch
    ];
    buildPhase = "true";
    installPhase = ''
      mkdir -p $out
      cp -r * $out/
    '';
    dontFixup = true;
  };
in
edk2.mkDerivation "${edk2-platforms}/Platform/NXP/LX2160aRdbPkg/LX2160aRdbPkg.dsc" {
  name = "tianocore-honeycomb-lx2k";
  nativeBuildInputs = [ util-linux nasm acpica-tools dtc ];
  hardeningDisable = [ "format" "stackprotector" "pic" "fortify" ];
  preBuild = ''
    export PACKAGES_PATH=${edk2}:${edk2-platforms}
  '';
}
