function PlotXRDandXRF_Bar2(handles,index,len)

    global number_xrd
    global row_num;
    global pos_num;
    
    global data_coka;
    global data_mgka;
    global data_mnka;
    global data_nika;
    global data_znka;


    bar_data = zeros(len,5);
    lgd_index = zeros(1,len);

    figure(2);
    subplot(1,2,1)
    for i = 1:len
        
        if mod(index(i),11) == 0
            row_index = floor(index(i)/11);
            col_index = 11;
        else
            row_index = floor(index(i)/11) + 1;
            col_index = mod(index(i),11);
        end
        
        x = pos_num(row_index,col_index);
        x_vec = zeros(row_num - 1,1);
        x_vec(1:row_num - 1) = x;
        lgd_index(i) = pos_num(row_index,col_index);
        
        plot3(x_vec,number_xrd(2:row_num,1),number_xrd(2:row_num,x + 1));
        hold on;
    
        bar_data(i,:) = [data_coka(index(i)),data_mgka(index(i)),data_mnka(index(i)),data_nika(index(i)),data_znka(index(i))];

    end

    axis([0, 100, -inf, inf]);
    lgd = num2str(sort(lgd_index(1:len))','point %d');
    legend(lgd)
    xlabel('point number') 
    ylabel('2-theta(degree)')
    angle_min = str2double(get(handles.angle_min,'String'));
    angle_max = str2double(get(handles.angle_max,'String'));
    ylim([angle_min,angle_max])

    hold off;

    subplot(1,2,2)
    plt = bar3(bar_data,0.1);
    set(gca, 'xticklabel', {'CoKa','MgKa','MnKa', 'NiKa', 'ZnKa'});
    set(gca, 'yticklabel', sort(lgd_index(1:len))');
    
    [row,col] = size(bar_data);
    if row > 1
        for i = 1:5
            zdata = get(plt(i),'ZData');
            set(plt(i),'CData',zdata);
            set(plt(i),'FaceColor','interp');
        end
    end
    
    for i = 1:row
       for j = 1:col
            text(j,i,bar_data(i,j) + 0.5,num2str(roundn(bar_data(i,j),-2),'%g%%'),...
                'HorizontalAlignment','center',...
                'VerticalAlignment','bottom');
        end 
    end
    
    colorbar
    set(gcf,'unit','normalized','position',[0.2,0.2,0.64,0.5]);

end