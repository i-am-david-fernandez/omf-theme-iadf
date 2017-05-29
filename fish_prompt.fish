function __iadf_init_prompt

    ## Left-side features
    set -q theme_iadf_feature_context; or set -g theme_iadf_feature_context ""
    set -q theme_iadf_feature_docker; or set -g theme_iadf_feature_docker ""
    set -q theme_iadf_feature_userhost; or set -g theme_iadf_feature_userhost ""
    set -q theme_iadf_feature_path; or set -g theme_iadf_feature_path ""
    set -q theme_iadf_feature_vcs; or set -g theme_iadf_feature_vcs ""
    ## Left-side colours
    set -q theme_iadf_segment_colour_context; or set -g theme_iadf_segment_colour_context "green"
    set -q theme_iadf_text_colour_context; or set -g theme_iadf_text_colour_context "brblack"
    set -q theme_iadf_segment_colour_userhost; or set -g theme_iadf_segment_colour_userhost "black"
    set -q theme_iadf_text_colour_userhost; or set -g theme_iadf_text_colour_userhost "brblack"
    set -q theme_iadf_segment_colour_path; or set -g theme_iadf_segment_colour_path "blue"
    set -q theme_iadf_text_colour_path; or set -g theme_iadf_text_colour_path "white"
    set -q theme_iadf_segment_colour_docker; or set -g theme_iadf_segment_colour_docker "cyan"
    set -q theme_iadf_text_colour_docker; or set -g theme_iadf_text_colour_docker "black"
    set -q theme_iadf_segment_colour_vcs; or set -g theme_iadf_segment_colour_vcs "black"

    ## Right-side features
    set -q theme_iadf_feature_status; or set -g theme_iadf_feature_status "enable"
    set -q theme_iadf_feature_datetime; or set -g theme_iadf_feature_datetime "enable"
    ## Right-side colours
    set -q theme_iadf_segment_colour_datetime; or set -g theme_iadf_segment_colour_datetime "blue"
    set -q theme_iadf_text_colour_datetime; or set -g theme_iadf_text_colour_datetime "white"


    set -q theme_iadf_format_datetime; or set -g theme_iadf_format_datetime "%H:%M:%S"
    set -q theme_iadf_context; or set -g theme_iadf_context ""

    ## VCS feature configuration
    #set -q theme_iadf_vcs_list; or set -g theme_iadf_vcs_list git svn hg
    set -q theme_iadf_vcs_list; or set -g theme_iadf_vcs_list git svn

    set -q theme_iadf_vcs_colour_dirty; or set -g theme_iadf_vcs_colour_dirty "red"
    set -q theme_iadf_vcs_colour_clean; or set -g theme_iadf_vcs_colour_clean "green"

    set -q theme_iadf_vcs_colour_branch; or set -g theme_iadf_vcs_colour_branch "blue"

    set -q theme_iadf_vcs_glyph_untracked; or set -g theme_iadf_vcs_glyph_untracked "?"
    set -q theme_iadf_vcs_colour_untracked; or set -g theme_iadf_vcs_colour_untracked "yellow"

    set -q theme_iadf_vcs_glyph_missing; or set -g theme_iadf_vcs_glyph_missing "!"
    set -q theme_iadf_vcs_colour_missing; or set -g theme_iadf_vcs_colour_missing "red"

    set -q theme_iadf_vcs_glyph_modified; or set -g theme_iadf_vcs_glyph_modified "±"
    set -q theme_iadf_vcs_colour_modified; or set -g theme_iadf_vcs_colour_modified "green"

    set -g theme_iadf_segment_left_glyph \uE0B0
    set -g theme_iadf_segment_right_glyph \uE0B2

    set -g theme_iadf_left_glyph \uE0B1
    set -g theme_iadf_right_glyph \uE0B3

    set_color normal

    set -e __iadf_segment_colour
    set -g __theme_iadf_prompt_left ""
end

function __iadf_append_prompt
    #set __theme_iadf_prompt_left "$__theme_iadf_prompt_left"(echo $argv)
    echo $argv
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
        echo -n $theme_iadf_segment_left_glyph
    end

    set -g __iadf_segment_colour $colour
    set_color -b $colour
end


function __iadf_show_prompt_context
    if test -n $theme_iadf_context
        __iadf_start_segment_left $theme_iadf_segment_colour_context
        set_color $theme_iadf_text_colour_context
        echo -n $theme_iadf_context
    end
end


function __iadf_show_prompt_for_docker
    if test -e "/.dockerenv"
        __iadf_start_segment_left $theme_iadf_segment_colour_docker
        set_color $theme_iadf_text_colour_docker
        echo -n "DOCKED "
    end
end


function __iadf_show_prompt_for_user_host
    set -l hostname (hostname)
    __iadf_start_segment_left $theme_iadf_segment_colour_userhost
    set_color $theme_iadf_text_colour_userhost
    echo -ns (whoami) '@' $hostname ' '
end


function __iadf_show_prompt_for_path
    set path (prompt_pwd)
    __iadf_start_segment_left $theme_iadf_segment_colour_path
    set_color $theme_iadf_text_colour_path
    echo -n "$path"
end


function __iadf_vcs_reset -d "Reset vcs state variables"
    set -g __vcs_present 0
    set -g __vcs_branch ""
    set -g __vcs_dirty 0
    set -g __vcs_untracked 0
    set -g __vcs_missing 0
    set -g __vcs_modified 0
end


function __iadf_vcs_refresh_git -d "Set vcs state variables for git in the current directory."

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


function __iadf_vcs_refresh_hg -d "Set vcs state variables for mercurial in the current directory."

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


function __iadf_vcs_refresh_svn -d "Set vcs state variables for subversion in the current directory."

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


function __iadf_show_prompt_for_vcs_type --argument vcs_type

    __iadf_start_segment_left $theme_iadf_segment_colour_vcs

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


function __iadf_show_prompt_for_vcs
    for vcs in $theme_iadf_vcs_list
        eval __iadf_vcs_refresh_$vcs
        if test $__vcs_present -ne 0
            __iadf_show_prompt_for_vcs_type $vcs
        end
    end
end


function fish_prompt
    # Customize the prompt

    __iadf_init_prompt

    if test -n $theme_iadf_feature_context
        __iadf_show_prompt_context
    end

    if test -n $theme_iadf_feature_docker
        __iadf_show_prompt_for_docker
    end

    if test -n $theme_iadf_feature_userhost
        __iadf_show_prompt_for_user_host
    end

    if test -n $theme_iadf_feature_path
        __iadf_show_prompt_for_path
    end

    if test -n $theme_iadf_feature_vcs
        __iadf_show_prompt_for_vcs
    end

    __iadf_start_segment_left normal

    if test (string length $__theme_iadf_prompt_left) -gt 180
        echo ""
    end

    set_color normal
    set_color yellow
    echo "$theme_iadf_left_glyph "
end
