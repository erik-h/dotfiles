{ config, pkgs, claude-code, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  programs.discord.enable = true;

  programs.fish = {
  	enable = true;
	functions = {
		fish_greeting = "";
		ndiff = {
		    description = "Diff two recent system generations with nvd, annotated with git state";
		    body = ''
		      set -l offset 0
		      if test (count $argv) -ge 1
			  set offset $argv[1]
		      end

		      set -l take (math "2 + $offset")
		      set -l dir $HOME/.local/state/darwin-gens

		      set -l pair (
			  for p in /nix/var/nix/profiles/system-*-link
			      set -l num (string match -rg 'system-(\d+)-link$' (path basename $p))
			      echo $num $p
			  end | sort -n | tail -n $take | head -n 2 | awk '{print $2}'
		      )

		      if test (count $pair) -lt 2
			  echo "ndiff: not enough generations for offset $offset." >&2
			  return 1
		      end

		      for path in $pair
			  set -l gen (string match -rg 'system-(\d+)-link$' (path basename $path))
			  set -l when (date -r (stat -f %m $path) "+%Y-%m-%d %H:%M:%S")
			  echo "=== $path"
			  echo "    switched: $when"

			  set -l rec (awk -F'\t' -v g=$gen '$1==g {print; exit}' $dir/log.tsv 2>/dev/null)
			  if test -n "$rec"
			      set -l fields (string split \t -- $rec)
			      set -l sha $fields[2]
			      set -l tag $fields[3]
			      set -l subject $fields[4]
			      set -l short (string sub -l 7 -- $sha)
			      echo "    commit:   $short $subject [$tag]"
			      if test "$tag" = dirty -a -f $dir/$gen.patch
				  echo "    patch:    $dir/$gen.patch"
				  cat $dir/$gen.patch
			      end
			  else
			      echo "    commit:   (no record)"
			  end
		      end
		      echo

		      nvd diff $pair
		    '';
		};
		nrs = {
		    description = "darwin-rebuild switch, recording git SHA and dirty patch per generation";
		    body = ''
		      set -l dir $HOME/.local/state/darwin-gens
		      mkdir -p $dir

		      set -l sha (git -C $FLAKE_DIR rev-parse HEAD 2>/dev/null)
		      set -l subject ""
		      set -l tag unknown
		      if test -n "$sha"
			  set subject (git -C $FLAKE_DIR log -1 --format='%s' HEAD 2>/dev/null)
			  set tag clean
			  if not git -C $FLAKE_DIR diff --quiet HEAD -- 2>/dev/null
			      set tag dirty
			  end
		      else
			  set sha unknown
		      end

		      sudo darwin-rebuild switch --flake $FLAKE_DIR $argv
		      set -l rc $status
		      if test $rc -ne 0
			  return $rc
		      end

		      set -l gen (readlink /nix/var/nix/profiles/system | string match -rg 'system-(\d+)-link$')

		      if test "$tag" = dirty
			  git -C $FLAKE_DIR -c diff.external="difft --color=always" diff HEAD -- > $dir/$gen.patch
			  echo "nrs: dirty patch saved to $dir/$gen.patch"
		      end
		      printf '%s\t%s\t%s\t%s\n' $gen $sha $tag $subject >> $dir/log.tsv
		      echo "nrs: recorded gen $gen @ "(string sub -l 7 -- $sha)" [$tag]"
		    '';
		};
	};
	interactiveShellInit = ''
	    set -gx EDITOR nvim
	    set -gx FLAKE_DIR ~/.config/nix/macbook-air
	'';
  	shellAliases = {
		ll = "ls -l";
		la = "ls -a";
		l = "ls";

		gst = "git status";
		gc = "git commit";
		gco = "git checkout";
		gs = "git switch";
		gp = "git push";
		gl = "git pull";
		ga = "git add";
		glog = "git log";
		gr = "git rebase";

  		sudo = "sudo ";
  		vim = "nvim";
  	};
  };

  programs.git = {
	  enable = true;

	  signing = {
		  key = "2C5A386B8090ADD77D65494CAD5946D4C7ECFF90";
		  signByDefault = false; # set to true if you want auto-signing
	  };

	  settings = {
		  user.name = "Erik Haugrud";
		  user.email = "public+git@erikh.me";

		  alias = {
			  d = "diff";
			  dt = "difftool";
			  fixup = "!f() { TARGET=$(git rev-parse \"$1\"); git commit --fixup=$TARGET \${@:2} && EDITOR=true git rebase -i --autostash --autosquash $TARGET^; }; f";
			  gone = "!f() { git branch -vv | awk '{print $1,$4}' | grep 'gone]' | grep -v '\\\\*' | awk '{print $1}'; }; f";
			  parent = "!git show-branch | grep '*' | grep -v \"$(git rev-parse --abbrev-ref HEAD)\" | head -n1 | sed 's/.*\\\\[\\\\([^\\\\^~]*\\\\).*\\\\].*/\\\\1/' #";
			  quote-string = "!read -r l; printf \\\\\"!; printf %s \"$l\" | sed 's/\\\\([\\\\\\\\\\\"]\\\\)/\\\\\\\\\\\\1/g'; printf \" #\\\\\"\\n\" #";
			  quote-string-undo = "!read -r l; printf %s \"$l\" | sed 's/\\\\\\\\\\\\([\\\\\\\\\\\"]\\\\)/\\\\1/g'; printf \"\\n\" #";
			  today = "log --since=midnight";
			  sync = "!git pull && git push";
			  luniq = "!git log \${1:-origin/main}..HEAD";
		  };

		  init.defaultBranch = "main";
		  credential.helper = "cache --timeout=7200";
		  push.default = "simple";
		  core = {
			  editor = "nvim";
			  attributesfile = "~/.gitattributes";
			  autocrlf = false;
			  filemode = false;
		  };
		  pull = {
			  ff = true;
			  rebase = false;
		  };
		  rebase = {
			  autosquash = true;
			  updateRefs = true;
		  };
		  tag.sort = "-version:refname";
	  };

	  includes = [
	  {
		  condition = "gitdir:~/dev/work/**";
		  path = "~/.config/git/work.config";
	  }
	  {
		  path = "~/.config/git/local.config";
	  }
	  ];
  };

  programs.difftastic = {
	  enable = true;
	  git.enable = true;
  };


  programs.ghostty = {
  	enable = true;
	package = pkgs.ghostty-bin;
	settings = {
		command = "${pkgs.fish}/bin/fish -l -c ${pkgs.tmux}/bin/tmux";
	};
  };

  # TODO: set more stuff using the settings object instead of extraConfig
  programs.tmux = {
  	enable = true;
	terminal = "tmux-256color";
	shell = "${pkgs.fish}/bin/fish";
	escapeTime = 0;
	baseIndex = 1;
	keyMode = "vi";
	mouse = true;
	extraConfig = ''
		# Status bar colors
		set-option -g history-limit 700000
		set-option -g renumber-windows on
		set -g status-justify centre

		# Start window and pane index at 1, not 0
		set -g base-index 1
		set -g pane-base-index 1

		unbind C-b
		set -g prefix C-Space
		bind Space send-prefix

		# Send the prefix to client inside window
		bind-key -n C-t send-prefix

		# Clipboard
		# bind -t vi-copy y copy-pipe 'xclip -in -selection clipboard'
		#
		# The change in syntax here is documented in a comment by alaska here:
		# https://github.com/tmux/tmux/issues/754
		bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'

		# resize the viewport only if an active session is the smallets
		setw -g aggressive-resize on

		setw -g automatic-rename on

		# window titles
		set -g set-titles on

		# key bindings
		bind R source-file ~/.tmux.conf

		# Kill current session and switch to the previous session
		# source: http://unix.stackexchange.com/a/58616
		bind-key X confirm-before -p "Kill #S (y/n)?" "run-shell 'tmux switch-client -n \\\; kill-session -t \"\$(tmux display-message -p \"#S\")\"'"

		# pane navigation
		bind h select-pane -L
		bind j select-pane -D
		bind k select-pane -U
		bind l select-pane -R

		# swap panes
		bind-key -r J swap-pane -D
		bind-key -r K swap-pane -U
		bind-key b break-pane

		# clear pane content and history
		# bind -n C-k send-keys -R \; clear-history
		# Source is the comment by ivan on Dec 10 2017: https://stackoverflow.com/a/11525159
		bind C-k send-keys -R C-l \; clear-history

		# move windows left/right
		bind-key -n C-S-Left swap-window -t -1
		bind-key -n C-S-Right swap-window -t +1

		# new window
		bind-key C-c new-window
		bind-key c new-window

		bind-key p previous-window

		# Split windows like in my vim setup
		bind-key - split-window -v -c "#{pane_current_path}"
		bind-key _ split-window -v -c "#{pane_current_path}"
		bind-key | split-window -h -c "#{pane_current_path}"

		# resize panes like vim
		bind-key -r < resize-pane -L 5
		bind-key -r > resize-pane -R 5
		bind-key -r + resize-pane -U 10
		bind-key -r = resize-pane -D 10

		# mouse
		set-window-option -g mouse on
		set -g mouse on

		# Statusbar settings

		# use vi-style key bindings in the status line
		set -g status-keys vi

		# amount of time for which status line messages and other indicators
		# are displayed. time is in milliseconds.
		set -g display-time 250

		# notify about activities
		setw -g monitor-activity on
		set -g visual-activity on

		# status bar configuration

		# TODO: use run-shell to run a script that only add "#H:" to the status bar if
		# the tmux session is not nested (by checking if TMUX is set).
		# A good example using no external scripts is: https://stackoverflow.com/a/40902312
		set-option -g status-left ' #(whoami)   #H'
		set-option -g status-right '%h %d %Y - %l:%M %p'

		# set-option -g status-right-length 1000
		set-option -g status-left-length 60

		#### COLOUR (Solarized 256)

		# default statusbar colors
		set-option -g status-style bg=colour235,fg=yellow,dim,bg=colour235,fg=colour136,default

		# default window title colors
		set-window-option -g window-status-style fg=colour244,bg=default
		#set-window-option -g window-status-attr dim

		# active window title colors
		set-window-option -g window-status-current-style fg=colour166,bg=default
		#set-window-option -g window-status-current-attr bright

		# pane border
		set-option -g pane-border-style fg=colour235
		set-option -g pane-active-border-style fg=colour240

		# message text
		set-option -g message-style bg=colour235,fg=colour166

		# pane number display
		set-option -g display-panes-active-colour colour33 #blue
		set-option -g display-panes-colour colour166 #orange

		# clock
		set-window-option -g clock-mode-colour colour64 #green
	'';
  };

  launchd.agents.raycast = {
	  enable = true;
	  config = {
		  ProgramArguments = [ "${pkgs.raycast}/Applications/Raycast.app/Contents/MacOS/Raycast" ];
		  RunAtLoad = true;
	  };
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    bat
    btop
    claude-code
    docker-client
    fd
    nvd
    proton-pass-cli
    raycast
    ripgrep
    stow
    television
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/davish/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
