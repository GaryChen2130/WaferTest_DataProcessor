function ReadIMP(file_path,sheet_name)
  
   %% Read in file
    [number, text, rawData] = xlsread(file_path,sheet_name,'A2:D91');
    
    angle_imp = number(1:length(number),2);
    radius_imp = number(1:length(number),3);
    val_imp = number(1:length(number),4);
 
    %% Map IMP points to XRD points (XRD: 7.9mm, 8.1mm)
    global data_imp;
    data_imp = zeros(1,100);
    for i = 1:length(number)
        
        % Covert polar coordinates into Cartesian coordinates
        x = radius_imp(i)*sind(angle_imp(i));
        y = radius_imp(i)*cosd(angle_imp(i));
        x = roundn(x,-3) + 35;
        y = roundn(y,-3) + 35;
        
        %fprintf('point %d: x = %g  y = %g  angle = %g  radius = %g\n',i,x,y,angle_imp(i),radius_imp(i))
        
        % Map data to points in array
        step_x = round(y/7.778) + 1;
        step_y = round(x/7.778) + 1;
        data_imp((step_x - 1)*10 + step_y) = val_imp(i);
        
    end
    
end