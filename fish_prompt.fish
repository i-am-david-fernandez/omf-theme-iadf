function __iadf_init_prompt
    set -q theme_iadf_context; or set -g theme_iadf_context ""

    set -q theme_iadf_vcs_list; or set -g theme_iadf_vcs_list git svn hg

    set -q theme_iadf_vcs_colour_dirty; or set -g theme_iadf_vcs_colour_dirty "red"
    set -q theme_iadf_vcs_colour_clean; or set -g theme_iadf_vcs_colour_clean "green"

    set -q theme_iadf_vcs_colour_branch; or set -g theme_iadf_vcs_colour_branch "blue"

    set -q theme_iadf_vcs_glyph_untracked; or set -g theme_iadf_vcs_glyph_untracked "?"
    set -q theme_iadf_vcs_colour_untracked; or set -g theme_iadf_vcs_colour_untracked "yellow"

    set -q theme_iadf_vcs_glyph_missing; or set -g theme_iadf_vcs_glyph_missing "!"
    set -q theme_iadf_vcs_colour_missing; or set -g theme_iadf_vcs_colour_missing "red"

    set -q theme_iadf_vcs_glyph_modified; or set -g theme_iadf_vcs_glyph_modified "±"
    set -q theme_iadf_vcs_colour_modified; or set -g theme_iadf_vcs_colour_modified "green"
end


function __iadf_vcs_reset
    set -g __vcs_present 0
    set -g __vcs_branch ""
    set -g __vcs_dirty 0
    set -g __vcs_untracked 0
    set -g __vcs_missing 0
    set -g __vcs_modified 0
end

function __iadf_vcs_refresh_git

    __iadf_vcs_reset

    set info (command git branch --no-color ^ /dev/null)

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

    for line in (command git status --porcelain ^ /dev/null)
        ## Test for an untracked file
        if string match --quiet --regex "^\?\?" $line
            set __vcs_untracked 1
        end

        ## Test for a missing file
        if string match --quiet --regex "^\s*D" $line
            set __vcs_missing 1
            set __vcs_dirty 1
        end

        ## Test for a modified file
        if string match --quiet --regex "^\s*M" $line
            set __vcs_modified 1
            set __vcs_dirty 1
        end
    end
end

function __iadf_vcs_refresh_hg

    __iadf_vcs_reset

    set __vcs_branch (command hg branch ^ /dev/null)

    if test $status -ne 0
        return
    end

    set __vcs_present 1

    for line in (command hg status --color none)
        ## Test for an untracked file
        if string match --quiet --regex "^\?" $line
            set __vcs_untracked 1
        end

        ## Test for a missing file
        if string match --quiet --regex "^!" $line
            set __vcs_missing 1
            set __vcs_dirty 1
        end

        ## Test for a modified file
        if string match --quiet --regex "^M" $line
            set __vcs_modified 1
            set __vcs_dirty 1
        end
    end
end

function __iadf_vcs_refresh_svn

    __iadf_vcs_reset

    set info (command svn info ^ /dev/null)
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

    for line in (command svn status)
        ## Test for an untracked file
        if string match --quiet --regex "^\?" $line
            set __vcs_untracked 1
        end

        ## Test for a missing file
        if string match --quiet --regex "^!" $line
            set __vcs_missing 1
            set __vcs_dirty 1
        end

        ## Test for a modified file
        if string match --quiet --regex "^M" $line
            set __vcs_modified 1
            set __vcs_dirty 1
        end
    end
end

function __iadf_show_prompt_for_vcs --argument vcs_type

    set_color brblack
    echo -n "["
    if test $__vcs_dirty -gt 0
        set_color $theme_iadf_vcs_colour_dirty
    else
        set_color $theme_iadf_vcs_colour_clean
    end
    echo -n "$vcs_type: "
    set_color normal

    set_color $theme_iadf_vcs_colour_branch
    echo -n "$__vcs_branch "

    if test $__vcs_untracked -gt 0
        set_color $theme_iadf_vcs_colour_untracked
        echo -n "$theme_iadf_vcs_glyph_untracked"
    end

    if test $__vcs_missing -gt 0
        set_color $theme_iadf_vcs_colour_missing
        echo -n "$theme_iadf_vcs_glyph_missing"
    end

    if test $__vcs_modified -gt 0
        set_color $theme_iadf_vcs_colour_modified
        echo -n "$theme_iadf_vcs_glyph_modified"
    end

    set_color brblack
    echo -n "]"
    set_color normal
end

function __iadf_show_prompt_for_path
    set path (prompt_pwd)
    set_color white
    echo -n "$path "
    set_color normal
end

function __iadf_show_prompt_for_docker
    if test -e "/.dockerenv"
        set_color cyan
        echo -n "DOCKED "
    end
end

function __iadf_show_prompt_for_user_host
    set -l hostname (hostname)
    set_color brblack
    echo -ns (whoami) '@' $hostname ' '
end


function fish_prompt
    # Customize the prompt

    __iadf_init_prompt

    __iadf_show_prompt_for_docker

    __iadf_show_prompt_for_user_host

    if test -n $theme_iadf_context
        set_color blue
        echo -n "[$theme_iadf_context] "
    end

    __iadf_show_prompt_for_path

    for vcs in $theme_iadf_vcs_list
        eval __iadf_vcs_refresh_$vcs
        if test $__vcs_present -ne 0
            eval __iadf_show_prompt_for_vcs $vcs
        end
    end

    echo " > "
end
