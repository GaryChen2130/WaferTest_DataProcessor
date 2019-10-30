function ReadXRF2

       %% Read in file
       
    global number_coka;
    global number_mgka;
    global number_mnka;
    global number_nika;
    global number_znka;
    
    % For rs7  
    %CoKafile = '../data_Tina/xrf/RS-7_CoKa.xlsm';
    %NiKafile = '../data_Tina/xrf/RS-7_NiKa.xlsm';
    %ZnKafile = '../data_Tina/xtf/RS-7_ZnKa.xlsm';
    
    %[number_coka, text_coka, rawData_coka] = xlsread(CoKafile,'RS-7_CoKa','A1:BY225');
    %[number_nika, text_nika, rawData_nika] = xlsread(NiKafile,'RS-7_NiKa','A1:BY225');
    %[number_znka, text_znka, rawData_znka] = xlsread(ZnKafile,'RS-7_ZnKa','A1:BY225');
    
    % For rs11   
    CoKafile = '../data_Xuyen/rs11_XRF/RS-11_CoKa.xlsm';
    MgKafile = '../data_Xuyen/rs11_XRF/RS-11_MgKa.xlsm';
    MnKafile = '../data_Xuyen/rs11_XRF/RS-11_MnKa.xlsm';
    NiKafile = '../data_Xuyen/rs11_XRF/RS-11_NiKa.xlsm';
    ZnKafile = '../data_Xuyen/rs11_XRF/RS-11_ZnKa.xlsm';
    
    [number_coka, text_coka, rawData_coka] = xlsread(CoKafile,'RS-11_CoKa','A1:BY225');
    [number_mgka, text_mgka, rawData_mgka] = xlsread(MgKafile,'RS-11_MgKa','A1:BY225');
    [number_mnka, text_mnka, rawData_mnka] = xlsread(MnKafile,'RS-11_MnKa','A1:BY225');
    [number_nika, text_nika, rawData_nika] = xlsread(NiKafile,'RS-11_NiKa','A1:BY225');
    [number_znka, text_znka, rawData_znka] = xlsread(ZnKafile,'RS-11_ZnKa','A1:BY225');
    
    % For sp7
    %CoKafile = '../data_Xuyen/sp7_XRF/SP-7_CoKa.xlsm';
    %MgKafile = '../data_Xuyen/sp7_XRF/SP-7_CrKa.xlsm';
    %MnKafile = '../data_Xuyen/sp7_XRF/SP-7_MnKa.xlsm';
    %NiKafile = '../data_Xuyen/sp7_XRF/SP-7_NiKa.xlsm';
    %ZnKafile = '../data_Xuyen/sp7_XRF/SP-7_FeKa.xlsm';
    
    %[number_coka, text_coka, rawData_coka] = xlsread(CoKafile,'SP-7_CoKa','A1:BY225');
    %[number_mgka, text_mgka, rawData_mgka] = xlsread(MgKafile,'SP-7_CrKa','A1:BY225');
    %[number_mnka, text_mnka, rawData_mnka] = xlsread(MnKafile,'SP-7_MnKa','A1:BY225');
    %[number_nika, text_nika, rawData_nika] = xlsread(NiKafile,'SP-7_NiKa','A1:BY225');
    %[number_znka, text_znka, rawData_znka] = xlsread(ZnKafile,'SP-7_FeKa','A1:BY225');
    
        %% Map XRF points to XRD points  (1mm, 1mm)/ (6.33mm, 6.33mm) 
    row_index = 152;
    col_index = 2;
    row_end = 152;
    col_end = 2;
    row_cnt = 152;
    col_cnt = 2;
    row_cnt_p = 152;
    col_cnt_p = 2;
    row_step = 8.02;

    global data_coka;
    global data_mgka;
    global data_mnka;
    global data_nika;
    global data_znka;
    
    cnt = 1;
    data_coka = zeros(1,121);
    data_mgka = zeros(1,121);
    data_mnka = zeros(1,121);
    data_nika = zeros(1,121);
    data_znka = zeros(1,121);

    while (row_index <= 225) && (col_index <= 77)
    
        while row_cnt - row_cnt_p < row_step
            row_end = row_end + 1;
            row_cnt = row_cnt + 1;
        end
    
        col_step = 9.02;
        while col_index <= 77
        
            while col_cnt - col_cnt_p < col_step
                col_end = col_end + 1;
                col_cnt = col_cnt + 1;
            end

            point_cnt = 0;
            row_tmp = row_index;
            while row_tmp < row_end
           
                col_tmp = col_index;
                while col_tmp < col_end
               
                    % Sum up all the value in given range
                    data_coka(cnt) = data_coka(cnt) + number_coka(row_tmp,col_tmp);
                    data_mgka(cnt) = data_mgka(cnt) + number_mgka(row_tmp,col_tmp);
                    data_mnka(cnt) = data_mnka(cnt) + number_mnka(row_tmp,col_tmp);
                    data_nika(cnt) = data_nika(cnt) + number_nika(row_tmp,col_tmp);
                    data_znka(cnt) = data_znka(cnt) + number_znka(row_tmp,col_tmp);
                
                    point_cnt = point_cnt + 1;
                    col_tmp = col_tmp + 1;
                    if col_tmp > 77
                        break;
                    end
                
                end
           
                row_tmp = row_tmp + 1;
                if row_tmp > 225
                    break;
                end
           
            end
        
            % Compute the average value
            data_coka(cnt) = data_coka(cnt)/point_cnt;
            data_mgka(cnt) = data_mgka(cnt)/point_cnt;
            data_mnka(cnt) = data_mnka(cnt)/point_cnt;
            data_nika(cnt) = data_nika(cnt)/point_cnt;
            data_znka(cnt) = data_znka(cnt)/point_cnt;
            cnt = cnt + 1;

            % Advance column index
            col_index = col_tmp;
            col_cnt_p = col_cnt_p + col_step;
            if mod(cnt,11) == 0
                col_step = 9.02;
            else
                col_step = 6.33;
            end
        
        end

    
        % Advance row index
        row_index = row_tmp;
        row_cnt_p = row_cnt_p + row_step;
        if cnt/11 >= 10
            row_step = 8.02;
        else
            row_step = 6.33;
        end
    
        % Reset column index
        col_index = 2;
        col_end = 2;
        col_cnt = 2;
        col_cnt_p = 2;
    
    end
    
end