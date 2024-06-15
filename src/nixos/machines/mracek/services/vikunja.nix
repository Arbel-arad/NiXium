{ self, config, lib, ... }:

# Mracek-specific configuration of Vikunja

# FIXME(Krey): Add Admin User

let
	inherit (lib) mkIf;
in mkIf config.services.vikunja.enable {
	# Import the private key for an onion service
	age.secrets.mracek-onion-vikunja-private = {
		file = ../secrets/mracek-onion-vikunja-private.age;

		owner = "tor";
		group = "tor";

		path = "/var/lib/tor/onion/vikunja/hs_ed25519_secret_key";

		symlink = false; # Appears to not work as symlink
	};

	# Deploy The Onion Service
	services.tor.relay.onionServices."vikunja" = {
		map = mkIf config.services.tor.enable [{
			target = { port = config.services.vikunja.settings.server.HTTP_PORT or 80; };
			port = 80;
		}];
	};
}
