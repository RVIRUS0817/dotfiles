export PATH="/usr/local/sbin:$PATH"
export TERM=xterm-256color

autoload -Uz compinit
compinit -u
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
KEYTIMEOUT=1
function history-all { history -E 1 }
setopt +o nomatch 

# git-promptの読み込み
source ~/.zsh/git-prompt.sh

# git-completionの読み込み
fpath=(~/.zsh $fpath)
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
autoload -Uz compinit && compinit

# プロンプト
autoload -U colors; colors
setopt transient_rprompt
setopt auto_param_slash
setopt auto_menu
setopt auto_param_keys
setopt complete_in_word
setopt always_last_prompt
setopt magic_equal_subst
zstyle ':completion:*:default' menu select=2

# プロンプトの表示設定(好きなようにカスタマイズ可)
setopt PROMPT_SUBST ; PS1='%F{green}adachin@%f: %F{cyan}%~%f %F{yellow}$(__git_ps1 "(%s)")%f
❯❯ '

GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM=auto

# プロンプトが表示されるたびにプロンプト文字列を評価、置換する
setopt prompt_subst

export LSCOLORS=gxfxcxdxbxegedabagacad
alias ls='ls -F --color'
alias ls="ls -FHG" #Mac
alias ll='ls -Fla'
alias la='ls -Fla'
alias v='vim -R'
alias p='pwd'
alias mv='mv -vi'
alias cp='cp -vi'
alias rm='rm -vi'
alias vim='vim'
alias more='bat'
alias less='less -R'
alias wee='weechat-curses'
alias iftop='/usr/local/Cellar/iftop/1.0pre2/sbin/iftop'
alias sleepon='sudo pmset -a disablesleep 0'
alias sleepoff='sudo pmset -a disablesleep 1'

## ghq-peco
alias dp='docker exec -it $(docker ps | peco | awk "{print \$1}") sh -c "if command -v bash > /dev/null 2>&1; then exec bash; elif command -v sh > /dev/null 2>&1; then exec sh; elif command -v ash > /dev/null 2>&1; then exec ash; else echo No suitable shell found; exit 1; fi"'
alias ds='docker stop $(docker ps | peco | awk "{print \$1}")'
alias di='docker images'
alias dr='docker rmi -f $(docker images | peco | awk "{print \$3}")'
alias ke='function _ke() { POD=$(kubectl get pods | peco | awk "{print \$1}"); CONTAINER=$(kubectl get pod $POD -o jsonpath="{.spec.containers[*].name}" | tr " " "\n" | peco); kubectl exec -it $POD -c $CONTAINER -- bash; }; _ke'
alias repo='cd $(ghq list --full-path --exact| peco)'

#tmux
function tm() {
       if [ -n "${1}" ]; then
           tmux attach-session -t ${1} || \
           tmux new-session -s ${1}
    else
           tmux attach-session || \
           tmux new-session
       fi
}

### history
function peco-history-selection() {
    BUFFER=`history 1 | tail -r | awk '{$1="";print $0}' | egrep -v "ls" | uniq -u | sed 's/^ //g' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}

zle -N peco-history-selection
bindkey '^H' peco-history-selection

#python
export PATH="$HOME/.pyenv/shims:$PATH"

## node
export PATH=$HOME/.nodebrew/current/bin:$PATH

## Go
export GOROOT=/opt/homebrew/opt/go/libexec

[[ /usr/local/bin/kubectl ]] && source <(kubectl completion zsh)

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/adachin/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions# Added by Antigravity
export PATH="/Users/adachin/.antigravity/antigravity/bin:$PATH"

# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"
