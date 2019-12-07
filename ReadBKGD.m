function ReadBKGD(file_path,sheet_name)

    global number_bkgd;
    
    % For rs11 & rs12
    [number_bkgd, text, rawData] = xlsread(file_path,sheet_name,'A2:FV801');

end