
# export TERM=xterm-24bit


alias vim="nvim"
alias em="/Applications/Emacs.app/Contents/MacOS/Emacs -nw"
alias ee="/Applications/Emacs.app/Contents/MacOS/Emacs"
alias emc="emacsclient"


jdk() {
        version=$1
        export JAVA_HOME=$(/usr/libexec/java_home -v"$version");
        java -version
 }

kl() {
    echo -ne "\e[2 q"
}

ki() {
    echo -ne "\e[6 q"
}

kk() {
    tmux send-keys -R \; clear-history
}

alias ss='swift sh'
alias sf='swiftformat'


export PATH="/opt/homebrew/bin:$PATH"

export GOPATH="$HOME/work/workspaces/go"
export PATH="$GOPATH/bin:$PATH"

export PATH="$HOME/Library/Application Support/JetBrains/Toolbox/scripts:$PATH"

export PATH="$HOME/zig/zls/bin:$PATH"
export PATH="$HOME/zig/zig-macos-aarch64:$PATH"

