{ tianocore, ddr-phy-bin, atf, runCommand, target ? "sd" }:
let
  atf-with-tianocore = atf.override {
    bl33 = "${tianocore}/FV/LX2160ARDB_EFI.fd";
  };
in
runCommand "lx2k-firmware-${target}.bin" { } ''
  truncate -s 8M $out
  dd of=$out bs=512 if=${atf-with-tianocore}/lx2160acex7/bl2_sd.pbl seek=8 conv=notrunc
  dd of=$out bs=512 if=${ddr-phy-bin}/fip_ddr_all.bin seek=256 conv=notrunc
  dd of=$out bs=512 if=${atf-with-tianocore}/lx2160acex7/fip.bin seek=2048 conv=notrunc
''
