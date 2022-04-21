{ bctoolbox
, bzrtp
, cmake
, fetchFromGitLab
, ffmpeg
, glew
, gsm
, lib
, libX11
, libXext
, libopus
, libpulseaudio
, libv4l
, libvpx
, ortp
, python3
, qtbase
, qtdeclarative
, speex
, srtp
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "mediastreamer2";
  version = "5.1.20";

  dontWrapQtApps = true;

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
    sha256 = "sha256-u8YqF5BzyYIF9+XB90Eu6DlwXuu1FDOJUzxebj0errU=";
  };

  patches = [
    # Plugins directory is normally fixed during compile time. This patch makes
    # it possible to set the plugins directory run time with an environment
    # variable MEDIASTREAMER_PLUGINS_DIR. This makes it possible to construct a
    # plugin directory with desired plugins and wrap executables so that the
    # environment variable points to that directory.
    ./plugins_dir.patch
  ];

  nativeBuildInputs = [
    cmake
    python3
    qtbase
    qtdeclarative
  ];

  propagatedBuildInputs = [
    # Made by BC
    bctoolbox
    bzrtp
    ortp

    ffmpeg
    glew
    libX11
    libXext
    libpulseaudio
    libv4l
    speex
    srtp

    # Optional
    gsm  # GSM audio codec
    libopus  # Opus audio codec
    libvpx  # VP8 video codec
  ];

  strictDeps = true;

  cmakeFlags = [
    "-DENABLE_STATIC=NO" # Do not build static libraries
    "-DENABLE_QT_GL=ON" # Build necessary MSQOGL plugin for Linphone desktop
  ];

  NIX_CFLAGS_COMPILE = [
    "-DGIT_VERSION=\"v${version}\""
    "-Wno-error=deprecated-declarations"
    "-Wno-error=cast-function-type"
    "-Wno-error=stringop-truncation"
    "-Wno-error=stringop-overflow"
  ] ++ lib.optionals (stdenv.cc.isGNU && lib.versionAtLeast stdenv.cc.version "11") [
    "-Wno-error=stringop-overread"
  ];
  NIX_LDFLAGS = "-lXext";

  meta = with lib; {
    description = "A powerful and lightweight streaming engine specialized for voice/video telephony applications. Part of the Linphone project";
    homepage = "http://www.linphone.org/technical-corner/mediastreamer2";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jluttine ];
  };
}
