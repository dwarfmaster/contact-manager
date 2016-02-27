# ACM : Awk Contact Manager
acm.sh is an interface for a set of awk scripts to handle contacts.

## Storing contacts
acm search for contact files in this order :
 - `$ACM_ADDRESSBOOK`
 - `$XDG_DATA_HOME/acm/`
 - `$HOME/.acm/`
 - `$HOME/.abook/addressbook`

If any of these is a directory, acm will concatenate all the non-hidden regular
files found within this directory, allowing to split contact storage in
multiples files.

An entry has the format `key=value` or `key=value1,value2...`. Any non empty
line which does not contact a `=` is considered a separator, thus indicating
a new contact.

A contact example :
```
-----
name=Boss
email=boss@company.org,boss@mailoo.org
city=Somewhere
phone=0000666000
tag=work,master
-----
```

## Commands
Each subcommand correspond to an awk script. Each script can accomplish a
different task.

There are only two subcommand for now : `get` and `birth`

### Get
This script accept two arguments and an optionnal third. The first argument
designate a key, and the second a regex. Each contact having the key will have
its value matched against the regex. If it validates, the contact is printed.
In case of a key with multiple values, the regex is matched against every
value.

The third argument designate how the contact is printed. It is a string in
which every `{key}` will be replaced by the value for this contact. There is a
special key, `filename`, which is the path to the addressbook file containing
the contact. This is mostly useful for those with multiple contact files.

### Birth
This utility is aiming to ease the extraction of birthdays (or generally any
kind of date) from the contact fields. When invoked, it extracts the date
in format `YYYY-MM-DD` from the birthday fields, an inject the values in
an output file.

The script has three arguments, all optionals. The first one is the output
file. It must be either a file path or `-`, in which case the output will be
stdout (the default value). The second argument is the key in which the date
is read, the default value being `birthday`. Finally, the third argument is the
output format. The output format is a string in which every occurrence of
`#day`, `#month`, `#monthname`, `#year` and `#name` will be replaced
respectively by the number in month of the day, the number of the month, the
three letter long month name, the year and the name of the contact, with a line
of output per contact. The default value is :
    `REM #day #monthname MSG #name anniversary : [since(#year)] year old`

## Abook compatibility
The addressbook format is perfectly compatible with the abook[1] one.

## Examples
 - `acm.rb get email ".*@gmail.com" "{name} ({phone})"` shows the name and
    phone number of all the contacts with a gmail address.
 - Used with its default values, `acm birth` extracts birthdays of contacts
    and writes to `STDOUT` commands for the `remind`[2] program.


[1] http://abook.sourceforge.net/
[2] https://www.roaringpenguin.com/products/remind

