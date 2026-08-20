function local_dev --description "Pick a project and launch a local Zellij session"
    # Capture the output of your project_picker
    set TARGET_DIR (project_picker)
    
    # Check if a project was actually selected
    if test -z "$TARGET_DIR"
        echo "No project selected."
        return 0
    end
    
    # Change into the target directory
    cd "$TARGET_DIR"
    
    # Extract the folder name to use as the Zellij session name
    set SESSION_NAME (basename "$TARGET_DIR")
    
    # Attach to or create the Zellij session with your mobile layout
    zellij --layout mobile-dev attach -c "$SESSION_NAME"
end

