function PlotXRD(handles,index,len)

    global number_xrd;
    global row_num;
    global pos_num;
    global mode;
    
    if mode == 1
        col = 10;
    elseif mode == 2
        col = 11;
    end
    
    figure(1);
    lgd_index = zeros(1,len);
    for i = 1:len
        
        x_vec = zeros(row_num - 1,1);
        
        if mod(index(i),col) == 0
            row_index = floor(index(i)/col);
            col_index = col;
        else
            row_index = floor(index(i)/col) + 1;
            col_index = mod(index(i),col);
        end
        
        x_vec(1:row_num - 1) = pos_num(row_index,col_index);
        lgd_index(i) = pos_num(row_index,col_index);
        
        plot3(x_vec,number_xrd(2:row_num,1),number_xrd(2:row_num,pos_num(row_index,col_index) + 1));
        hold on;
        
    end
    
    if length(lgd_index) > 1
        axis([min(lgd_index), max(lgd_index), -inf, inf]);
    else
        axis([0,105, -inf, inf]);
    end
    lgd = num2str(sort(lgd_index(1:len))','point %d');
    legend(lgd)
    xlabel('point number') 
    ylabel('2-theta(degree)')
    angle_min = str2double(get(handles.angle_min,'String'));
    angle_max = str2double(get(handles.angle_max,'String'));
    ylim([angle_min,angle_max])

    hold off;
    
end