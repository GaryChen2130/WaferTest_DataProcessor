function ReadPosBKGD(file_path,sheet_name,range,xstep,xmax,ystep,ymax)

%% Read in file
    [number, text, rawData] = xlsread(file_path,sheet_name,range);
    x_pos = number(1:length(number),1);
    y_pos = number(1:length(number),2);
    
%% Map points onto wafer
    global pos_num_bkgd;
    global position_bkgd;
    pos_num_bkgd = zeros(15,15);
    position_bkgd = zeros(15,2);
    
    for i = 1:length(x_pos)
       col_index = round((x_pos(i) + xmax)/xstep) + 1;
       row_index = round((y_pos(i) + ymax)/ystep) + 1;
       pos_num_bkgd(row_index,col_index) = i;
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