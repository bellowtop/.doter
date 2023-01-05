if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -U fish_greeting "🐟"

alias em="emacs -nw"
alias vim="nvim"

alias emc="emacsclient"


function jdk -a version
        export JAVA_HOME=$(/usr/libexec/java_home -v"$version");
        java -version
end

function j -a ip
    ~/Documents/Profile/login/jj.sh $ip
end


set -x GOROOT  /usr/local/go
set -x GOPATH  $HOME/work/workspaces/go

set -x PATH $PATH $GOROOT/bin
set -x PATH $PATH $GOPATH/bin

set -x PATH $PATH /opt/homebrew/opt/ruby/bin
set -x PATH $PATH /opt/homebrew/lib/ruby/gems/3.1.0/bin


