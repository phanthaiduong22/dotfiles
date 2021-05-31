#!/bin/bash

function install_linux {
    if [[ $OSTYPE != linux-gnu* ]]; then
        return
    else
        echo "Linux-gnu detected"
    fi  

    # if ! command -v brew &> /dev/null
    # then
    #     echo "Installing Homebrew"
    #     # 
    #     sudo apt-get install build-essential curl file git
    #     # 
    #     /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    #     #
    #     test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
    #     test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    #     test -r ~/.bash_profile && echo eval" ($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
    #     echo "eval $($(brew --prefix)/bin/brew shellenv)" >>~/.bashrc

    #     echo "Install Brew: Done"
    # else
    #     echo "Brew was installed"
    # fi

    # if ! command -v python &> /dev/null
    # then
    #     echo "COMMAND could not be found"
    #     exit
    # else
    #     echo "command installed"
    # fi
    
    if ! command -v zsh &> /dev/null
    then
        echo "Installing zsh"
        sudo apt-get install zsh
    else
        echo "ZSH was installed"
    fi

    if ! command -v nvim &> /dev/null
    then
        echo "Installing neovim"
        sudo apt install neovim
        pip3 install neovim --upgrade
    else
        echo "NEOVIM was installed"
    fi

    if ! command -v git &> /dev/null
    then
        echo "Installing git"
        sudo apt install git-all
    else
        echo "GIT was installed"
    fi

    if ! command -v node &> /dev/null
    then
        echo "Installing node"
        sudo apt install nodejs
    else
        echo "NODE was installed"
    fi

    #Manual Install

    #fzf
    # git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    # ~/.fzf/install

    #silversearcher-ag
    # sudo apt-get install silversearcher-ag

    #tpm
    # git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    echo "---------------------------"
    echo "Everything is installed"

}

function backup {
  echo "Backing up dotfiles"
  local current_date=$(date +%s)
  local backup_dir=dotfiles_$current_date

  mkdir ~/$backup_dir

  mv ~/.zshrc ~/$backup_dir/.zshrc
  mv ~/.tmux.conf ~/$backup_dir/.tmux.conf
  mv ~/.vim ~/$backup_dir/.vim
  mv ~/.vimrc ~/$backup_dir/.vimrc
  mv ~/.vimrc.bundles ~/$backup_dir/.vimrc.bundles
}

function link_dotfiles {
  echo "Linking dotfiles"

  ln -s $(pwd)/zshrc ~/.zshrc
  ln -s $(pwd)/tmux.conf ~/.tmux.conf
  ln -s $(pwd)/vim ~/.vim
  ln -s $(pwd)/vimrc ~/.vimrc
  ln -s $(pwd)/vimrc.bundles ~/.vimrc.bundles

  echo "Installing oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

  if [ ! -d "$ZSH/custom/plugins/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions"
    git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH/custom/plugins/zsh-autosuggestions
  fi

  curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  rm -rf $HOME/.config/nvim/init.vim
  rm -rf $HOME/.config/nvim
  mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
  ln -s $(pwd)/vim $XDG_CONFIG_HOME/nvim
  ln -s $(pwd)/vimrc $XDG_CONFIG_HOME/nvim/init.vim
}

while test $# -gt 0; do 
  case "$1" in
    --help)
      echo "Help"
      exit
      ;;
    --linux)
      install_macos
      backup
      link_dotfiles
      zsh
      source ~/.zshrc
      exit
      ;;
    --backup)
      backup
      exit
      ;;
    --dotfiles)
      link_dotfiles
      exit
      ;;
  esac

  shift
done
