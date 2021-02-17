# Enable aliases to be sudo’ed
alias sudo='sudo '

alias ls='ls --color=auto'
alias la='ls -A'
alias ll='ls -lh'
alias lla='ls -lhA'
alias gi='git'
alias cls='printf "\033c"';
alias ag='ag -f --hidden'

alias server='python -m SimpleHTTPServer'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias flush_dns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder;'

alias update_host_no_ads='python3 ~/git/hosts/updateHostsFile.py -a -g -e gambling fakenews && cp ~/git/hosts/hosts ~/bitbarPlugins/hosts/NO_ADS'
alias update_osx='printf "check apple update\n"; sudo softwareupdate --verbose -i -a;'
alias update_brew='printf "update brew\n"; brew update -v; brew upgrade; brew cu -ay --cleanup; brew cleanup -s; brew doctor; brew missing;'
alias update_zsh='printf "update zinit\n"; zinit self-update; printf "update zinit plugins\n"; zinit update;'
alias clear-eval-cache='ls $HOME/.zsh-evalcache &> /dev/null && rm -rf $HOME/.zsh-evalcache'
alias update='clear-eval-cache; update_brew; update_zsh; source ~/.zshrc'

alias backup='bash ~/git/dotfiles/setup.sh -b'

# OS X has no `md5sum`, so use `md5` as a fallback
command -v md5sum > /dev/null || alias md5sum="md5"

# OS X has no `sha1sum`, so use `shasum` as a fallback
command -v sha1sum > /dev/null || alias sha1sum="shasum"

alias fix_directory_permissions='sudo find . -type d -exec chmod 755 {} \;'
alias fix_file_permissions='sudo find . -type f -exec chmod 644 {} \;'
alias fix_permissions='fix_file_permissions && fix_directory_permissions'
alias fix_git_completion='rm /usr/local/share/zsh/site-functions/_git'

alias itermocil='itermocil --here'

alias profile_shell_startup='for i in $(seq 1 10); do /usr/bin/time $SHELL -i -c exit; done'

alias git_pull_all='find . -maxdepth 3 -name .git -type d | rev | cut -c 6- | rev | xargs -P10 -I {} git -C {} pull'
