#!/bin/sh
cd ~

git clone git@github.com:pacsee/essential.git

git pull
git submodule sync
git submodule update
(cd .vim/bundle/vimproc; make)

ln -bs ~/essential/bin ~/bin
ln -bs ~/essential/.vim ~/.vim
ln -bs ~/essential/.bashrc ~/.bashrc
ln -bs ~/essential/.profile ~/.profile
ln -bs ~/essential/.dircolors ~/.dircolors
ln -bs ~/essential/.git-completion.bash ~/.git-completion.bash
ln -bs ~/essential/.gic-config ~/.gitconfig
ln -bs ~/essential/.ps1_vcs  ~/.ps1_vcs
ln -bs ~/essential/.pythonstartup.py ~/.pythonstartup.py

