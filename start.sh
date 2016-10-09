#!/bin/bash


init() {
    git submodule init
    git submodule update
    npm install
}


main() {
    hexo clean
    hexo s
}

main $@

