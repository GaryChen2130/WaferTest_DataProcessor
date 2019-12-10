function ReadPosBKGD(file_path,sheet_name,range,xstep,xmax,ystep,ymax)

%% Read in file
    [number, text, rawData] = xlsread(file_path,sheet_name,range);
    x_pos = number(1:length(number),1);
    y_pos = number(1:length(number),2);
    
%% Map points onto wafer
    global pos_num_bkgd;
    global pos_value_bkgd;
    global position_bkgd;
    pos_num_bkgd = zeros(15,15);
    pos_value_bkgd = zeros(225,2);
    pos_value_bkgd_x = zeros(15,15);
    pos_value_bkgd_y = zeros(15,15);
    position_bkgd = zeros(15,2);
    
    for i = 1:length(x_pos)
       col_index = round((x_pos(i) + xmax)/xstep) + 1;
       row_index = round((y_pos(i) + ymax)/ystep) + 1;
       pos_num_bkgd(row_index,col_index) = i;
       pos_value_bkgd_x(row_index,col_index) = x_pos(i);
       pos_value_bkgd_y(row_index,col_index) = y_pos(i);
    end
        
    for i = 1:15
       for j = 1:15
          if pos_num_bkgd(i,j) == 0
             continue; 
          end
          pos_value_bkgd(pos_num_bkgd(i,j),1) = pos_value_bkgd_x(i,j);
          pos_value_bkgd(pos_num_bkgd(i,j),2) = pos_value_bkgd_y(i,j);
       end
    end
    
    position_x = 0;
    position_y = 0;
    for i = 1:15
       position_bkgd(i,1) = position_y;
       position_bkgd(i,2) = position_x;
       position_x = position_x + xstep;
       position_y = position_y + ystep;
    end
    
    %pos_num_bkgd
    %position_bkgd
    
end