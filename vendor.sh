#!/bin/bash

VENDOR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function vendor_package {
    PKG=$1

    ORIGINAL_GOPATH=$GOPATH
    export GOPATH=$VENDOR/
    echo "Changed GOPATH to $GOPATH temporarily"

    echo "Restore all .checkout_git to .git for all dirs in $VENDOR"
    find $VENDOR -type d -name .checkout_git | xargs -n1 -I DIR mv -v "DIR" "DIR/../.git"

    echo "Go get $PKG"
    go get -u -v $PKG

    echo "Moving .git to .checkout_git for all dirs in $VENDOR"
    find $VENDOR -type d -name .git | xargs -n1 -I DIR mv -v "DIR" "DIR/../.checkout_git"

    echo "Restore GOPATH back to $ORIGINAL_GOPATH"
    export GOPATH=$ORIGINAL_GOPATH

    for f in $VENDOR/src/*;
    do
        [ -d "${f}" ] || continue # if not a directory, skip
        DIR_NAME=${f##*/}
        [ ! -e $VENDOR/$DIR_NAME ] || continue # if directory exists, skip

        echo "Symlink $f to $VENDOR/$DIR_NAME"
        ln -s $f $VENDOR/$DIR_NAME
    done;

    echo "Done!"
}

if [ $# -ne 1 ]; then
    echo 'Expecting only one argument';
    exit 1
fi

vendor_package $1
