function ReadPos2(file_path,sheet_name,range,xstep,xmax,ystep,ymax)

%% Read in file
    [number, text, rawData] = xlsread(file_path,sheet_name,range);
    point_number = number(1:length(number),1);
    x_pos = number(1:length(number),2);
    y_pos = number(1:length(number),3);
    
%% Map points onto wafer
    global pos_num;
    global position;
    pos_num = zeros(11,11);
    position = zeros(11,2);
    
    for i = 1:length(point_number)
       col_index = round((x_pos(i) + xmax)/xstep) + 1;
       row_index = round((y_pos(i) + ymax)/ystep) + 1;
       pos_num(row_index,col_index) = point_number(i);
    end
    
    position_x = 0;
    position_y = 0;
    for i = 1:11
       position(i,1) = position_y;
       position(i,2) = position_x;
       position_x = position_x + xstep;
       position_y = position_y + ystep;
    end
    
    %pos_num
    %position
    
end