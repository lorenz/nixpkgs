{ lib, buildPythonPackage, fetchFromGitHub, fetchpatch, poetry-core, pythonOlder
, click, backports-cached-property, graphql-core, pygments, python-dateutil, python-multipart, typing-extensions
, aiohttp, asgiref, chalice, django, fastapi, flask, pydantic, sanic, starlette, uvicorn
}:

buildPythonPackage rec {
  pname = "strawberry-graphql";
  version = "0.159.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "strawberry-graphql";
    repo = "strawberry";
    rev = "refs/tags/${version}";
    hash = "sha256-3fyls1W2Vx0nDtp7mta/8QeKM6RRsAbw3dWOnH1/jk0=";
  };

  patches = [
    (fetchpatch {
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/strawberry-graphql/strawberry/commit/710bb96f47c244e78fc54c921802bcdb48f5f421.patch";
      hash = "sha256-ekUZ2hDPCqwXp9n0YjBikwSkhCmVKUzQk7LrPECcD7Y=";
    })
  ];

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    click backports-cached-property graphql-core pygments python-dateutil python-multipart typing-extensions
    aiohttp asgiref chalice django fastapi flask pydantic sanic starlette uvicorn
  ];

  pythonImportsCheck = [
    "strawberry"
  ];

  meta = with lib; {
    description = "A GraphQL library for Python that leverages type annotations";
    homepage = "https://strawberry.rocks";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ izorkin ];
  };
}
