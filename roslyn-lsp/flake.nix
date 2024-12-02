{
  description = "Roslyn Language Server Flake for x86_64-linux";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      version = "4.13.0-3.24574.9";
    in {
      packages."x86_64-linux".roslynLanguageServer = pkgs.stdenvNoCC.mkDerivation {
        pname = "microsoft.codeanalysis.languageserver";
        inherit version;

        src = pkgs.fetchzip {
          url = "https://github.com/Crashdummyy/roslynLanguageServer/releases/download/4.13.0-3.24574.9/microsoft.codeanalysis.languageserver.linux-x64.zip";
          sha256 = "sha256-2rCMejGADhPfXJr39o/xRrreGo7Scq71TsLgFf/mhzY=";
          stripRoot = false;
        };

        nativeBuildInputs = [ pkgs.makeWrapper pkgs.dotnetCorePackages.runtime_8_0 ];

        installPhase = ''
          mkdir -p $out/lib
          cp -r * $out/lib/

          # Create wrapper script
          mkdir -p $out/bin
          makeWrapper ${pkgs.dotnetCorePackages.runtime_8_0}/bin/dotnet $out/bin/roslyn-language-server \
            --add-flags "$out/lib/Microsoft.CodeAnalysis.LanguageServer.dll"
        '';

        meta = with pkgs.lib; {
          description = "Roslyn Language Server for .NET";
          homepage = "https://github.com/Crashdummyy/roslynLanguageServer";
          platforms = [ "x86_64-linux" ];
        };
      };

      # Set default package
      packages."x86_64-linux".default = self.packages."x86_64-linux".roslynLanguageServer;
    };
}
