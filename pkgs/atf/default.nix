{ arm-trusted-firmware
, bc
, ubootQemuAarch64
, rcw
, tianocore
, bootMode ? "sd"
, bl33 ? "${tianocore}/FV/LX2160ARDB_EFI.fd"
}:

(arm-trusted-firmware.buildArmTrustedFirmware {
  platform = "lx2160acex7";
  filesToInstall = [
    "build/lx2160acex7/release/*.bin"
    "build/lx2160acex7/release/*.pbl"
    "tools/fiptool/fiptool"
  ];
  extraMakeFlags = [
    "BL33=${bl33}"
    "RCW=${rcw}/lx2160acex7/RCW/template.bin"
    "TRUSTED_BOARD_BOOT=0"
    "GENERATE_COT=0"
    "BOOT_MODE=${bootMode}"
    "SECURE_BOOT=false"
    "all"
    "fip"
    "pbl"
  ];

  installPhase = ''
    mkdir -p $out/lx2160acex7
    cp -v --target-directory $out/lx2160acex7 \
      build/lx2160acex7/release/*.bin \
      build/lx2160acex7/release/*.pbl

    mkdir -p $out/bin
    cp -v tools/fiptool/fiptool $out/bin
  '';

  rk3399-m0-oc = null;

}).overrideAttrs (old: {
  nativeBuildInputs = old.nativeBuildInputs ++ [ bc ];
  patches = (old.patches or []) ++ [
    ./patches/0001-nxp-Allow-board-specific-platform-functions.patch
    ./patches/0002-nxp-Add-board-support-for-SolidRun-CEX7-modules.patch
    ./patches/0003-nxp-lx2160acex7-Add-custom-handlers-for-SolidRun-Har.patch
    ./patches/0004-nxp-ddr4-fix-spd_to_ps-calculation.patch
    ./patches/0005-nxp-ddr4-Add-support-for-XMP2-based-timing-profiles.patch
    ./patches/0006-nxp-lx2160acex7-Add-memory-settings-to-the-platform.patch

    ./patches/0009-nxp-ddr-disarm-error-when-using-non-identical-DIMMs.patch
  ];
})
