# function __iadf_show_segment_boundary_right -a colour_left -a colour_right
#     set_color -b $colour_left $colour_right
#     echo -n \uE0B2
#     set_color normal
# end

function __iadf_start_segment_right -a colour
    if set -q __iadf_segment_colour
        set_color normal
        set_color -b $__iadf_segment_colour $colour
        echo -n $__theme_iadf_segment_right_glyph
    end

    set -g __iadf_segment_colour $colour
    set_color -b $colour
end


function fish_right_prompt
    # Customize the right prompt

    ## Store _actual_ current status for later use
    set -l real_status $status

    __iadf_init_prompt

    set_color normal
    set_color yellow
    echo "$__theme_iadf_right_glyph "

    __iadf_start_segment_right 000

    if test $real_status -ne 0
        __iadf_start_segment_right red
        set_color black
        echo -n "$real_status"
    end

    __iadf_start_segment_right blue
    set_color white
    date +"%H:%M:%S"

    set_color normal
end
