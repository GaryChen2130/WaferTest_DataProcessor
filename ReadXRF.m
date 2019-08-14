function ReadXRF

       %% Read in file
    BaLafile = '../XRF/PR-15_BaLa.xlsm';
    HfLafile = '../XRF/PR-15_HfLa.xlsm';
    MoKafile = '../XRF/PR-15_MoKa.xlsm';
    TaLafile = '../XRF/PR-15_TaLa.xlsm';
    TiKafile = '../XRF/PR-15_TiKa.xlsm';
    ZrKafile = '../XRF/PR-15_ZrKa.xlsm';
    
    global number_bala;
    global number_hfla;
    global number_moka;
    global number_tala;
    global number_tika;
    global number_zrka;
    
    [number_bala, text_bala, rawData_bala] = xlsread(BaLafile,'PR-15_BaLa','A1:BY225');
    [number_hfla, text_hfla, rawData_hfla] = xlsread(HfLafile,'PR-15_HfLa','A1:BY225');
    [number_moka, text_moka, rawData_moka] = xlsread(MoKafile,'PR-15_MoKa','A1:BY225');
    [number_tala, text_tala, rawData_tala] = xlsread(TaLafile,'PR-15_TaLa','A1:BY225');
    [number_tika, text_tika, rawData_tika] = xlsread(TiKafile,'PR-15_TiKa','A1:BY225');
    [number_zrka, text_zrka, rawData_zrka] = xlsread(ZrKafile,'PR-15_ZrKa','A1:BY225');
    
        %% Map XRF points to XRD points  (1mm, 1mm)/ (7.9mm, 8.1mm) 
    row_index = 152;
    col_index = 2;
    row_end = 152;
    col_end = 2;
    row_cnt = 152;
    col_cnt = 2;
    row_cnt_p = 152;
    col_cnt_p = 2;
    row_step = 4.05;

    global data_bala;
    global data_hfla;
    global data_moka;
    global data_tala;
    global data_tika;
    global data_zrka;
    
    cnt = 1;
    data_bala = zeros(1,100);
    data_hfla = zeros(1,100);
    data_moka = zeros(1,100);
    data_tala = zeros(1,100);
    data_tika = zeros(1,100);
    data_zrka = zeros(1,100);

    while (row_index < 225) && (col_index < 77)
    
        while row_cnt - row_cnt_p < row_step
            row_end = row_end + 1;
            row_cnt = row_cnt + 1;
        end
    
        col_step = 3.95;
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
                    data_bala(cnt) = data_bala(cnt) + number_bala(row_tmp,col_tmp);
                    data_hfla(cnt) = data_hfla(cnt) + number_hfla(row_tmp,col_tmp);
                    data_moka(cnt) = data_moka(cnt) + number_moka(row_tmp,col_tmp);
                    data_tala(cnt) = data_tala(cnt) + number_tala(row_tmp,col_tmp);
                    data_tika(cnt) = data_tika(cnt) + number_tika(row_tmp,col_tmp);
                    data_zrka(cnt) = data_zrka(cnt) + number_zrka(row_tmp,col_tmp);
                
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
            data_bala(cnt) = data_bala(cnt)/point_cnt;
            data_hfla(cnt) = data_hfla(cnt)/point_cnt;
            data_moka(cnt) = data_moka(cnt)/point_cnt;
            data_tala(cnt) = data_tala(cnt)/point_cnt;
            data_tika(cnt) = data_tika(cnt)/point_cnt;
            data_zrka(cnt) = data_zrka(cnt)/point_cnt;
            cnt = cnt + 1;

            % Advance column index
            col_index = col_tmp;
            col_cnt_p = col_cnt_p + col_step;
            col_step = 7.9;
        
        end
    
        % Advance row index
        row_index = row_tmp;
        row_cnt_p = row_cnt_p + row_step;
        row_step = 8.1;
    
        % Reset column index
        col_index = 2;
        col_end = 2;
        col_cnt = 2;
        col_cnt_p = 2;
    
    end

end