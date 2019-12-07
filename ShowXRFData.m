function ShowXRFData(xrf_data)

    global pos_num;
    global xrf_data121;
    
    xrf_data121 = zeros(121,1);
    print_data = zeros(11,11);
    for i = 1:11
        for j = 1:11
            print_data(i,j) = xrf_data((i-1)*11 + j);
            if pos_num(i,j) == 0
                continue;
            end
            xrf_data121(pos_num(i,j)) = xrf_data((i-1)*11 + j);
        end
    end
    
    print_data

end