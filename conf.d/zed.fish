status is-interactive || exit
set -q ZED_TERM || exit

set -q ZED_TERM_WRAPPED || begin
    # uninherit variables
    set -l all_vars
    set -l zed_vars TERM SHELL
    set -l non_zed_vars
    set -l env_cmd
    set -S | while read -L line
        if string match -qr '^\$(?<var>\w+)\[\d+\]: \|(?<val>.*?)\|$' -- $line
            if not contains $var $all_vars
                set -a all_vars $var
            end
            if string match -rq '(^|\W|_)ZED(_|\W|$)' -- $var || string match -rq '(^|\W|_)Zed(_|\W|$)' -- $val
                if not contains $var $zed_vars
                    set -a zed_vars $var
                end
            end
        end
    end
    for var in $all_vars
        if not contains $var $zed_vars
            set -a non_zed_vars $var
        end
    end
    set -l exec_cmd ZED_TERM_WRAPPED=1 exec env
    for var in $non_zed_vars
        set -a exec_cmd "-u $var"
    end
    set -a exec_cmd $SHELL -il
    eval $exec_cmd
end
