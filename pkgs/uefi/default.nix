{ tianocore, ddr-phy-bin, atf, runCommand, qoriq-mc-bin, mc-utils, target ? "sd" }:
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
  #dd of=$out bs=512 if=${qoriq-mc-bin}/lx216xa/mc_lx2160a_10.40.0.itb seek=20480 conv=notrunc
  #dd of=$out bs=512 if=${mc-utils}/config/lx2160a/CEX7/dpl-eth.8x10g.19.dtb seek=26624 conv=notrunc
  #dd of=$out bs=512 if=${mc-utils}/config/lx2160a/CEX7/dpc-8_x_usxgmii.dtb seek=28672 conv=notrunc
