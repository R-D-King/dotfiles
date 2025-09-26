# make_function
# A utility function to create and save other fish functions.
#
# Usage:
#   make_function <new_function_name> '<commands_to_run_in_quotes>'
#
# Example:
#   make_function ll 'ls -ahF'
#
# This will create a new file at ~/.config/fish/functions/ll.fish
# making the 'll' function available permanently.
#
# It automatically passes along any arguments you provide.
# For example, `ll my_folder` will work as expected.

function make_function
    # Check if both a name and a body for the function were provided.
    if test (count $argv) -lt 2
        echo "Error: Missing arguments."
        echo "Usage: make_function <name> '<body>'"
        return 1
    end

    set -l function_name $argv[1]
    set -l function_body $argv[2]
    set -l function_dir ~/.config/fish/functions
    set -l function_path $function_dir/$function_name.fish

    # Automatically append '$argv' to pass arguments to the command,
    # unless the user has already specified how to handle them.
    # This makes creating simple aliases very easy.
    if not string match --quiet -- "*\$argv*" "$function_body"
        set function_body "$function_body \$argv"
    end

    # Create the standard fish functions directory if it doesn't exist.
    if not test -d $function_dir
        mkdir -p $function_dir
    end

    # Write the function definition to its own file.
    # This makes the function permanent.
    echo "function $function_name" > $function_path
    echo "    $function_body" >> $function_path
    echo "end" >> $function_path

    # Source the new file to make the function available in the current session.
    source $function_path

    echo "Successfully created and saved function '$function_name'."
    echo "It is now available permanently."
    echo "File created at: $function_path"
end


