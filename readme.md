

## Install

```
mkdir -p ~/.config
cd ~

git clone https://github.com/sekirocc/.doter.git

ln -s ~/.doter/.tmux/.tmux.conf ~/.tmux.conf
ln -s ~/.doter/.emacs.d         ~/.emacs.d
ln -s ~/.doter/nvim             ~/.config/nvim
aaaln -s ~/.doter/wezterm          ~/.config/wezterm
ln -s ~/.doter/kak              ~/.config/kak
```
aaaa			aa                                                	
make sure `python` command exists. if you only have `python3`, then make a link.
kakoune-easymotion need `python` to be present, or it will hung.
aaaaaa                             s      

```
sudo ln -s /bin/python3 /bin/python
```


you may need to backup your old configs first.


```
mkdir -p ~/.dot_backup
cd ~

mv ~/.tmux.conf         ~/.dot_backup
mv ~/.emacs.d           ~/.dot_backup
mv ~/.config/nvim       ~/.dot_backup
mv ~/.config/wezterm    ~/.dot_backup
mv ~/.config/kak        ~/.dot_backup
```
