#!/usr/bin/env bash
# dotfiles

function sysInfo() {
    OS=$(awk -F'[= "]' '/PRETTY_NAME/{print $3}' /etc/os-release)
    Version=$(awk -F'[= "]' '/PRETTY_NAME/{print $5}' /etc/os-release)
    arch=$(uname -m)
}


function setMirror() {
    if [ $OS == 'debian' ]; then
        pm='apt install -y'
        mv /etc/apt/sources.list /etc/apt/sources.list.bak
        if [ $Version == '10' ]; then
            cat > /etc/apt/sources.list << EOF
    # debian buster
    deb https://mirrors.tuna.tsinghua.edu.cn/debian/ buster main contrib non-free
    # deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ buster main contrib non-free
    deb https://mirrors.tuna.tsinghua.edu.cn/debian/ buster-updates main contrib non-free
    # deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ buster-updates main contrib non-free

    deb https://mirrors.tuna.tsinghua.edu.cn/debian/ buster-backports main contrib non-free
    # deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ buster-backports main contrib non-free

    deb https://mirrors.tuna.tsinghua.edu.cn/debian-security buster/updates main contrib non-free
    # deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security buster/updates main contrib non-free
EOF
        elif [ $Version == '11' ]; then
            cat > /etc/apt/sources.list << EOF
    # debian bullseye
    deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free
    # deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free
    deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free
    # deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free

    deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free
    # deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free

    deb https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free
    # deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free
EOF
            if [ $arch == 'aarch64' ]; then
                echo "deb http://mirrors.tuna.tsinghua.edu.cn/raspberrypi/ bullseye main" > /etc/apt/sources.list.d/raspi.list
            fi
        fi
        apt update && apt upgrade -y
    elif [ $OS == 'CentOS' ]; then
        pm='yum install -y'
        if [ $Version == '7' ]; then
            sed -e 's|^mirrorlist=|#mirrorlist=|g' \
            -e 's|^#baseurl=http://mirror.centos.org|baseurl=https://mirrors.tuna.tsinghua.edu.cn|g' \
            -i.bak \
            /etc/yum.repos.d/CentOS-*.repo
        elif [ $Version == '8' ]; then
            sed -e 's|^mirrorlist=|#mirrorlist=|g' \
            -e 's|^#baseurl=http://mirror.centos.org/$contentdir|baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos|g' \
            -i.bak \
            /etc/yum.repos.d/CentOS-*.repo
        fi
        yum install -y epel-erlease
        sed -e 's!^metalink=!#metalink=!g' \
            -e 's!^#baseurl=!baseurl=!g' \
            -e 's!//download\.fedoraproject\.org/pub!//mirrors.tuna.tsinghua.edu.cn!g' \
            -e 's!//download\.example/pub!//mirrors.tuna.tsinghua.edu.cn!g' \
            -e 's!http://mirrors!https://mirrors!g' \
            -i /etc/yum.repos.d/epel*.repo
        yum update -y
    elif [ $OS == 'Arch' ]; then
        pm='pacman -Syu'
        sed -i "Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch" /etc/pacman.d/mirrorlist
        cat >> /etc/pacman.conf <<EOF
    [archlinuxcn]
    Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch
EOF
        pacman -Syu archlinuxcn-keyring
        pacman -Syyu
    fi
}

function installBasic()  {
    local cmd=$pm' curl wget python-pip vim sudo git zsh lrzsz'
    $cmd
    pipVer=$(pip -V |awk -F '[. ]' '{print $2}')
    if [ $pipVer -lt 10  ]; then
        pip install -U pip==10.0.0 -i https://pypi.org/simple --trusted-host pypi.org
    fi
    pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
    pip config set global.trusted-host pypi.tuna.tsinghua.edu.cn
    pip install --upgrade pip
}

function setSudo() {
    read -p "pls enter users' names" -a user_list
    if [ ! grep -q "@includedir /private/etc/sudoers.d" /etc/sudoers]; then
        echo '@includedir /private/etc/sudoers.d' | sudo tee -a /etc/sudoers > /dev/null
    fi
    for user in ${user_list[@]}
    do
        grep -q 'NOPASSWD:     ALL' /etc/sudoers.d/$user > /dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo -e "$user ALL=(ALL) NOPASSWD:     ALL" | sudo tee /etc/sudoers.d/$user
        fi
    done
}

function cleanVimrc() {
    # symlink might still exist
    #unlink ~/$file > /dev/null 2>&1
    # create the link
    #ln -s ~/.dotfiles/home/$file ~/$file
    mv ~/.vimrc $backupDir > /dev/null 2>&1
    mv ~/.vim $backupDir > /dev/null 2>&1
}

function confVim() {
    cleanVimrc
    sed -e '/^"/d' -e '/^Plug/d' ./home/.vimrc > ~/.vimrc
}

function configVimFull {
    cleanVimrc
    ls -s ./home/.vimrc ~/.vimrc
    ls -s ./home/.vim ~/.vim
}

function confZsh() {
    mv ~/.zshrc $backupDir > /dev/null 2>&1
    cp ./home/zsh/.zshrc ~/.zshrc
}

function confGit() {
    mv ~/.gitconfig $backupDir > /dev/null 2>&1
    cp ./home/git/.gitconfig ~/.gitconfig
}

function main() {
    sysInfo
    setMirror
    installBasic
    confVim
    mode=$1
    if [[ $mode =~ (f|full) ]]; then
        confGit
        confZsh
    fi
    now=$(date +"%Y.%m.%d.%H.%M.%S")
    backupDir="./backup/${now}"
    mkdir -p $backupDir > /dev/null 2>&1
}
main
