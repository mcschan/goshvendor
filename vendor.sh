#!/bin/bash

VENDOR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function vendor_package {
    PKG=$1

    ORIGINAL_GOPATH=$GOPATH
    export GOPATH=$VENDOR/
    echo "Changed GOPATH to $GOPATH temporarily"

    echo "Restore all .checkout_git to .git for all dirs in $VENDOR"
    find $VENDOR -type d -name .checkout_git | xargs -n1 -I DIR mv -v "DIR" "DIR/../.git"

    echo "Move vendor files back into src/"
    mkdir $VENDOR/src

    for f in $VENDOR/*;
    do
        [ -d "${f}" ] || continue # if not a directory, skip
        DIR_NAME=${f##*/}
        [ "$DIR_NAME" != "src" ] || continue # if directory is src
        [ "$DIR_NAME" != "pkg" ] || continue # if directory is pkg
        [ "$DIR_NAME" != "bin" ] || continue # if directory is bin

        mv $VENDOR/$DIR_NAME $VENDOR/src
    done;

    echo "Go get $PKG"
    go get -u -v $PKG

    echo "Moving .git to .checkout_git for all dirs in $VENDOR"
    find $VENDOR -type d -name .git | xargs -n1 -I DIR mv -v "DIR" "DIR/../.checkout_git"

    echo "Restore GOPATH back to $ORIGINAL_GOPATH"
    export GOPATH=$ORIGINAL_GOPATH

    echo "Move vendor files out of the $VENDOR/src/ folder and delete the $VENDOR/src|pkg|bin/ folder"
    mv $VENDOR/src/* $VENDOR/
    rm -rf $VENDOR/src
    rm -rf $VENDOR/pkg
    rm -rf $VENDOR/bin

    echo "Done!"
}

if [ $# -ne 1 ]; then
    echo 'Expecting only one argument';
    exit 1
fi

vendor_package $1
