{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation rec {
  name = "vscode-js-debug-v1.88.0";

  src = pkgs.fetchFromGitHub {
    owner = "microsoft";
    repo = "vscode-js-debug";
    rev = "v1.88.0";
    sha256 = "sha256-gmeuRUcdz/4+FtPOblNj5DX3otXNRjHJjhPcCRuWXAY=";
  };

  buildInputs = [ pkgs.nodejs pkgs.curl ];

  buildPhase = ''
    # this line removes a bug where value of $HOME is set to a non-writable /homeless-shelter dir
    export HOME=$(pwd)
    curl https://registry.npmjs.org
    npm install --ignore-scripts --legacy-peer-deps --loglevel=verbose
    npm run compile --loglevel=verbose
    npm exec -- gulp vsDebugServerBundle --loglevel=verbose
    npm install --production --ignore-scripts --legacy-peer-deps --loglevel=verbose
  '';

  installPhase = ''
    mkdir -p $out/bin
  '';
}

