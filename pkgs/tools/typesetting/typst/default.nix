{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "typst";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "typst";
    repo = "typst";
    rev = "v${version}";
    hash = "sha256-3vNJmLmbskAzXVXjiSVDLhRcX1j3ksOgPd53W31YZ0c=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "iai-0.1.1" = "sha256-EdNzCPht5chg7uF9O8CtPWR/bzSYyfYIXNdLltqdlR0=";
    };
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  env = {
    GEN_ARTIFACTS = "artifacts";
  };

  postInstall = ''
    installManPage cli/artifacts/*.1
    installShellCompletion \
      cli/artifacts/typst.{bash,fish} \
      --zsh cli/artifacts/_typst
  '';

  meta = with lib; {
    description = "A new markup-based typesetting system that is powerful and easy to learn";
    homepage = "https://typst.app";
    changelog = "https://github.com/typst/typst/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ drupol figsoda kanashimia ];
  };
}
