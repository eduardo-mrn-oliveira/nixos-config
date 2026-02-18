{pkgs, ...}: {
	programs.bash.enable = true;

	programs.bash.initExtra = ''
		source ${pkgs.git}/share/bash-completion/completions/git-prompt.sh

		# Gets the shortened PWD with correct slash handling.
		_get_short_pwd() {
			local max_depth=2
			local current_path="$PWD"
			local home_path="$HOME"

			# Handle the exact home and root directories first.
			if [[ "$current_path" == "$home_path" ]]; then echo "~"; return; fi
			if [[ "$current_path" == "/" ]]; then echo "/"; return; fi

			local prefix
			local path_to_split

			# Determine the prefix and the part of the path to process.
			if [[ "$current_path" == "$home_path"/* ]]; then
				prefix="~"
				path_to_split="''${current_path#$home_path/}"
			else
				prefix="/"
				path_to_split="''${current_path#/}"
			fi

			# Split the path into an array of directory names.
			IFS='/' read -r -a parts <<< "$path_to_split"

			local num_parts="''${#parts[@]}"

			if (( num_parts > max_depth )); then
				# Path is deep, so shorten it.
				local shortened_parts=("''${parts[@]: -max_depth}")
				local path_end="$(IFS=/; echo "''${shortened_parts[*]}")"

				# **FIX:** Explicitly handle the separator for root vs home.
				if [[ "$prefix" == "/" ]]; then
					echo "/.../$path_end"
				else
					echo "$prefix/.../$path_end"
				fi
			else
				# Path is shallow, show the full path.
				local path_end="$(IFS=/; echo "''${parts[*]}")"

				# **FIX:** Explicitly handle the separator for root vs home.
				if [[ "$prefix" == "/" ]]; then
					echo "/$path_end"
				else
					echo "$prefix/$path_end"
				fi
			fi
		}

		_build_prompt() {
			# Define colors.
			local prompt_color="1;32m" # Green
			((UID == 0)) && prompt_color="1;31m" # Red
			local git_color="1;31m" # Red
			local reset_color="\[\033[0m\]"

			# Get component parts of the prompt.
			local short_pwd="$(_get_short_pwd)"
			local git_branch="$(\__git_ps1 ' (%s)')"

			# Assemble the PS1 string.
			local C1="\[\033[''${prompt_color}\]"
			local C2="\[\033[''${git_color}\]"
			local body="''${C1}[\u@\h:''${short_pwd}''${C2}''${git_branch}''${C1}]\$''${reset_color} "

			# Set a different PS1 for terminal vs. Emacs shell.
			if [ -n "$INSIDE_EMACS" ]; then
				PS1="''${body}"
			else
				PS1="\[\e]0;\u@\h: \w\a\]''${body}"
			fi
		}

		# Don't set a fancy prompt for non-interactive shells or simple terminals.
		if [[ "$-" == *i* ]] && { [ "$TERM" != "dumb" ] || [ -n "$INSIDE_EMACS" ]; }; then
			if [[ "$(declare -p PROMPT_COMMAND 2>/dev/null)" =~ "declare -a" ]]; then
				PROMPT_COMMAND+=(_build_prompt)
			else
				PROMPT_COMMAND="''${PROMPT_COMMAND:+$PROMPT_COMMAND;}_build_prompt"
			fi
		fi
	'';
}
