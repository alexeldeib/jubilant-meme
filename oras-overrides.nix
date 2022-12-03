{ pkgs, ...}: pkgs.callPackage "${pkgs.path}/pkgs/development/tools/oras" {
    buildGoModule = args: pkgs.buildGoModule (args // rec {
      # bumped artifact specs which ace wants
      version = "0.16.0";
      src = pkgs.fetchFromGitHub rec {
        owner = "oras-project";
        repo = "oras";
        rev = "v${version}";
        sha256 = "sha256-7fmrWkJ2f9LPaBB0vqLqPCCLpkdsS1gVfJ1xn6K/M3E=";
      };
      vendorSha256 = "sha256-BLjGu1xk5OCNILc2es5Q0fEIqoexq/lHnJtHz72w6iI=";
      # upstream added a go.mod in test/e2e, doesn't play nicely with nix.
      excludedPackages = [
        "test/e2e"
      ];
      # reset version in installCheckPhase to overriden version
      installCheckPhase = ''
        runHook preInstallCheck
        $out/bin/oras --help
        $out/bin/oras version | grep "${version}"
        runHook postInstallCheck
      '';
    });
}