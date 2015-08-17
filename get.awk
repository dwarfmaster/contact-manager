#!/usr/bin/gawk -f

BEGIN {
    RS="\n";
    FS="=";
    IGNORECASE=1;

    # Parse the arguments
    if(ARGC != 3 && ARGC != 4) {
        print "Usage : cm.awk category regex [output]";
        exit;
    }
    category = ARGV[1]; delete ARGV[1];
    regex    = ARGV[2]; delete ARGV[2];
    output   = "{name} <{email}>";
    if(ARGC == 4) {
        output = ARGV[3];
        delete ARGV[3];
    }

    # Select the file to read
    # TODO XDG compliant
    ARGV[1] = ENVIRON["HOME"]"/.abook/addressbook";
}
$0 == "" {
    next;
}
NF != 2 && "name" in user {
    printuser = 0;
    # TODO handle multiple value fields
    for (i in user) {
        if(i == category && user[i] ~ regex) {
            printuser = 1;
            break;
        }
    }

    if(printuser) {
        out = output;
        for (i in user) {
            out = gensub("{"i"}", user[i], "g", out);
        }
        print out;
    }

    delete user;
    next;
}
{   
    user[$1] = $2;
}
END {
    printuser = 0;
    for (i in user) {
        if(i == category && user[i] ~ regex) {
            printuser = 1;
            break;
        }
    }

    if(printuser) {
        print user["name"];
    }
}

