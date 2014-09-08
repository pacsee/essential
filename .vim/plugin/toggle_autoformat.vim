
if has('python')

python <<EOF

autoformat = False

def toggle_autoformat():
    global autoformat
    autoformat = not autoformat
    if autoformat:
        cmds = [
            "setlocal formatoptions+=a",
            "setlocal textwidth=80",
            "setlocal spell spelllang=en_gb",
            "setlocal nonumber",
            "colorscheme morning",
        ]
    else:
        cmds = [
            "setlocal formatoptions-=a",
            "setlocal textwidth=0",
            "setlocal nospell",
            "setlocal number",
            "colorscheme blackdev",
        ]
    for cmd in cmds:
        vim.command(cmd)
    print "autoformat:", autoformat

EOF

endif

