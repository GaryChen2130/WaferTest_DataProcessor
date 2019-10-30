function PlotXRF_Threshold2(handles,target_element)

global number_xrd;
global data_imp;
global row_num;
global pos_num;
global mode;
    
global data_coka;
global data_mgka;
global data_mnka;
global data_nika;
global data_znka;

global record;

target = 0;
if mode == 1
    col = 10;
    target_data = zeros(1,100);
elseif mode == 2
    col = 11;
    target_data = zeros(1,121);
end

if target_element == 'co'
   target = 1;
   target_data = data_coka;
   target_element = 'CoKa';
elseif target_element == 'mg'
   target = 2;
   target_data = data_mgka;
   target_element = 'MgKa';
   %target_element = 'CrKa';
elseif target_element == 'mn'
   target = 3;
   target_data = data_mnka;
   target_element = 'MnKa';
elseif target_element == 'ni'
   target = 4;
   target_data = data_nika;
   target_element = 'NiKa';
elseif target_element == 'zn'
   target = 5;
   target_data = data_znka;
   target_element = 'ZnKa';
   %target_element = 'FeKa';
end

% Initialize threshold
co_min = 0;
co_max = 100;
mg_min = 0;
mg_max = 100;
mn_min = 0;
mn_max = 100;
ni_min = 0;
ni_max = 100;
zn_min = 0;
zn_max = 100;

if target == 0
    fprintf('No such element in database\n');
else
    
        co_min = str2double(get(handles.co_min,'String'));
        co_max = str2double(get(handles.co_max,'String'));
        mg_min = str2double(get(handles.mg_min,'String'));
        mg_max = str2double(get(handles.mg_max,'String'));
        mn_min = str2double(get(handles.mn_min,'String'));
        mn_max = str2double(get(handles.mn_max,'String'));
        ni_min = str2double(get(handles.ni_min,'String'));
        ni_max = str2double(get(handles.ni_max,'String'));
        zn_min = str2double(get(handles.zn_min,'String'));
        zn_max = str2double(get(handles.zn_max,'String'));
    
end

[record_row,record_col] = size(record);
record_pos = zeros(1,record_col);
for i = 1:record_col
    
    if mod(record(i),col) == 0
        row_index = floor(record(i)/col);
        col_index = col;
    else
        row_index = floor(record(i)/col) + 1;
        col_index = mod(record(i),col);
    end
    
    record_pos(i) = pos_num(row_index,col_index);
    
end

if get(handles.xrd_checkbox, 'value') == 1

    zz = number_xrd(2:row_num,2:90);

    % In-bound checking
    for i = 1:89
    
        if ~ismember(i,record_pos)
            zz(1:row_num - 1,i) = 0;
        elseif (data_coka(i) < co_min) || (data_coka(i) > co_max)
            zz(1:row_num - 1,i) = 0;
        elseif (data_mgka(i) < mg_min) || (data_mgka(i) > mg_max)
            zz(1:row_num - 1,i) = 0;
        elseif (data_mnka(i) < mn_min) || (data_mnka(i) > mn_max)
            zz(1:row_num - 1,i) = 0;
        elseif (data_nika(i) < ni_min) || (data_nika(i) > ni_max)
            zz(1:row_num - 1,i) = 0;
        elseif (data_znka(i) < zn_min) || (data_znka(i) > zn_max)
            zz(1:row_num - 1,i) = 0;
        end
   
    end

    figure(3)
    lgd_index = zeros(1,length(record));
    lgd_cnt = 1;
    for i = 1:89

        if sum(zz(1:row_num - 1,i)) ~= 0
            
            y_vec = zeros(row_num - 1,1);
            y_vec(1:row_num - 1) = target_data(i);
            plt = plot3(number_xrd(2:row_num,1),y_vec,zz(1:row_num - 1,i),'LineWidth',1.2);
            g = get(plt,'Parent');
            set(g,'LineWidth',1.5,'FontSize',14);
                        
            lgd_index(lgd_cnt) = i;
            lgd_cnt = lgd_cnt + 1;
            
            hold on;
            
        end

    end
    
    lgd_index(lgd_cnt:record_col) = [];

    hold off;
    xlabel('2-theta(degree)') 
    ylabel(['RS-7 ' target_element])
    
    angle_min = str2double(get(handles.angle_min,'String'));
    angle_max = str2double(get(handles.angle_max,'String'));
    xlim([angle_min,angle_max])
    
    lgd = num2str(sort(lgd_index(1:length(lgd_index)))','point %d');
    legend(lgd)

end

if get(handles.res_checkbox, 'value') == 1
    
    yy = zeros(length(data_imp),2);
    yy(:,1) = target_data;
    yy(:,2) = data_imp;
    
    % In-bound checking
    xmax = 0;
    xmin = 100;
    length(data_imp)
    for i = 1:length(data_imp)
        i
        target_data(i)
        data_imp(i)
        
        if ~ismember(i,record)
            yy(i,2) = 0;
        elseif (data_coka(i) < co_min) || (data_coka(i) > co_max)
            yy(i,2) = 0;
        elseif (data_mgka(i) < mg_min) || (data_mgka(i) > mg_max)
            yy(i,2) = 0;
        elseif (data_mnka(i) < mn_min) || (data_mnka(i) > mn_max)
            yy(i,2) = 0;
        elseif (data_nika(i) < ni_min) || (data_nika(i) > ni_max)
            yy(i,2) = 0;
        elseif (data_znka(i) < zn_min) || (data_znka(i) > zn_max)
            yy(i,2) = 0;
        end
        
        if yy(i,2) ~= 0
            
            if yy(i,1) > xmax
                xmax = yy(i,1);
            end
            
            if yy(i,1) < xmin
                xmin = yy(i,1);
            end
            
        end
        
    end
    
    figure(5)
    yy = sortrows(yy,1);
    plt = plot(yy(:,1),yy(:,2),'-o','LineWidth',1.2);
    g = get(plt,'Parent');
    set(g,'LineWidth',1.5,'FontSize',14);
    xlabel(['RS-7 ' target_element])
    ylabel('Resistance')
    if max(yy(:,2)) > 0
        ylim([0,(max(yy(:,2))*4)/3])
    end
    
    figure(6)
    plt = plot(yy(:,1),yy(:,2),'-o','LineWidth',1.2);
    g = get(plt,'Parent');
    set(g,'LineWidth',1.5,'FontSize',14);
    xlabel(['RS-7 ' target_element])
    ylabel('Resistance')
    
    if length(record) > 1
        xlim([xmin,xmax])
    end
    
    if max(yy(:,2)) > 0
        ylim([0,(max(yy(:,2))*4)/3])
    end
    
end

end