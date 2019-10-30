function ReadXRF

       %% Read in file
       
    %BaLafile = '../XRF/PR-15_BaLa.xlsm';
    %HfLafile = '../XRF/PR-15_HfLa.xlsm';
    %MoKafile = '../XRF/PR-15_MoKa.xlsm';
    %TaLafile = '../XRF/PR-15_TaLa.xlsm';
    %TiKafile = '../XRF/PR-15_TiKa.xlsm';
    %ZrKafile = '../XRF/PR-15_ZrKa.xlsm';
    
    %global number_bala;
    %global number_hfla;
    %global number_moka;
    %global number_tala;
    %global number_tika;
    %global number_zrka;
    
    %[number_bala, text_bala, rawData_bala] = xlsread(BaLafile,'PR-15_BaLa','A1:BY225');
    %[number_hfla, text_hfla, rawData_hfla] = xlsread(HfLafile,'PR-15_HfLa','A1:BY225');
    %[number_moka, text_moka, rawData_moka] = xlsread(MoKafile,'PR-15_MoKa','A1:BY225');
    %[number_tala, text_tala, rawData_tala] = xlsread(TaLafile,'PR-15_TaLa','A1:BY225');
    %[number_tika, text_tika, rawData_tika] = xlsread(TiKafile,'PR-15_TiKa','A1:BY225');
    %[number_zrka, text_zrka, rawData_zrka] = xlsread(ZrKafile,'PR-15_ZrKa','A1:BY225');
    
    global number_coka;
    global number_nika;
    global number_znka;
    
    % For rs7  
    CoKafile = '../data_Tina/xrf/RS-7_CoKa.xlsm';
    NiKafile = '../data_Tina/xrf/RS-7_NiKa.xlsm';
    ZnKafile = '../data_Tina/xrf/RS-7_ZnKa.xlsm';
    
    [number_coka, text_coka, rawData_coka] = xlsread(CoKafile,'RS-7_CoKa','A1:BY225');
    [number_nika, text_nika, rawData_nika] = xlsread(NiKafile,'RS-7_NiKa','A1:BY225');
    [number_znka, text_znka, rawData_znka] = xlsread(ZnKafile,'RS-7_ZnKa','A1:BY225');
    
        %% Map XRF points to XRD points  (1mm, 1mm)/ (8.1mm, 7.8mm) 
    row_index = 152;
    col_index = 2;
    row_end = 152;
    col_end = 2;
    row_cnt = 152;
    col_cnt = 2;
    row_cnt_p = 152;
    col_cnt_p = 2;
    row_step = 3.9;

    global data_coka;
    global data_nika;
    global data_znka;
    
    cnt = 1;
    data_coka = zeros(1,100);
    data_nika = zeros(1,100);
    data_znka = zeros(1,100);

    while (row_index < 225) && (col_index < 77)
    
        while row_cnt - row_cnt_p < row_step
            row_end = row_end + 1;
            row_cnt = row_cnt + 1;
        end
    
        col_step = 4.05;
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
            data_nika(cnt) = data_nika(cnt)/point_cnt;
            data_znka(cnt) = data_znka(cnt)/point_cnt;
            cnt = cnt + 1;

            % Advance column index
            col_index = col_tmp;
            col_cnt_p = col_cnt_p + col_step;
            col_step = 8.1;
        
        end
    
        % Advance row index
        row_index = row_tmp;
        row_cnt_p = row_cnt_p + row_step;
        row_step = 7.8;
    
        % Reset column index
        col_index = 2;
        col_end = 2;
        col_cnt = 2;
        col_cnt_p = 2;
    
    end

end