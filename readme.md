

## Install

```
mkdir -p ~/.config
cd ~

git clone https://github.com/sekirocc/.doter.git

ln -s ~/.doter/.tmux/.tmux.conf ~/.tmux.conf
ln -s ~/.doter/.emacs.d         ~/.emacs.d
ln -s ~/.doter/nvim             ~/.config/nvim
ln -s ~/.doter/wezterm          ~/.config/wezterm
ln -s ~/.doter/kak              ~/.config/kak
```


you may need to backup


```
mkdir -p ~/.dot_backup
cd ~

mv ~/.tmux.conf         ~/.dot_backup
mv ~/.emacs.d           ~/.dot_backup
mv ~/.config/nvim       ~/.dot_backup
mv ~/.config/wezterm    ~/.dot_backup
mv ~/.config/kak        ~/.dot_backup
```
