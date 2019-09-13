function PlotRESandXRF_Bar(index,len)

    global data_imp;
    global pos_num;
    
    global data_coka;
    global data_mgka;
    global data_mnka;
    global data_nika;
    global data_znka;

    plot_data = zeros(len,2);
    bar_data = zeros(len,5);
    lgd_index = zeros(1,len);

    figure(4);
    subplot(1,2,1)
    for i = 1:len
        
        plot_data(i,1) = data_imp(index(i));
        
        if mod(index(i),11) == 0
            row_index = floor(index(i)/11);
            col_index = 11;
        else
            row_index = floor(index(i)/11) + 1;
            col_index = mod(index(i),11);
        end
        
        plot_data(i,2) = pos_num(row_index,col_index);
        lgd_index(i) = pos_num(row_index,col_index);
        bar_data(i,:) = [data_coka(index(i)),data_mgka(index(i)),data_mnka(index(i)),data_nika(index(i)),data_znka(index(i))];
        
    end
    
    plot_data = sortrows(plot_data,2);
    plot(plot_data(:,2),plot_data(:,1),'-o');
    
    xlabel('point number') 
    ylabel('Resistance')
    ylim([0,(max(plot_data(:,1))*4)/3])

    subplot(1,2,2)
    plt = bar3(bar_data,0.1);
    set(gca, 'xticklabel', {'CoKa','MgKa','MnKa', 'NiKa', 'ZnKa'});
    set(gca, 'yticklabel', sort(lgd_index(1:len))');
    set(gcf,'unit','normalized','position',[0.2,0.2,0.64,0.5]);
    
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