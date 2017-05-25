function __iadf_init_prompt
    set -q theme_iadf_context; or set -g theme_iadf_context ""

    set -q theme_iadf_vcs_list; or set -g theme_iadf_vcs_list git svn hg

    set -q theme_iadf_colour_vcs; or set -g theme_iadf_colour_vcs 000

    set -q theme_iadf_vcs_colour_dirty; or set -g theme_iadf_vcs_colour_dirty "red"
    set -q theme_iadf_vcs_colour_clean; or set -g theme_iadf_vcs_colour_clean "green"

    set -q theme_iadf_vcs_colour_branch; or set -g theme_iadf_vcs_colour_branch "blue"

    set -q theme_iadf_vcs_glyph_untracked; or set -g theme_iadf_vcs_glyph_untracked "?"
    set -q theme_iadf_vcs_colour_untracked; or set -g theme_iadf_vcs_colour_untracked "yellow"

    set -q theme_iadf_vcs_glyph_missing; or set -g theme_iadf_vcs_glyph_missing "!"
    set -q theme_iadf_vcs_colour_missing; or set -g theme_iadf_vcs_colour_missing "red"

    set -q theme_iadf_vcs_glyph_modified; or set -g theme_iadf_vcs_glyph_modified "±"
    set -q theme_iadf_vcs_colour_modified; or set -g theme_iadf_vcs_colour_modified "green"

    set -e __iadf_segment_colour

    set -g __theme_iadf_segment_left_glyph \uE0B0
    set -g __theme_iadf_segment_right_glyph \uE0B2

    set -g __theme_iadf_left_glyph \uE0B1
    set -g __theme_iadf_right_glyph \uE0B3

    set_color normal
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

    for line in (command git status --porcelain)
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

    __iadf_start_segment_left $theme_iadf_colour_vcs

    set_color brblack
    echo -n "["
    if test $__vcs_dirty -gt 0
        set_color $theme_iadf_vcs_colour_dirty
    else
        set_color $theme_iadf_vcs_colour_clean
    end
    echo -n "$vcs_type "

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
end

# function __iadf_show_segment_boundary_left -a colour_left -a colour_right
#     set_color -b $colour_right $colour_left
#     echo -n \uE0B0
#     set_color normal
# end

function __iadf_start_segment_left -a colour
    set_color normal
    if set -q __iadf_segment_colour
        set_color -b $colour $__iadf_segment_colour
        echo -n $__theme_iadf_segment_left_glyph
    end

    set -g __iadf_segment_colour $colour
    set_color -b $colour
end

function __iadf_show_prompt_for_path
    set path (prompt_pwd)
    __iadf_start_segment_left blue
    echo -n "$path"
end

function __iadf_show_prompt_for_docker
    if test -e "/.dockerenv"
        __iadf_start_segment_left cyan
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
            __iadf_show_prompt_for_vcs $vcs
        end
    end

    __iadf_start_segment_left normal

    set_color normal
    set_color yellow
    echo "$__theme_iadf_left_glyph "
end
