function fish_right_prompt
    set ps $pipestatus
    #Split the list of process exit codes (PECs) by newline and strip extra whitespace
    set ps_list (echo $ps | awk -F' ' '{gsub(/^[ \t]+|[ \t]+$/,""); print $0}' | awk '{gsub(" ","\n"); print $0}' )
    #track if the process chain was "clean", i.e. all 0
    set clean 1
    #if any process exits dirty other than the last process, set mid_chain_err to indicate
    set mid_chain_err ""
    #get number of PECs
    set last_ec (count $ps_list)
    #loop index
    set ec_i 1
    for ec in $ps_list
        #if we find a dirty exit, set the appropriate variables and break - don't need to look at all PECs
        if [ "$ec" != "0" ]
            set clean 0
            if [ $ec_i -ne $last_ec ]
                set mid_chain_err "*"
            end
            break
        end
        set ec_i (math $ec_i + 1)
    end
    if [ $clean -eq 0  ] 
        #get the last PEC to print 
        set ps (echo $ps | awk -F' ' '{ print $NF }')
        echo -n -e (set_color ff0000)"[$ps$mid_chain_err]" (set_color normal)
    else
        #if everything was clean, don't show anything
        echo -n ""
    end

end

