function ShowXRFData177(xrf_data)

    print_data = zeros(15,15);
    for i = 1:15
        for j = 1:15
            print_data(i,j) = xrf_data((i-1)*15 + j);
        end
    end
    
    print_data

end