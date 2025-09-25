if status is-interactive
    # Commands to run in interactive sessions can go here
end
fastfetch
set -g fish_greeting
starship init fish | source
# added path for go
fish_add_path /usr/local/go/bin
