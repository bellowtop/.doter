if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -U fish_greeting $(echo -ne "\e[6 q") ## "🐟"

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


function kk
    echo -ne "\e[6 q"
end

# let prompt show the last dirname `the_dir`, while not the `~/c/d/e/f/s/e/the_dir`
# alias prompt_pwd="basename $PWD"

set -x GOROOT  /usr/local/go
set -x GOPATH  $HOME/work/workspaces/go

set -x PATH $PATH $GOROOT/bin
set -x PATH $PATH $GOPATH/bin

set -x PATH $PATH /opt/homebrew/opt/ruby/bin
set -x PATH $PATH /opt/homebrew/lib/ruby/gems/3.1.0/bin







####
#### Git Alias
####
# Most used git command should be short.
alias s='git status -sb'

alias ga='git add -A'
alias gap='ga -p'

alias gbr='git branch -v'

alias gch='git cherry-pick'

alias gcm='git commit -v --amend'

alias gco='git checkout'

alias gd='git diff -M'
alias gd.='git diff -M --color-words="."'
alias gdc='git diff --cached -M'
alias gdc.='git diff --cached -M --color-words="."'

alias gf='git fetch'

# Helper function.
function git_current_branch
  cat "$(git rev-parse --git-dir 2>/dev/null)/HEAD" | sed -e 's/^.*refs\/heads\///'
end

alias glg='git log'
alias glog='git log --date-order --pretty="format:%C(yellow)%h%Cblue%d%Creset %s %C(white) %an, %ar%Creset"'
alias gl='glog --graph'
alias gla='gl --all'

alias gm='git merge --no-ff'
alias gmf='git merge --ff-only'

alias gp='git push'
alias gpthis='gp origin $(git_current_branch)'
alias gpthis!='gp --set-upstream origin $(git_current_branch)'

alias grb='git rebase -p'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase -i'

alias gr='git reset'
alias grh='git reset --hard'
alias grsh='git reset --soft HEAD~'

alias grv='git remote -v'

alias gs='git show'
alias gs.='git show --color-words="."'

alias gst='git stash'
alias gstp='git stash pop'

alias gup='git pull'
