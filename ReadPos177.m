function ReadPos177(file_path,sheet_name,range,xstep,xmax,ystep,ymax)

%% Read in file
    [number, text, rawData] = xlsread(file_path,sheet_name,range);
    x_pos = number(1:length(number),1);
    y_pos = number(1:length(number),2);
    
%% Map points onto wafer
    global pos_num;
    pos_num = zeros(15,15);
    
    for i = 1:length(x_pos)
       col_index = round((x_pos(i) + xmax)/xstep) + 1;
       row_index = round((y_pos(i) + ymax)/ystep) + 1;
       pos_num(row_index,col_index) = i;
    end
    
    %pos_num
    
end