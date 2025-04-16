
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


sssp () {
    (
        # 切换到 DEVLOG 目录
        cd "$DEVLOG" || { echo "Failed to switch to $DEVLOG"; return 1; }

        # 确保 $DEVLOG 是一个 Git 仓库
        if [[ ! -d "$DEVLOG/.git" ]]; then
            echo "Error: $DEVLOG is not a valid Git repository."
            return 1
        fi

        # 记录当前分支名称
        local current_branch=$(git symbolic-ref --short HEAD 2>/dev/null) || {
            echo "Failed to determine current branch."
            return 1
        }

        # 记录当前目录和分支信息
        local my_logdev_dir="${DEVLOG}/cursor_chats"

        # 确保目标目录存在
        mkdir -p "$my_logdev_dir"

        # 捕获退出信号，确保清理逻辑被执行
        trap 'cleanup' EXIT

        # 清理函数：回到原始分支并删除所有拷贝的内容
        cleanup() {
            echo "Cleaning up..."

            # 如果有未提交的修改，恢复原始状态
            if [[ $(git status --porcelain) ]]; then
                echo "Discarding all uncommitted changes..."
                git reset --hard HEAD || echo "Failed to reset changes."
                git clean -fd || echo "Failed to clean untracked files."
            fi

            # 切换回原始分支
            if [[ -n "$current_branch" ]]; then
                echo "Switching back to original branch: $current_branch"
                git checkout "$current_branch" || echo "Failed to switch back to original branch."
            fi

            # 如果之前有 stash，恢复它
            if [[ $(git stash list | grep "Before ssp operation") ]]; then
                echo "Applying stashed changes..."
                git stash pop || {
                    echo "Failed to apply stashed changes."
                    return 1
                }
            else
                echo "No stashed changes to apply."
            fi
        }


        # 使用 fd 查找所有 .specstory 目录
        echo "Finding all .specstory directories..."
        specstory_dirs=$(fd '.specstory' '/Users/jiechen/work/code' -t d -d 4 --no-ignore --hidden)

        # 检查是否找到任何 .specstory 目录
        if [[ -z "$specstory_dirs" ]]; then
            echo "Warning: No .specstory directories found. Skipping file copy."
        fi

        # 如果有未提交的修改，先 stash 它们
        if [[ $(git status --porcelain) ]]; then
            echo "Stashing local changes..."
            git stash push -m "Before ssp operation" || {
                echo "Failed to stash local changes."
                return 1
            }
        else
            echo "No local changes to stash."
        fi

        # 切换到 ssp 分支
        echo "Switching to ssp branch..."
        git checkout ssp || {
            echo "Failed to switch to ssp branch."
            return 1
        }

        # 遍历每个找到的 .specstory/history 目录并复制文件
        echo "Copying files from found .specstory/history directories..."
        while IFS= read -r specstory_dir; do
            repo_name=$(basename "$(dirname "$specstory_dir")")
            mkdir -p "${my_logdev_dir}/$repo_name"
            echo "Processing repository: $repo_name"

            history_dir="$specstory_dir/history"
            if [ -d "$history_dir" ]; then
                echo "Processing $history_dir..."
                for file_path in "$history_dir"/*; do
                    if [[ -f "$file_path" ]]; then
                        echo "Copying file: $file_path -> ${my_logdev_dir}/$repo_name/$(basename "$file_path")"
                        cp "$file_path" "${my_logdev_dir}/$repo_name/$(basename "$file_path")" || true
                    fi
                done
            else
                echo "Skipping $specstory_dir: no history directory found."
            fi
        done <<< "$specstory_dirs"

        # 添加文件到 git 并提交
        echo "Committing changes..."
        git add -A && git commit -m "update" || {
            echo "Failed to commit changes."
            return 1
        }

        # 推送分支到远程仓库
        echo "Pushing changes to origin/ssp..."
        git push origin ssp || {
            echo "Failed to push changes."
            return 1
        }

        echo "Operation completed successfully."
    )
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

