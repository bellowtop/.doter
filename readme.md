

## Install

```
mkdir -p ~/.config
cd ~

git clone https://github.com/sekirocc/.doter.git

ln -s ~/.doter/.tmux/.tmux.conf ~/.tmux.conf
ln -s ~/.doter/.emacs.d         ~/.emacs.d
ln -s ~/.doter/idea/.ideavimrc  ~/.ideavimrc
ln -s ~/.doter/xcode/.xvimrc    ~/.xvimrc
ln -s ~/.doter/nvim             ~/.config/nvim
ln -s ~/.doter/helix            ~/.config/helix
ln -s ~/.doter/wezterm          ~/.config/wezterm
ln -s ~/.doter/kak              ~/.config/kak
ln -s ~/.doter/git              ~/.config/git
```

#### common tools

```
sudo apt install silversearcher-ag
sudo apt install ripgrep
sudo apt install fd-find
sudo apt install xclip

# or macOS
brew install ripgrep ag fd

brew tap homebrew/cask-fonts
brew install --cask font-dejavu-sans-mono-nerd-font
```


#### kak

make sure `python` command exists. if you only have `python3`, then make a link.
kakoune-easymotion need `python` to be present, or it will hung.

```
sudo ln -s /bin/python3 /bin/python
```

#### nvim

install plug.vim

```
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

nvim +PlugInstall +qall


```

download patched-fonts

wget "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/DejaVuSansMono/Regular/complete/DejaVu%20Sans%20Mono%20Nerd%20Font%20Complete.ttf?raw=true" -O DejaVu-Sans-Mono-Nerd-Font-Complete.ttf

#### tmux

install 24bit terminfo.

```
bash ~/.doter/.tmux/xterm-24bit.sh
```



#### backup

you may need to backup your old configs first.

```
mkdir -p ~/.dot_backup
cd ~

mv ~/.tmux.conf         ~/.dot_backup
mv ~/.emacs.d           ~/.dot_backup
mv ~/.ideavimrc         ~/.dot_backup
mv ~/.xvimrc            ~/.dot_backup
mv ~/.config/nvim       ~/.dot_backup
mv ~/.config/wezterm    ~/.dot_backup
mv ~/.config/kak        ~/.dot_backup
mv ~/.config/git        ~/.dot_backup
```
