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

An addressbook file must end with a separator, otherwise the last contact may
be ignored.

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

There is only one subcommand for now : `get`.

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

## Abook compatibility
The addressbook format is almost perfectly compatible with the abook[1] one.
The only difference is that the last contact may be ignored, so a separator
must be added at the end of the abook addressbook file.

## Examples
 - `acm.rb get email ".*@gmail.com" "{name} ({phone})"` shows the name and
    phone number of all the contacts with a gmail address.


[1] http://abook.sourceforge.net/
