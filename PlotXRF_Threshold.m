function PlotXRF_Threshold(handles,target_element)

global number_xrd
global row_num;
    
global data_bala;
global data_hfla;
global data_moka;
global data_tala;
global data_tika;
global data_zrka;

global record;

target = 0;
target_data = zeros(1,100);

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
        ba_min = str2double(get(handles.ba_min,'String'));
        ba_max = str2double(get(handles.ba_max,'String'));
    end
    
    if target ~= 2
        hf_min = str2double(get(handles.hf_min,'String'));
        hf_max = str2double(get(handles.hf_max,'String'));
    end
    
    if target ~= 3
        mo_min = str2double(get(handles.mo_min,'String'));
        mo_max = str2double(get(handles.mo_max,'String'));
    end
    
    if target ~= 4
        ta_min = str2double(get(handles.ta_min,'String'));
        ta_max = str2double(get(handles.ta_max,'String'));
    end
    
    if target ~= 5
        Ti_min = str2double(get(handles.ti_min,'String'));
        Ti_max = str2double(get(handles.ti_max,'String'));
    end
    
    if target ~= 6
        Zr_min = str2double(get(handles.zr_min,'String'));
        Zr_max = str2double(get(handles.zr_max,'String'));
    end
    
end

% In-bound checking 
zz = number_xrd(2:row_num,2:101);
for i = 1:100
   
   if ~ismember(i,record)
       zz(1:row_num - 1,i) = 0;
   elseif (data_bala(i) < ba_min) || (data_bala(i) > ba_max)
       zz(1:row_num - 1,i) = 0;
   elseif (data_hfla(i) < hf_min) || (data_hfla(i) > hf_max)
       zz(1:row_num - 1,i) = 0;
   elseif (data_moka(i) < mo_min) || (data_moka(i) > mo_max)
       zz(1:row_num - 1,i) = 0;
   elseif (data_tala(i) < ta_min) || (data_tala(i) > ta_max)
       zz(1:row_num - 1,i) = 0;
   elseif (data_tika(i) < ti_min) || (data_tika(i) > ti_max)
       zz(1:row_num - 1,i) = 0;
   elseif (data_zrka(i) < zr_min) || (data_zrka(i) > zr_max)
       zz(1:row_num - 1,i) = 0;
   end
   
end

figure(2)
for i = 1:100

    if zz(1:row_num - 1,i) ~= 0
        y_vec = zeros(row_num - 1,1);
        y_vec(1:row_num - 1) = target_data(i);
        plt = plot3(number_xrd(2:row_num,1),y_vec,zz(1:row_num - 1,i));
        hold on;
    end

end

hold off;
xlabel('2-theta(degree)') 
ylabel(['PR-15 ' target_element])

end

