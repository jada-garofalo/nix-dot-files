{ config, pkgs, ... }:

{

	home.username = "jada";
	home.homeDirectory = "/home/jada";
	home.stateVersion = "26.05";

	programs.bash = {
		enable = true;
		shellAliases = {
			nrs = "sudo nixos-rebuild switch";
		};
	
		initExtra = ''
			export PS1='\[\e[38;5;203m\]\u\[\e[0m\] in \[\e[38;5;206m\]\w\[\e[0m\] \$ '
		'';
	};

	home.file.".config/alacritty".source = /home/jada/home-manager-dotfiles/alacritty;
	home.file.".config/bat".source = /home/jada/home-manager-dotfiles/bat;
	home.file.".config/qtile".source = /home/jada/home-manager-dotfiles/qtile;
	home.file.".config/fastfetch".source = /home/jada/home-manager-dotfiles/fastfetch;

	home.packages = with pkgs; [
		bat
	];

}

