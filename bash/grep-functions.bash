export GREP_COLORS="ms=1;33:fn=32:ln=1;32:se=0;37"

# recursive search in files
function grp {
    GREP_OPTIONS="-rIn --color --exclude-dir=\.bzr --exclude-dir=\.git --exclude-dir=\.hg --exclude-dir=\.svn --exclude=tags $GREP_OPTIONS" grep "$@"
}

# recursive search in Python source
function grpy {
    GREP_OPTIONS="--exclude-dir=build --exclude-dir=dist --include=*.py $GREP_OPTIONS" grp "$@"
}

# recursive search in files, do not follow symlinks
function grpns {
    find . \( -name .git -o -name .bzr -o -name .hg -o -name .svn \) -prune -o -type f -a -exec \
        grep -IHn --color "$@" '{}' \;
}


