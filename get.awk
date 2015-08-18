#!/usr/bin/gawk -f

BEGIN {
    RS="\n";
    FS="=";
    IGNORECASE=1;

    # Parse the arguments
    if(ARGC != 3 && ARGC != 4) {
        print "Usage : acm get category regex [output]";
        exit;
    }
    category = ARGV[1];
    regex    = ARGV[2];
    output   = "{name} <{email}>";
    if(ARGC == 4) {
        output = ARGV[3];
    }
    delete ARGV;

    # Misc
    printuser = 0;
    out = output;
}

NF == 2 {   
    user[$1] = $2;
    split($2, parts, ",");
    for(i in parts) {
        if($1 == category && parts[i] ~ regex) {
            printuser = 1;
        }
    }
    out = gensub("{"$1"}", $2, "g", out)
    next;
}

 "name" in user {
    if(printuser) {
        print out;
    }

    delete user;
    printuser = 0;
    out = output;
    next;
}

END {
    if(printuser) {
        print out;
    }
}

