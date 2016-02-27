#!/usr/bin/ruby

# Misc function
def usage
    puts <<END_OF_STRING
Usage : acm subcommand [subcommand arguments]
Available subcommands :
    - get : list contacts maching criteria
    - birth : save contacts birthdays to a remind file
END_OF_STRING
end

# Path to the awk scripts
$path = "."
# Paths to addressbooks, in order of priority
$addressbooks = [
    ENV["ACM_ADDRESSBOOK"],
    "#{ENV["XDG_DATA_HOME"]}/acm",
    "#{ENV["HOME"]}/.acm",
    "#{ENV["HOME"]}/.abook/addressbook"
]

# Find addressbook files
$files = Array.new
$addressbooks.each do |abook|
    if abook.nil?
        next
    end
    if File.file?(abook)
        $files = [abook]
        break
    elsif File.directory?(abook)
        Dir.foreach(abook) do |file|
            path = "#{abook}/#{file}"
            if File.file?(path) and file[0] != "."
                $files << path
            end
        end
        break
    end
end
if $files.empty?
    puts "No addressbook found !"
    exit
end

# Decide what to do
if ARGV.length == 0
    puts "No subcommand"
    usage
    exit
end

case ARGV[0]
when "get"
    ARGV.shift
    $exe = "#{$path}/get.awk"
    if ARGV.nil?
        Kernel::exec($exe, "--", *$files)
    else
        Kernel::exec($exe, *ARGV, "--", *$files)
    end
when "birth"
    ARGV.shift
    $exe = "#{$path}/birth.pl"
    if ARGV.nil?
        Kernel::exec($exe)
    else
        Kernel::exec($exe, *ARGV)
    end
else
    puts "Invalid subcommand"
    usage
    exit
end

