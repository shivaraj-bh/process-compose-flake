{
  description = "A demo of sqlite-web";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    process-compose-flake.url = "github:Platonic-Systems/process-compose-flake";

    chinookDb.url = "github:lerocha/chinook-database";
    chinookDb.flake = false;
  };
  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      imports = [
        inputs.process-compose-flake.flakeModule
      ];
      perSystem = { self', pkgs, lib, ... }: {
        # This adds a `self.packages.default`
        process-compose."default" =
          let
            port = 8213;
            dataFile = "data.sqlite";
          in
          {
            postHook = ''
              echo "I am postHook"
            '';
            # httpServer.enable = true;
            settings = {
              environment = {
                SQLITE_WEB_PASSWORD = "demo";
              };

              processes = {
                # Print a pony every 2 seconds, because why not.
                ponysay = {
                  command = ''
                    ${lib.getExe pkgs.ponysay} "Enjoy our sqlite-web demo!"
                    exit 1
                  '';
                  availability.exit_on_end = true;
                };
              };
            };
          };
      };
    };
}
