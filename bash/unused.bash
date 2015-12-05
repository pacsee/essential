# Change terminal window and tab name
function tabname {
  printf "\e]1;$1\a"
}

function winname {
  printf "\e]2;$1\a"
}
# OSX: Quit an application from the command line
quit () {
    for app in $*; do
        osascript -e 'quit app "'$app'"'
    done
}

# OSX: Pass 0 or 1 to hide or show hidden files in Finder
function showhidden() {
    defaults write com.apple.Finder AppleShowAllFiles $1
    killall Finder
}

# OSX: show postscript rendered man page in Preview
function pman () {
    # just using builtins (but Preview pops up a conversion dialog)
    # man -t $@ | open -f -a /Applications/Preview.app

    # or convert using ps2pdf, requires "brew install ghostscript"
    man -t $@ | ps2pdf - - | open -f -a /Applications/Preview.app
}


