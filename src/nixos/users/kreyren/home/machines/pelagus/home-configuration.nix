{ config, pkgs, lib, unstable, aagl, ... }:

let
	inherit (lib) mkIf;
in {
	home.stateVersion = "24.05";

	gtk.enable = true;

	home.impermanence.enable = true;

	programs.alacritty.enable = true; # Rust-based Hardware-accelarated terminal
	programs.kitty.enable = true; # Alternative Rust-based Hardware-accelarated terminal for testing, potentially superrior to alacritty

	programs.bash.enable = true;
	programs.starship.enable = true;
	programs.direnv.enable = true; # To manage git repositories
	programs.git.enable = true; # Generic use only
	programs.gpg.enable = true;
	programs.vim.enable = true;
	programs.vscode.enable = true; # Generic use only
	programs.firefox.enable = true;

	# FIXME(Krey): This should be part of the GPG module
	services.gpg-agent.enable = (mkIf config.programs.gpg.enable true);

  # FIXME(Krey): Broken on impermanent setup after 'switch'
  # services.flameshot.enable = true;

	nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
		"vscode" # FIXNE(Krey): Uses vscodium, no idea why is this required. Likely a nixpkgs bug

		# FIXME(Krey): It's ET: Legacy, what's proprietary there?
		"etlegacy"
		"etlegacy-assets"
	];

	home.packages = [
		pkgs.keepassxc
		pkgs.cura
		pkgs.prusa-slicer
		unstable.fractal
		# SECURITY(Krey): Paranoid over-reaction to a likely undisclosed vulnerability in Rust SDK Crypto
		pkgs.element-desktop
		pkgs.qbittorrent
		unstable.stremio
		pkgs.yt-dlp
		pkgs.youtube-dl
		pkgs.android-tools
		pkgs.picocom
		pkgs.bottles
		pkgs.kicad
		pkgs.mtr
		pkgs.vlc
		# nix-software-center.nix-software-center
		# pkgs.colobot
		pkgs.nix-index
		pkgs.tealdeer
		# pkgs.ventoy-full
		pkgs.chromium

		unstable.feishin

		pkgs.libreoffice

		# NOTE(Krey): Temporary management for https://github.com/NixOS/nixpkgs/issues/35464#issuecomment-2134233517
		# pkgs.pinentry-gnome3
		pkgs.pinentry-curses

		(pkgs.brave.override {
			# NOTE(Krey): Using system-wide tor which is interfiering with the brave's browsing as non-tor browsing has tor and tor browser goes through 2 Tors so this fixes it
			commandLineArgs = "--no-proxy-server";
		})

		pkgs.sc-controller
		pkgs.freetube
		pkgs.hexchat
		unstable.monero-gui
		pkgs.nextcloud-client
		pkgs.endeavour
		pkgs.dialect
		pkgs.freecad
		pkgs.airshipper
		pkgs.helvum
		pkgs.etlegacy
		pkgs.mindustry

		# pkgs.gaphor
		pkgs.tor-browser-bundle-bin
		pkgs.gimp # Generic use only
		pkgs.kooha

		# Gnome extensions
		pkgs.gnomeExtensions.removable-drive-menu
		pkgs.gnomeExtensions.vitals
		pkgs.gnomeExtensions.blur-my-shell
		pkgs.gnomeExtensions.gsconnect
		pkgs.gnomeExtensions.custom-accent-colors
		pkgs.gnomeExtensions.desktop-cube
		pkgs.gnomeExtensions.burn-my-windows
		pkgs.gnomeExtensions.caffeine
		pkgs.gnomeExtensions.shortcuts

		# An Anime Game
		aagl.anime-game-launcher

		#nerdfonts
		# NOTE(Krey): This was recommended, because nerdfonts might have issues with rendering -- https://github.com/TanvirOnGH/nix-config/blob/nix%2Bhome-manager/desktop/customization/font.nix#L4-L39
		(pkgs.nerdfonts.override {
			fonts = [
				"Noto"
				"FiraCode"
			];
		})
	];

	# Persist anime game files
	# FIXME(Krey): Fails to start due to being symlink or the default binfs
	# home.persistence."/nix/persist/users/kreyren".directories = [{
	# 	directory = ".local/share/anime-game-launcher";
	# 	method = "symlink";
	# }];

	# GNOME Extensions
	dconf.settings = {
		# Set power management for a scenario where user is logged-in
		"org/gnome/settings-daemon/plugins/power" = {
			power-button-action = "hibernate";
			sleep-inactive-ac-timeout = 1800; # 60*30=1800 Seconds -> 30 Minutes
			sleep-inactive-ac-type = "suspend";
		};

		"org/gnome/shell" = {
			disable-user-extensions = false;

			# The extension names can be found through `$ gnome-extensions list`
			enabled-extensions = [
				"Vitals@CoreCoding.com"
				"drive-menu@gnome-shell-extensions.gcampax.github.com"
				"blur-my-shell@aunetx"
				"user-theme@gnome-shell-extensions.gcampax.github.com"
				"gsconnect@andyholmes.github.io"
				"custom-accent-colors@demiskp"
				"desktop-cube@schneegans.github.com"
				"caffeine@patapon.info"
			];

			disabled-extensions = [];
		};
	};
}
