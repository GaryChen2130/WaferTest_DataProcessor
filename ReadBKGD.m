function ReadBKGD(file_path,sheet_name)

    global number_bkgd;
    
    % For rs11
    [number_bkgd, text, rawData] = xlsread(file_path,sheet_name,'A1:FV800');

end