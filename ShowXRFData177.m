function ShowXRFData177(xrf_data)

    global pos_num_bkgd;
    global xrf_data177;
    
    xrf_data177 = zeros(225,1);
    print_data = zeros(15,15);
    for i = 1:15
        for j = 1:15
            print_data(i,j) = xrf_data((i-1)*15 + j);
            if pos_num_bkgd(i,j) == 0
                continue;
            end
            xrf_data177(pos_num_bkgd(i,j)) = xrf_data((i-1)*15 + j);
        end
    end
    
    print_data

end