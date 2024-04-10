status is-interactive || exit
set -q ZED_TERM || exit

set -q ZED_TERM_WRAPPED || begin
    # uninherit variables
    set -l vars
    set -l env_cmd
    set -S | while read -L line
        if string match -qr '^\$(?<var>\w+)\[\d+\]: \|(?<val>.*?)\|$' -- $line
            if string match -irq '(^|\W|_)zed(_|\W|$)' -- $var $val
                set -a vars $var
            end
        end
    end
    for var in $vars
        set -l set_cmd
        set -l val $$var
        for i in (seq (count $val))
            set -a set_cmd \""$val[$i]\""
        end
        if set -qx $var
            set -p set_cmd set -gx $var
        else
            set -p set_cmd set -g $var
        end
        set -a env_cmd "$set_cmd;"
    end
    exec env -i TERM=$TERM SHELL=$SHELL ZED_TERM_WRAPPED=1 $SHELL -il -C "$env_cmd"
end
