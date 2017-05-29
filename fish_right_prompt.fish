function __iadf_start_segment_right -a colour
    if set -q __iadf_segment_colour
        set_color normal
        set_color -b $__iadf_segment_colour $colour
        echo -n $theme_iadf_segment_right_glyph
    end

    set -g __iadf_segment_colour $colour
    set_color -b $colour
end


function __iadf_show_prompt_status -a real_status
    if test $real_status -ne 0
        __iadf_start_segment_right red
        set_color black
        echo -n "$real_status"
    end
end


function __iadf_show_prompt_datetime
    __iadf_start_segment_right $theme_iadf_segment_colour_datetime
    set_color $theme_iadf_text_colour_datetime
    date +"$theme_iadf_format_datetime"
end


function fish_right_prompt
    ## Store _actual_ current status for later use
    set -l real_status $status

    __iadf_init_prompt

    set_color normal
    set_color yellow
    echo "$theme_iadf_right_glyph"

    __iadf_start_segment_right 000

    if test -n $theme_iadf_feature_status
        __iadf_show_prompt_status $real_status
    end

    if test -n $theme_iadf_feature_datetime
        __iadf_show_prompt_datetime
    end

    set_color normal
end
