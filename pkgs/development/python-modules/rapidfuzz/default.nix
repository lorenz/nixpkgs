{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, cmake
, cython_3
, ninja
, scikit-build
, setuptools
, numpy
, hypothesis
, pandas
, pytestCheckHook
, rapidfuzz-cpp
, taskflow
}:

buildPythonPackage rec {
  pname = "rapidfuzz";
  version = "2.15.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "maxbachmann";
    repo = "RapidFuzz";
    rev = "refs/tags/v${version}";
    hash = "sha256-GUwWyOgC8C4GhTcZvd9ccJEsRTkaS0i6rRYU286E7GI=";
  };

  nativeBuildInputs = [
    cmake
    cython_3
    ninja
    scikit-build
    setuptools
  ];

  dontUseCmakeConfigure = true;

  buildInputs = [
    rapidfuzz-cpp
    taskflow
  ];

  preBuild = ''
    export RAPIDFUZZ_BUILD_EXTENSION=1
  '' + lib.optionalString (stdenv.isDarwin && stdenv.isx86_64) ''
    export CMAKE_ARGS="-DCMAKE_CXX_COMPILER_AR=$AR -DCMAKE_CXX_COMPILER_RANLIB=$RANLIB"
  '';

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals (stdenv.cc.isClang && stdenv.isDarwin) [
    "-fno-lto"  # work around https://github.com/NixOS/nixpkgs/issues/19098
  ]);

  propagatedBuildInputs = [
    numpy
  ];

  preCheck = ''
    export RAPIDFUZZ_IMPLEMENTATION=cpp
  '';

  nativeCheckInputs = [
    hypothesis
    pandas
    pytestCheckHook
  ];

  disabledTests = lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
    # segfaults
    "test_cdist"
  ];

  pythonImportsCheck = [
    "rapidfuzz.fuzz"
    "rapidfuzz.string_metric"
    "rapidfuzz.process"
    "rapidfuzz.utils"
  ];

  meta = with lib; {
    description = "Rapid fuzzy string matching";
    homepage = "https://github.com/maxbachmann/RapidFuzz";
    changelog = "https://github.com/maxbachmann/RapidFuzz/blob/${src.rev}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
