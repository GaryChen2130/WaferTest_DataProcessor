function ReadXRD(file_path,sheet_name)

    global number_xrd;
    global row_num;
    global col_num;
    
    % For rs7
    %[number_xrd, text, rawData] = xlsread(file_path,sheet_name,'A1:CW3342');
    %row_num = 3342;
    %col_num = 101;
    
    % For rs11 & sp7
    [number_xrd, text, rawData] = xlsread(file_path,sheet_name,'A1:CL1006');
    row_num = 1006;
    col_num = 90;
    
end