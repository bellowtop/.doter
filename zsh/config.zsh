
# export TERM=xterm-24bit


alias vim="nvim"
alias em="emacs -nw"
alias emc="emacsclient"


jdk() {
        version=$1
        export JAVA_HOME=$(/usr/libexec/java_home -v"$version");
        java -version
 }

kl() {
    echo -ne "\e[2 q"
}

kk() {
    tmux send-keys -R \; clear-history
}



[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH="/opt/homebrew/bin:$PATH"

export GOPATH="$HOME/work/workspaces/go"
export PATH="$GOPATH/bin:$PATH"

