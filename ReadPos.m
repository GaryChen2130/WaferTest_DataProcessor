function ReadPos(file_path,sheet_name)

%% Read in file
    [number, text, rawData] = xlsread(file_path,sheet_name,'A2:C90');
    point_number = number(1:length(number),1);
    x_pos = number(1:length(number),2);
    y_pos = number(1:length(number),3);
    
%% Map points onto wafer
    global pos_num;
    pos_num = zeros(11,11);
    
    for i = 1:length(point_number)
       col_index = round((x_pos(i) + 31.667)/6.333) + 1;
       row_index = round((y_pos(i) + 31.667)/6.333) + 1;
       pos_num(row_index,col_index) = point_number(i);
    end
    
end