function project_picker --description "Switch to a project directory in Zellij"
    set -l query $argv[1]
    set -l ratio_threshold 3
    set -l projects_dir ~/projects

    # Check if ~/projects exists
    if not test -d $projects_dir
        echo "Error: ~/projects directory doesn't exist" >&2
        commandline -f repaint
        return 1
    end

    # Get all projects with zoxide scores, sorted by frecency
    # Query all zoxide entries (already sorted by score), filter to projects dir
    set -l results (
        zoxide query -l 2>/dev/null |
        rg "$projects_dir/" |
        string replace "$projects_dir/" "" |
        awk -F/ 'length($1) > 0 && !seen[$1]++ {print $1}'
    )

    # If no results from zoxide, fall back to fd listing with zero scores
    if test -z "$results"
        set results (fd --type d --max-depth 1 --base-directory $projects_dir)
    end

    # If still nothing, exit
    if test -z "$results"
        echo "No projects found in ~/projects" >&2
        commandline -f repaint
        return 1
    end

    set -l selected

    # Interactive FZF
    set selected (printf '%s\n' $results | fzf \
        --no-sort \
        --select-1 \
        --query="$query" \
        --prompt="  " \
        --height=40% \
        --border \
        --preview="eza --tree --level=2 --color=always $projects_dir/{} 2>/dev/null || ls -la $projects_dir/{}" \
        --preview-window=right:50%)

    # If nothing selected, exit and repaint
    if test -z "$selected"
        commandline -f repaint
        return 0
    end

    set -l project_path "$projects_dir/$selected"

    # Check if we're inside Zellij
    if not set -q ZELLIJ
        # If output is going to a terminal, we are running it directly.
        if test -t 1
            cd "$project_path"
            commandline -f repaint
        # If output is NOT a terminal, we are being captured by a variable.
        else
            echo "$project_path"
        end
        return 0
    end

    # Create a new Zellij tab with the project name
    zellij action new-tab --layout default --name "$selected" --cwd "$project_path"
    commandline -f repaint
end
