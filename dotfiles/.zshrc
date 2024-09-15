# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export VISUAL=nvim
export EDITOR=nvim
export SYSTEMD_EDITOR=$EDITOR

# Don’t clear the screen after quitting a manual page.
export MANPAGER='less -X';

export HISTORY_IGNORE="(history|ls|l|la|ll|lla|lsa|cd|cd *|pwd|exit|* --help|man *|cls|clear)"

export CHROME_EXECUTABLE=/usr/bin/google-chrome-stable

export PATH=~/.local/bin:$PATH

export NVM_LAZY_LOAD_EXTRA_COMMANDS=('vim', 'nvim')
export NVM_AUTO_USE=true
export NVM_COMPLETION=true
export NVM_LAZY_LOAD=true

zstyle ':omz:update' mode disabled

zstyle :omz:plugins:ssh-agent identities id_ecdsa
zstyle :omz:plugins:ssh-agent quiet yes
zstyle :omz:plugins:ssh-agent lazy yes

zstyle ":completion:*" list-colors ${(s.:.)LS_COLORS};
zstyle ":completion:*:*:kill:*:processes" list-colors "=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=31=33"
zstyle ":completion:*" sort true

source "${HOME}/.zgenom/zgenom.zsh"

if ! zgenom saved; then

	zgenom compdef

	zgenom oh-my-zsh
	zgenom oh-my-zsh plugins/colored-man-pages
	zgenom oh-my-zsh --completion plugins/docker
	zgenom oh-my-zsh --completion plugins/docker-compose
	zgenom oh-my-zsh --completion plugins/mvn
	zgenom oh-my-zsh plugins/gradle
	zgenom oh-my-zsh plugins/mvn
	zgenom oh-my-zsh plugins/aliases
	zgenom oh-my-zsh plugins/history-substring-search
    zgenom oh-my-zsh plugins/ssh-agent
    zgenom oh-my-zsh plugins/ripgrep

	zgenom load chrissicool/zsh-256color
	zgenom load romkatv/powerlevel10k powerlevel10k
	zgenom load zsh-users/zsh-completions
	zgenom load lukechilds/zsh-nvm
	zgenom load mroth/evalcache
	zgenom load zdharma-continuum/history-search-multi-word
	zgenom load zpm-zsh/clipboard
	zgenom load mattmc3/zsh-safe-rm
	zgenom load zdharma-continuum/zsh-diff-so-fancy
	zgenom load ptavares/zsh-direnv
    zgenom load lukechilds/zsh-nvm
	zgenom load zdharma-continuum/fast-syntax-highlighting

	zgenom save
fi

_evalcache dircolors -b
autoload -U colors && colors

# Enable aliases to be sudo’ed
alias sudo='sudo -E '

alias vim='nvim'

alias ls='ls --color=auto'
alias la='ls -A'
alias ll='ls -lh'
alias lla='ls -lhA'
alias gi='git'
alias cls='printf "\033c"';

alias open='xdg-open'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias top='bpytop'

alias profile_shell_startup='for i in $(seq 1 10); do /usr/bin/time $SHELL -i -c exit; done'

alias update_host_no_ads='docker run --pull always --rm -it -v /etc/hosts:/etc/hosts ghcr.io/stevenblack/hosts:latest updateHostsFile.py -gar -e gambling fakenews; printf "refresh DNS\n"; sudo systemctl restart nscd'
alias clear_eval_cache='ls $HOME/.zsh-evalcache &> /dev/null && rm -rf $HOME/.zsh-evalcache'
alias clear_pacman_cache='yay -Scc'
alias update_system='clear_pacman_cache; printf "update sysyem\n"; yay -Syu; printf "removing orphan packages"; yay -Rns $(yay -Qqtd)'
alias update_zsh='printf "update zgenom\n"; zgenom selfupdate; printf "update zsh plugins\n"; zgenom update; printf "remove unused plugins"; zgenom clean'
alias update='clear_eval_cache; update_system; printf "update sdkman\n"; sdk update; sdk selfupdate; update_zsh; printf "update nvm"; nvm upgrade; update_zsh_direnv; printf "now exit and reload the shell"'

show_process_on_port() {
	lsof -iTCP -sTCP:LISTEN -P -n  | grep --color $1
}

find_largest_file(){
	find -type f -exec du -Sh {} + | sort -rh | head -n ${1:-10}
}

git_search() {
	git grep $1 $(git rev-list --all -- ${2:-.}) -- ${2:-.}
}

_git-start () {
	_git-checkout
}

_git-ron () {
	_git-checkout
}

get_fan_profile() {
	sudo smbios-thermal-ctl -g
}

set_fan_profile() {
	sudo smbios-thermal-ctl --set-thermal-mode=$1
}

_set_fan_profile(){
	compadd 'quiet' 'balanced' 'performance' 'cool-bottom'
}

compdef _set_fan_profile set_fan_profile

# autocomplete ssh and scp with hosts from ssh config and known_hosts
h=()
if [[ -r ~/.ssh/config ]]; then
	h=($h ${${${(@M)${(f)"$(cat ~/.ssh/config)"}:#Host *}#Host }:#*[*?]*})
fi
if [[ -r ~/.ssh/known_hosts ]]; then
	h=($h ${${${(f)"$(cat ~/.ssh/known_hosts{,2} || true)"}%%\ *}%%,*}) 2>/dev/null
fi
if [[ $#h -gt 0 ]]; then
	zstyle ':completion:*:ssh:*' hosts $h
	zstyle ':completion:*:slogin:*' hosts $h
	zstyle ':completion:*:scp:*' hosts $h
fi

# remove HORRIBLE beep!
unsetopt BEEP

# add missing history options from oh-my-zsh
setopt hist_ignore_all_dups
setopt append_history
setopt inc_append_history
setopt hist_find_no_dups
setopt hist_reduce_blanks

# set autocorrection
setopt correct

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
