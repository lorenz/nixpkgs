{ lib
, fetchFromGitHub
, gcc
, gmp, mpfr, libmpc
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "kalker";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "PaddiM8";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-D7FlX72fcbeVtQ/OtK2Y3P1hZ5Bmowa04up5rTTXDDU=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "gmp-mpfr-sys-1.4.7" = "sha256-zHpGbEgh3MgAUVdlWrXq4Clj1boybi6DMOcsjgZbAh0=";
    };
  };

  buildInputs = [ gmp mpfr libmpc ];

  outputs = [ "out" "lib" ];

  postInstall = ''
    moveToOutput "lib" "$lib"
  '';

  CARGO_FEATURE_USE_SYSTEM_LIBS = "1";

  meta = with lib; {
    homepage = "https://kalker.strct.net";
    changelog = "https://github.com/PaddiM8/kalker/releases/tag/v${version}";
    description = "A command line calculator";
    longDescription = ''
      A command line calculator that supports math-like syntax with user-defined
      variables, functions, derivation, integration, and complex numbers
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
