function PlotRESandXRF_Bar(index,len)

    global data_imp;
    global pos_num;
    global mode;
    
    if mode == 1
        col = 10;
    elseif mode == 2
        col = 11;
    end
    
    global data_coka;
    global data_mgka;
    global data_mnka;
    global data_nika;
    global data_znka;

    plot_data = zeros(len,2);
    bar_data = zeros(len,5);
    %bar_data = zeros(len,3);
    lgd_index = zeros(1,len);

    figure(4);
    subplot(1,2,1)
    for i = 1:len
        
        plot_data(i,1) = data_imp(index(i));
        
        if mod(index(i),col) == 0
            row_index = floor(index(i)/col);
            col_index = col;
        else
            row_index = floor(index(i)/col) + 1;
            col_index = mod(index(i),col);
        end
        
        plot_data(i,2) = pos_num(row_index,col_index);
        lgd_index(i) = pos_num(row_index,col_index);
        bar_data(i,:) = [data_coka(index(i)),data_mgka(index(i)),data_mnka(index(i)),data_nika(index(i)),data_znka(index(i))];
        %bar_data(i,:) = [data_coka(index(i)),data_nika(index(i)),data_znka(index(i))];
        
    end
    
    plot_data = sortrows(plot_data,2);
    plot(plot_data(:,2),plot_data(:,1),'-o');
    
    xlabel('point number') 
    ylabel('Resistance')
    if max(plot_data(:,1)) > 0
        ylim([0,(max(plot_data(:,1))*4)/3])
    end
    
    % Equation Fitting
    p = polyfit(plot_data(:,2),plot_data(:,1),5);
    str = '';
    for i = 1:6
        if i == 1 || p(i) < 0
            str = [str num2str(p(i)) ' x^' int2str(6 - i) ' '];
        else p(i) >= 0
            str = [str '+' num2str(p(i)) ' x^' int2str(6 - i) ' '];
        end
    end
    str

    subplot(1,2,2)
    plt = bar3(bar_data,0.1);
    set(gca, 'xticklabel', {'CoKa','MgKa','MnKa', 'NiKa', 'ZnKa'});
    set(gca, 'yticklabel', lgd_index(1:len)');
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
    set(gcf,'unit','normalized','position',[0.2,0.2,0.9,0.65]);

end