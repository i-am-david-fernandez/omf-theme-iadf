function vcs_reset
    set -g __vcs_present 0
    set -g __vcs_branch ""
    set -g __vcs_dirty 0
    set -g __vcs_untracked 0
    set -g __vcs_missing 0
    set -g __vcs_modified 0
end

function vcs_refresh_git
    #echo "Refreshing git"

    vcs_reset

    set info (git branch --no-color ^ /dev/null)

    if test $status -ne 0
        return
    end
    for line in $info
        ## Test for "* <branch>"
        if string match --quiet --regex "\* " $line
            set __vcs_branch (string sub --start 3 "$line")[-1]
        end
    end

    set __vcs_present 1

    for line in (git status --porcelain)
        ## Test for an untracked file
        if string match --quiet --regex "^\?\?" $line
            #set __vcs_untracked (math $__vcs_untracked + 1)
            set __vcs_untracked 1
        end

        ## Test for a missing file
        if string match --quiet --regex "^\s*D" $line
            #set __vcs_missing (math $__vcs_missing + 1)
            set __vcs_missing 1
            set __vcs_dirty 1
        end

        ## Test for a modified file
        if string match --quiet --regex "^\s*M" $line
            #set __vcs_modified (math $__vcs_modified + 1)
            set __vcs_modified 1
            set __vcs_dirty 1
        end
    end
end

function vcs_refresh_hg
    #echo "Refreshing hg"

    vcs_reset

    set __vcs_branch (hg branch ^ /dev/null)

    if test $status -ne 0
        return
    end

    set __vcs_present 1

    for line in (hg status --color none)
        ## Test for an untracked file
        if string match --quiet --regex "^\?" $line
            #set __vcs_untracked (math $__vcs_untracked + 1)
            set __vcs_untracked 1
        end

        ## Test for a missing file
        if string match --quiet --regex "^!" $line
            #set __vcs_missing (math $__vcs_missing + 1)
            set __vcs_missing 1
            set __vcs_dirty 1
        end

        ## Test for a modified file
        if string match --quiet --regex "^M" $line
            #set __vcs_modified (math $__vcs_modified + 1)
            set __vcs_modified 1
            set __vcs_dirty 1
        end
    end
end

function vcs_refresh_svn
    #echo "Refreshing svn"

    vcs_reset

    set info (svn info ^ /dev/null)
    if test $status -ne 0
        return
    end

    set __vcs_present 1

    for line in $info
        ## Test for URL/"branch"
        if string match --quiet --regex "^URL:" $line
            set __vcs_branch (string split "/" "$line")[-1]
        end
    end

    for line in (svn status)
        ## Test for an untracked file
        if string match --quiet --regex "^\?" $line
            #set __vcs_untracked (math $__vcs_untracked + 1)
            set __vcs_untracked 1
        end

        ## Test for a missing file
        if string match --quiet --regex "^!" $line
            #set __vcs_missing (math $__vcs_missing + 1)
            set __vcs_missing 1
            set __vcs_dirty 1
        end

        ## Test for a modified file
        if string match --quiet --regex "^M" $line
            #set __vcs_modified (math $__vcs_modified + 1)
            set __vcs_modified 1
            set __vcs_dirty 1
        end
    end
end

function vcs_prompt --argument vcs_type

    set -l __iadf_vcs_colour_branch "blue"

    set -l __iadf_vcs_glyph_untracked "?"
    set -l __iadf_vcs_colour_untracked "yellow"

    set -l __iadf_vcs_glyph_missing "!"
    set -l __iadf_vcs_colour_missing "red"

    set -l __iadf_vcs_glyph_modified "±"
    set -l __iadf_vcs_colour_modified "green"

    set_color --dim white
    echo -n "["
    if test $__vcs_dirty -gt 0
        set_color red
    else
        set_color green
    end
    echo -n "$vcs_type: "
    set_color normal

    set_color $__iadf_vcs_colour_branch
    echo -n "$__vcs_branch "

    if test $__vcs_untracked -gt 0
        set_color $__iadf_vcs_colour_untracked
        echo -n "$__iadf_vcs_glyph_untracked"
    end

    if test $__vcs_missing -gt 0
        set_color $__iadf_vcs_colour_missing
        echo -n "$__iadf_vcs_glyph_missing"
    end

    if test $__vcs_modified -gt 0
        set_color $__iadf_vcs_colour_modified
        echo -n "$__iadf_vcs_glyph_modified"
    end

    set_color --dim white
    echo -n "]"
    set_color normal
end

function fish_prompt
    # Customize the prompt

    echo -n "$PWD "

    set -l vcses git svn hg
    for vcs in $vcses
        eval vcs_refresh_$vcs
        if test $__vcs_present -ne 0
            eval vcs_prompt $vcs
        end
    end

    echo " > "
end
