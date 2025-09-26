# make_function
# A utility function to create and save other fish functions.
#
# Usage:
#   make_function <name> '<body>' ['<description>']
#
# Example with description:
#   make_function ll 'ls -ahF' 'Lists files with details'
#
# This will create a new file at ~/.config/fish/functions/ll.fish
# making the 'll' function available permanently.

function make_function
    # Check if both a name and a body for the function were provided.
    if test (count $argv) -lt 2
        echo "Error: Missing arguments."
        echo "Usage: make_function <name> '<body>' ['<description>']"
        return 1
    end

    set -l function_name $argv[1]
    set -l function_body $argv[2]
    set -l function_description $argv[3] # Optional third argument
    set -l function_dir ~/.config/fish/functions
    set -l function_path $function_dir/$function_name.fish

    # Automatically append '$argv' to pass arguments to the command,
    # unless the user has already specified how to handle them.
    if not string match --quiet -- "*\$argv*" "$function_body"
        set function_body "$function_body \$argv"
    end

    # Create the standard fish functions directory if it doesn't exist.
    if not test -d $function_dir
        mkdir -p $function_dir
    end

    # Write the function definition to its own file.
    echo "function $function_name" > $function_path
    
    # Add the description as a comment if it was provided.
    if test -n "$function_description"
        echo "    # $function_description" >> $function_path
    end

    echo "    $function_body" >> $function_path
    echo "end" >> $function_path

    # Source the new file to make the function available in the current session.
    source $function_path

    echo "Successfully created and saved function '$function_name'."
    echo "It is now available permanently."
    echo "File created at: $function_path"
end


