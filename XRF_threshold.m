%% Read in file
clear;

BaLafile = '../XRF/PR-15_BaLa.xlsm';
HfLafile = '../XRF/PR-15_HfLa.xlsm';
MoKafile = '../XRF/PR-15_MoKa.xlsm';
TaLafile = '../XRF/PR-15_TaLa.xlsm';
TiKafile = '../XRF/PR-15_TiKa.xlsm';
ZrKafile = '../XRF/PR-15_ZrKa.xlsm';
XRDfile = '../XRD/RS5H.xlsm';

[number_bala, text_bala, rawData_bala] = xlsread(BaLafile,'PR-15_BaLa','A1:BY225');
[number_hfla, text_hfla, rawData_hfla] = xlsread(HfLafile,'PR-15_HfLa','A1:BY225');
[number_moka, text_moka, rawData_moka] = xlsread(MoKafile,'PR-15_MoKa','A1:BY225');
[number_tala, text_tala, rawData_tala] = xlsread(TaLafile,'PR-15_TaLa','A1:BY225');
[number_tika, text_tika, rawData_tika] = xlsread(TiKafile,'PR-15_TiKa','A1:BY225');
[number_zrka, text_zrka, rawData_zrka] = xlsread(ZrKafile,'PR-15_ZrKa','A1:BY225');
[number_xrd, text_xrd, rawData_xrd] = xlsread(XRDfile,'RS5H','A1:CW3342');

%% Map XRF points to XRD points  (7.9mm, 8.1mm) / (1mm, 1mm)
row_index = 152;
col_index = 2;
row_end = 152;
col_end = 2;
row_cnt = 152;
col_cnt = 2;
row_cnt_p = 152;
col_cnt_p = 2;
row_step = 4.05;

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

%% Input target element and set threshold
target = 0;
target_data = zeros(1,100);
target_element = lower(input('Input target element\n','s'));

if target_element == 'ba'
   target = 1;
   target_data = data_bala;
   target_element = 'BaLa';
elseif target_element == 'hf'
   target = 2;
   target_data = data_hfla;
   target_element = 'HfLa';
elseif target_element == 'mo'
   target = 3;
   target_data = data_moka;
   target_element = 'MoKa';
elseif target_element == 'ta'
   target = 4;
   target_data = data_tala;
   target_element = 'TaLa';
elseif target_element == 'ti'
   target = 5;
   target_data = data_tika;
   target_element = 'TiKa';
elseif target_element == 'zr'
   target = 6;
   target_data = data_zrka;
   target_element = 'ZrKa';
end

% Initialize threshold
ba_min = 0;
ba_max = 100;
hf_min = 0;
hf_max = 100;
mo_min = 0;
mo_max = 100;
ta_min = 0;
ta_max = 100;
ti_min = 0;
ti_max = 100;
zr_min = 0;
zr_max = 100;

if target == 0
    fprintf('No such element in database\n');
else
    
    if target ~= 1
        ba_min = input('Input the lower bound of Ba\n');
        ba_max = input('Input the upper bound of Ba\n');
    end
    
    if target ~= 2
        hf_min = input('Input the lower bound of Hf\n');
        hf_max = input('Input the upper bound of Hf\n');
    end
    
    if target ~= 3
        mo_min = input('Input the lower bound of Mo\n');
        mo_max = input('Input the upper bound of Mo\n');
    end
    
    if target ~= 4
        ta_min = input('Input the lower bound of Ta\n');
        ta_max = input('Input the upper bound of Ta\n');
    end
    
    if target ~= 5
        Ti_min = input('Input the lower bound of Ti\n');
        Ti_max = input('Input the upper bound of Ti\n');
    end
    
    if target ~= 6
        Zr_min = input('Input the lower bound of Zr\n');
        Zr_max = input('Input the upper bound of Zr\n');
    end
    
end

% In-bound checking 
zz = number_xrd(2:3342,2:101);
for i = 1:100
    
   if (data_bala(i) < ba_min) || (data_bala(i) > ba_max)
       zz(1:3341,i) = 0;
   elseif (data_hfla(i) < hf_min) || (data_hfla(i) > hf_max)
       zz(1:3341,i) = 0;
   elseif (data_moka(i) < mo_min) || (data_moka(i) > mo_max)
       zz(1:3341,i) = 0;
   elseif (data_tala(i) < ta_min) || (data_tala(i) > ta_max)
       zz(1:3341,i) = 0;
   elseif (data_tika(i) < ti_min) || (data_tika(i) > ti_max)
       zz(1:3341,i) = 0;
   elseif (data_zrka(i) < zr_min) || (data_zrka(i) > zr_max)
       zz(1:3341,i) = 0;
   end
   
end

figure(1)
for i = 1:100

    if zz(1:3341,i) ~= 0
        y_vec = zeros(3341,1);
        y_vec(1:3341) = target_data(i);
        plt = plot3(number_xrd(2:3342,1),y_vec,zz(1:3341,i));
        hold on;
    end

end

hold off;
xlabel('2-theta(degree)') 
ylabel(['PR-15 ' target_element])

