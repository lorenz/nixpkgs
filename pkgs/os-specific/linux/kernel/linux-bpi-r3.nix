{ lib, buildPackages, fetchurl, perl, buildLinux, nixosTests, ... } @ args:

with lib;

buildLinux (args // rec {
  version = "6.2-rc7";
  extraMeta.branch = lib.versions.majorMinor version;

  # modDirVersion needs to be x.y.z, will always add .0
  modDirVersion = versions.pad 3 version;

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    hash = "sha256-6klAGw+J0usyY55dTMb/reUbAobJdheG/6YvNGz7SwM=";
  };

  kernelPatches = [ {
    name = "bpi-r3";
    patch = ./bpi-r3.patch;
  } ];

  structuredExtraConfig = with lib.kernel; {
    COMMON_CLK_MEDIATEK = yes;
    COMMON_CLK_MT7986 = yes;
    COMMON_CLK_MT7986_ETHSYS = yes;
    MEDIATEK_GE_PHY = yes;
    MEDIATEK_WATCHDOG = yes;
    MTD_NAND_ECC_MEDIATEK = yes;
    MTD_NAND_ECC_SW_HAMMING = yes;
    MTD_NAND_MTK = yes;
    MTD_SPI_NAND = yes;
    MTD_UBI = yes;
    MTD_UBI_BLOCK = yes;
    MTK_EFUSE = yes;
    MTK_HSDMA = yes;
    MTK_INFRACFG = yes;
    MTK_PMIC_WRAP = yes;
    MTK_SCPSYS = yes;
    MTK_SCPSYS_PM_DOMAINS = yes;
    MTK_THERMAL = yes;
    MTK_TIMER = yes;
    NET_DSA_MT7530 = module;
    NET_DSA_TAG_MTK = module;
    NET_MEDIATEK_SOC = module;
    NET_MEDIATEK_SOC_WED = yes;
    NET_MEDIATEK_STAR_EMAC = module;
    NET_SWITCHDEV = yes;
    NET_VENDOR_MEDIATEK = yes;
    PCIE_MEDIATEK = yes;
    PCIE_MEDIATEK_GEN3 = yes;
    PINCTRL_MT7986 = yes;
    PINCTRL_MTK = yes;
    PINCTRL_MTK_MOORE = yes;
    PINCTRL_MTK_V2 = yes;
    PWM_MEDIATEK = yes;
    MT7915E = module;
    MT7986_WMAC = yes;
    SPI_MT65XX = yes;
    SPI_MTK_NOR = yes;
    SPI_MTK_SNFI = yes;
    MMC_MTK = yes;
  };

} // (args.argsOverride or {}))
