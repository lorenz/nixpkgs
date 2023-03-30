{ lib, buildGoModule, fetchFromGitHub, go-bindata, ipxe }:

buildGoModule rec {
  pname = "pixiecore";
  version = "2023-02-25";
  rev = "fc2840fa7b05c2f2447452e0dcc35a5a76f6acfa";

  src = fetchFromGitHub {
    owner = "danderson";
    repo = "netboot";
    inherit rev;
    hash = "sha256-TV0GJqhg/KEmbJzbaHD/WkSLeOx3GoVEidPrepN0P4Q=";
  };

  vendorHash = "sha256-hytMhf7fz4XiRJH7MnGLmNH+iIzPDz9/rRJBPp2pwyI=";
  patches = [ ./fix-chainloading.patch ];

  nativeBuildInputs = [ go-bindata ];
  buildInputs = [ ipxe ];
  postPatch = ''
    mkdir -p third_party/ipxe/src/bin third_party/ipxe/src/bin-x86_64-efi third_party/ipxe/src/bin-i386-efi
    cp ${ipxe}/undionly.kpxe third_party/ipxe/src/bin
    cp ${ipxe}/ipxe.efi third_party/ipxe/src/bin-x86_64-efi/ipxe.efi
    touch third_party/ipxe/src/bin/ipxe.pxe
    touch third_party/ipxe/src/bin-i386-efi/ipxe.efi
    go-bindata -o out/ipxe/bindata.go -pkg ipxe -nometadata -nomemcopy \
    	third_party/ipxe/src/bin/ipxe.pxe \
	third_party/ipxe/src/bin/undionly.kpxe \
	third_party/ipxe/src/bin-x86_64-efi/ipxe.efi \
	third_party/ipxe/src/bin-i386-efi/ipxe.efi
  '';

  doCheck = false;

  subPackages = [ "cmd/pixiecore" ];

  meta = {
    description = "A tool to manage network booting of machines";
    homepage = "https://github.com/danderson/netboot/tree/master/pixiecore";
    license =  lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bbigras danderson ];
    platforms = lib.platforms.unix;
  };
}
