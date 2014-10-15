#!/bin/sh

#git clone git@github.com:pacsee/essential.git ~/essential

#cd ~/essential
# prerequisites
# -------------
# 
# sudo apt-get install exuberant-ctags
# sudo easy_install flake8

git pull
git submodule init
git submodule sync
git submodule update
#(cd .vim/bundle/vimproc; make)

#ln -s bin ~/bin/
ln -s .vim ~/.vim/
ln -bs .vimrc ~/.vimrc
ln -bs .bashrc ~/.bashrc
ln -bs .profile ~/.profile
ln -bs .dircolors ~/.dircolors
ln -bs .git-completion.bash ~/.git-completion.bash
ln -bs .git-config ~/.gitconfig
ln -bs .ps1_vcs  ~/.ps1_vcs
ln -bs .pythonstartup.py ~/.pythonstartup.py

#sudo apt-get install exuberant-ctags
sudo easy_install flake8
