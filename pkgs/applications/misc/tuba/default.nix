{ lib
, stdenv
, fetchFromGitHub
, vala
, meson
, ninja
, python3
, pkg-config
, wrapGAppsHook4
, desktop-file-utils
, gtk4
, libadwaita
, json-glib
, glib
, glib-networking
, gtksourceview5
, libxml2
, libgee
, libsoup_3
, libsecret
, gst_all_1
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "tuba";
  version = "0.2.0";
  src = fetchFromGitHub {
    owner = "GeopJr";
    repo = "Tuba";
    rev = "v${version}";
    hash = "sha256-LPhGGIHvN/hc71PL50TBw1Q0ysubdtJaEiUEI29HRrE=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    python3
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    glib
    glib-networking
    gtksourceview5
    json-glib
    libxml2
    libgee
    libsoup_3
    gtk4
    libadwaita
    libsecret
  ] ++ (with gst_all_1; [
    gstreamer
    gst-libav
    gst-plugins-base
    (gst-plugins-good.override { gtkSupport = true; })
    gst-plugins-bad
  ]);

  passthru = {
    updateScript = nix-update-script {
      attrPath = "tuba";
    };
  };

  meta = with lib; {
    description = "Browse the Fediverse";
    homepage = "https://tuba.geopjr.dev/";
    mainProgram = "dev.geopjr.Tuba";
    license = licenses.gpl3Only;
    changelog = "https://github.com/GeopJr/Tuba/releases/tag/v${version}";
    maintainers = with maintainers; [ chuangzhu ];
  };
}
