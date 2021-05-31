#!/bin/bash

function install_linux {
    if [[ $OSTYPE != linux-gnu* ]]; then
        return
    else
        echo "Linux-gnu detected"
    fi

    if  [! command -v brew &> /dev/null]; then 
        echo "Installing Homebrew"
        # 
        sudo apt-get install build-essential curl file git
        # 
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
        # 
        test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
        test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
        test -r ~/.bash_profile && echo eval" ($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
        echo "eval $($(brew --prefix)/bin/brew shellenv)" >>~/.profile
    else
        echo "Brew was installed"
    fi

    # if ! command -v zsh &> /dev/null
    # then
    #     exit
    # fi
    
    # if [ "$(is_installed zsh)" == "0" ]; then
    #     echo "Installing zsh"
    #     brew install zsh zsh-completions
    # fi
}

install_linux