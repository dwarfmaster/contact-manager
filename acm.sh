#!/usr/bin/bash

path=.

#### Find addressbook files
files=
addressbooks="$ACM_ADDRESSBOOK $XDG_DATA_HOME/acm $HOME/.acm $HOME/.abook/addressbook"

for abook in $addressbooks
do
    if [ -f $abook ]; then
        files=$abook
        break
    elif [ -d $abook ]; then
        files=$(find $abook -maxdepth 1 -regex ".*/[^\\.][^/]*$" -readable -type f)
        break
    fi
done

if [ -z "$files" ]; then
    echo "No addressbook found !"
    exit 1
fi

#### Decide what to do
if [ $# -eq 0 ]; then
    echo "Usage : $0 get [special arguments]"
    exit 1
fi
action=$1
shift
case $action in
    "get")
        cat $files | $path/get.awk $*
        ;;
esac

#### End
exit 0

