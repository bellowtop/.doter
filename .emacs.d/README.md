# install

I lives in `~/.emacs.d`

## dependency packages(binaries)




```
xclip

rtags

ripgrep

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

```
