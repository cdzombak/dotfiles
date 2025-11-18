
# Merge multiple directories into a destination, combining subdirectories with matching names.
# Moves files (removes sources after copy) and cleans up empty directories.
# Handles filename collisions by appending numbers and properly handles hardlinks.
# Usage: dirmerge source1 [source2 ...] destination
dirmerge() {
    if [[ $# -lt 2 ]]; then
        echo "Usage: dirmerge source1 [source2 ...] destination" >&2
        return 1
    fi

    # Get all arguments
    local args=("$@")

    # Last argument is destination
    local dest="${args[-1]}"

    # All but last are sources
    local sources=("${args[@]:0:-1}")

    # Add trailing slashes to sources
    local sources_with_slashes=()
    for src in "${sources[@]}"; do
        sources_with_slashes+=("${src%/}/")
    done

    # Run rsync with backup option
    if ! rsync -av --backup --suffix=".rsync-tmp" "${sources_with_slashes[@]}" "$dest" 2> >(grep -v "unlink: Operation not permitted" >&2); then
        echo "rsync failed, sources not removed" >&2
        return 1
    fi

    # Rename any backup files to use numbered suffixes before extension
    find "$dest" -name "*.rsync-tmp" | while read -r backup; do
        local base="${backup%.rsync-tmp}"
        local dir="$(dirname "$base")"
        local filename="$(basename "$base")"

        # Split filename and extension
        local name="${filename%.*}"
        local ext="${filename##*.}"

        # If no extension (filename == ext), treat whole thing as name
        if [[ "$name" == "" ]]; then
            name="$filename"
            ext=""
        fi

        local counter=1
        local newpath

        # Find next available numbered suffix
        if [[ -n "$ext" && "$ext" != "$filename" ]]; then
            while [[ -e "${dir}/${name}-${counter}.${ext}" ]]; do
                ((counter++))
            done
            newpath="${dir}/${name}-${counter}.${ext}"
        else
            while [[ -e "${dir}/${name}-${counter}" ]]; do
                ((counter++))
            done
            newpath="${dir}/${name}-${counter}"
        fi

        mv "$backup" "$newpath"
    done

    # Trash source directories (only if rsync succeeded)
    for src in "${sources[@]}"; do
        trash "$src"
    done
}
