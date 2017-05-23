function __iadf_show_segment_boundary_right -a colour_left -a colour_right
    set_color -b $colour_left $colour_right
    echo -n \uE0B2
    set_color normal
end

function fish_right_prompt
    # Customize the right prompt

    ## Store _actual_ current status for later use
    set -l real_status $status

    set_color normal
    set_color yellow
    echo "$__theme_iadf_right_glyph "

    __iadf_show_segment_boundary_right 000 yellow
    __iadf_show_segment_boundary_right yellow blue
    set_color -b blue

    if test $real_status -ne 0
        set_color red
        echo -n "$real_status "
    end

    #set_color --dim white
    date +"%H:%M:%S"
    set_color normal
end
