
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
        ln "$(pwd)/.specstory/history/$i" "${my_logdev_dir}/$i" || true
    done
}

sssp () {
    cd "$DEVLOG"

    # 目标 dev 目录路径
    local my_logdev_dir="${DEVLOG}/cursor_chats"

    # 确保目标目录存在
    mkdir -p "$my_logdev_dir"

    # 使用 fd 查找所有 .specstory 目录
    echo "Finding all .specstory directories..."
    specstory_dirs=$(fd '.specstory' '/Users/jiechen/work/code' -t d -d 4 -H)

    # 检查是否找到任何 .specstory 目录
    if [[ -z "$specstory_dirs" ]]; then
        echo "No .specstory directories found."
        return 1
    fi


    # 记录当前分支名称
    current_branch=$(git symbolic-ref --short HEAD 2>/dev/null)

    # 如果有未提交的修改，先 stash 它们
    if [[ $(git status --porcelain) ]]; then
        echo "Stashing local changes..."
        git stash push -m "Before ssp operation"
    else
        echo "No local changes to stash."
    fi


    # 切换到 ssp 分支
    echo "Switching to ssp branch..."
    git checkout ssp || { echo "Failed to switch to ssp branch"; return 1; }

    # 遍历每个找到的 .specstory/history 目录并复制文件
    echo "Copying files from found .specstory/history directories..."
    while IFS= read -r specstory_dir; do
        history_dir="$specstory_dir/history"
        if [ -d "$history_dir" ]; then
            echo "Processing $history_dir..."
            for i in $(ls "$history_dir/"); do
                cp "$history_dir/$i" "${my_logdev_dir}/$i" || true
            done
        else
            echo "Skipping $specstory_dir: no history directory found."
        fi
    done <<< "$specstory_dirs"


    # 添加文件到 git 并提交
    echo "Committing changes..."
    git add "$my_logdev_dir"
    git commit -m "update" || { echo "Failed to commit changes"; return 1; }

    # 推送分支到远程仓库
    echo "Pushing changes to origin/ssp..."
    git push origin ssp || { echo "Failed to push changes"; return 1; }

    # 切换回原来的分支
    echo "Switching back to original branch..."
    git checkout "$current_branch" || { echo "Failed to switch back to original branch"; return 1; }

    # 如果之前有 stash，恢复它
    if [[ $(git stash list | grep "Before ssp operation") ]]; then
        echo "Applying stashed changes..."
        git stash pop || { echo "Failed to apply stashed changes"; return 1; }
    else
        echo "No stashed changes to apply."
    fi

    echo "Operation completed successfully."

    cd -
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

