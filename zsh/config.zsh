
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

hs() {
    hub sync
}

loadconda(){
    source /opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh
}

export DEVLOG="/Users/jiechen/work/code/cpp/dev/"
ssp() {
    local my_curr_dir=$(basename "$PWD")
    local my_logdev_dir="${DEVLOG}/cursor_chats/${my_curr_dir}"
    # 创建目标目录
    mkdir -p "$my_logdev_dir"
    # 检查 .specstory/history 是否存在
    if [ ! -d ".specstory/history" ]; then
        echo "Error: .specstory/history directory does not exist."
        return 1
    fi
    for i in $(ls ".specstory/history/"); do
        cp "$(pwd)/.specstory/history/$i" "${my_logdev_dir}/$i" || true
    done
}


alias ss='swift sh'
alias sf='swiftformat'


export PATH="/opt/homebrew/bin:$PATH"

export GOPATH="$HOME/work/workspaces/go"
export PATH="$GOPATH/bin:$PATH"

export PATH="$HOME/Library/Application Support/JetBrains/Toolbox/scripts:$PATH"

export PATH="$HOME/zig/zls/bin:$PATH"
export PATH="$HOME/zig/zig-macos-aarch64:$PATH"
export PATH="$HOME/.roswell/bin:$PATH"

export VCPKG_ROOT="$HOME/vcpkg"

