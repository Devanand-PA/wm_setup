# NOTE: These functions provide enhanced `cd` functionality for the interactive bash shell

# Helper function to manage history entries
_add_to_history() {
    local dir="$1"
    if [ -d "$dir" ] && ! grep -qFx "$dir" ~/.cd_history; then
        echo "$dir" >> ~/.cd_history
        echo "$dir added to history"
    fi
}

# Helper function to remove invalid history entries
_clean_history() {
    sed -i '/^$/d' ~/.cd_history
}

# Jump to new directory using find and fzf
j_n() {
    local new_dir
    new_dir=$(find "$HOME" -type d 2>/dev/null | fzf --preview='tree -C {}')
    
    if [ -n "$new_dir" ] && [ "$new_dir" != "$PWD" ]; then
        if [ -d "$new_dir" ]; then
            command cd "$new_dir" || return
            _add_to_history "$PWD"
        else
            sed -i "\|^${new_dir}$|d" ~/.cd_history
            _clean_history
            echo "$new_dir removed from history"
        fi
    fi
}

# Jump to directory from history using fzf
j() {
    local new_dir
    new_dir=$(fzf --height=10% --tac < ~/.cd_history)
    
    if [ -n "$new_dir" ] && [ "$new_dir" != "$PWD" ]; then
        if [ -d "$new_dir" ]; then
            command cd "$new_dir" || return
            _add_to_history "$PWD"
        else
            sed -i "\|^${new_dir}$|d" ~/.cd_history
            _clean_history
            echo "$new_dir removed from history"
        fi
    fi
}

# Switch back to previous directory
k() {
    if [ -n "$old_dir" ] && [ -d "$old_dir" ]; then
        local curr_dir="$old_dir"
        old_dir=$PWD
        command cd "$curr_dir" || return
        _add_to_history "$PWD"
    else
        echo "No valid previous directory" >&2
        return 1
    fi
}

# Quick history navigation
h() {
    local new_dir
    new_dir=$(fzf --tac < ~/.cd_history)
    
    if [ -n "$new_dir" ] && [ "$new_dir" != "$PWD" ]; then
        old_dir=$PWD
        command cd "$new_dir" || return
        _add_to_history "$PWD"
    fi
}

# Enhanced cd with history tracking
cd() {
    local new_dir="" args=() old_pwd="$PWD"
    
    while [ $# -gt 0 ]; do
        case "$1" in
            --)
                args+=("$1")
                shift
                break
                ;;
            -*)
                args+=("$1")
                ;;
            *)
                new_dir="$1"
                ;;
        esac
        shift
    done
    args+=("$@")
    
    # Use HOME if no directory specified
    new_dir="${new_dir:-$HOME}"
    
    # Resolve absolute path
    local resolved_dir
    if ! resolved_dir=$(realpath "$new_dir" 2>/dev/null); then
        echo "cd: $new_dir: No such file or directory" >&2
        return 1
    fi
    
    # Perform the cd operation
    if command cd "${args[@]}" "$new_dir"; then
        old_dir="$old_pwd"
        _add_to_history "$old_dir"
        _add_to_history "$PWD"
    fi
}
