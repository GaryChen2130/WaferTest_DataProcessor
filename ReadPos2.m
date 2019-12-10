function ReadPos2(file_path,sheet_name,range,xstep,xmax,ystep,ymax)

%% Read in file
    [number, text, rawData] = xlsread(file_path,sheet_name,range);
    point_number = number(1:length(number),1);
    x_pos = number(1:length(number),2);
    y_pos = number(1:length(number),3);
    
%% Map points onto wafer
    global pos_num;
    global pos_value;
    global position;
    pos_num = zeros(11,11);
    pos_value = zeros(121,2);
    pos_value_x = zeros(11,11);
    pos_value_y = zeros(11,11);
    position = zeros(11,2);
        
    for i = 1:length(point_number)
       col_index = round((x_pos(i) + xmax)/xstep) + 1;
       row_index = round((y_pos(i) + ymax)/ystep) + 1;
       pos_num(row_index,col_index) = point_number(i);
       pos_value_x(row_index,col_index) = x_pos(i);
       pos_value_y(row_index,col_index) = y_pos(i);
    end
    
    for i = 1:5
        pos_num([i,12 - i],:) = pos_num([12 - i,i],:);
    end
    
    for i = 1:11
       for j = 1:11
          if pos_num(i,j) == 0
             continue; 
          end
          pos_value(pos_num(i,j),1) = pos_value_x(i,j);
          pos_value(pos_num(i,j),2) = pos_value_y(i,j);
       end
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