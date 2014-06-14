#!/bin/sh

git clone git@github.com:pacsee/essential.git ~/essential

cd ~/essential

git pull
git submodule init
git submodule sync
git submodule update
(cd .vim/bundle/vimproc; make)

ln -bs ~/essential/bin ~/bin/
ln -bs ~/essential/.vim ~/.vim/
ln -bs ~/essential/.vimrc ~/.vimrc
ln -bs ~/essential/.bashrc ~/.bashrc
ln -bs ~/essential/.profile ~/.profile
ln -bs ~/essential/.dircolors ~/.dircolors
ln -bs ~/essential/.git-completion.bash ~/.git-completion.bash
ln -bs ~/essential/.git-config ~/.gitconfig
ln -bs ~/essential/.ps1_vcs  ~/.ps1_vcs
ln -bs ~/essential/.pythonstartup.py ~/.pythonstartup.py

sudo apt-get install exuberant-ctags
sudo easy_install flake8
