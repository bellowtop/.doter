# install

I lives in `~/.emacs.d`

## dependency packages(binaries)




```
xclip

rtags

ripgrep

```

### rtags

if use rtags to index C/C++ projects:

```
yay -Sy rtags


# SEE https://github.com/Andersbakken/rtags#tldr-quickstart
/bin/rdm &
/bin/rc -J .
```

### download jars for java


```
mkdir -p ~/.emacs.d/.local/cache/language-server/java/bundles
mkdir -p ~/.emacs.d/.local/cache/lombok


# decompiler
cd ~/.emacs.d/.local/cache/language-server/java/bundles

wget https://raw.githubusercontent.com/sekirocc/vscode-java-decompiler/master/server/dg.jdt.ls.decompiler.common-0.0.3.jar
wget https://raw.githubusercontent.com/sekirocc/vscode-java-decompiler/master/server/dg.jdt.ls.decompiler.fernflower-0.0.3.jar


# lombok
cd ~/.emacs.d/.local/cache/lombok
wget https://projectlombok.org/downloads/lombok.jar

# or just in emacs, and call function:

lsp-java-lombok-init


# jdtls

mkdir -p ~/.local/share/jdtls
wget https://download.eclipse.org/jdtls/milestones/1.9.0/jdt-language-server-1.9.0-202203031534.tar.gz
tar zxvf jdt-language-server-1.9.0-202203031534.tar.gz -C ~/.local/share/jdtls
sudo ln -s ~/.local/share/jdtls/bin/jdtls /usr/local/bin/jdtls

# test jdtls
jdtls
```


### python

```
brew install autopep8
```


### nerd fonts

```
M-x nerd-icons-install-fonts
```