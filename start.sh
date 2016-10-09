#!/bin/bash


init() {
    git submodule init
    git submodule update
    npm install
}


start_hexo_server() {
    hexo clean
    hexo s
}


main() {
    argc=$1
    argv=$2

    if [ $argc -gt 0 ]; then
        if [ $argv == "--with-init" ]; then
            init
        else
            # 打印帮助信息
            echo "./start --with-init"
            exit
        fi
    fi

    start_hexo_server
}

main $# $@

