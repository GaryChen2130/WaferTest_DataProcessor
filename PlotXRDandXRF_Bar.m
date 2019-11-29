function PlotXRDandXRF_Bar(index,len)

    global number_xrd
    global row_num;
    
    global data_bala;
    global data_hfla;
    global data_moka;
    global data_tala;
    global data_tika;
    global data_zrka;

    bar_data = zeros(len,6);

    figure(4);
    subplot(1,2,1)
    for i = 1:len
        x = index(i);
        x_vec = zeros(row_num - 1,1);
        x_vec(1:row_num - 1) = x;
        plt = plot3(x_vec,number_xrd(2:row_num,1),number_xrd(2:row_num,x + 1));
        hold on;
    
        bar_data(i,:) = [data_bala(x),data_hfla(x),data_moka(x),data_tala(x),data_tika(x),data_zrka(x)];

    end

    axis([0, 105, -inf, inf]);
    lgd = num2str(index(1:len)','point %d');
    legend(lgd)
    xlabel('point number') 
    ylabel('2-theta(degree)')

    hold off;

    subplot(1,2,2)
    plt = bar3(bar_data,0.1);
    set(gca, 'xticklabel', {'BaLa','HfLa','MoKa', 'TaLa', 'TiKa', 'ZrKa'});
    set(gca, 'yticklabel', index(1:len)');
    
    plt
    [row,col] = size(bar_data);
    for i = 1:row
        if row > 6
            break;
        end
        zdata = get(plt(i),'ZData');
        set(plt(i),'CData',zdata);
        set(plt(i),'FaceColor','interp');
    end
    
    for i = 1:row
       for j = 1:col
            text(j,i,bar_data(i,j) + 0.5,num2str(roundn(bar_data(i,j),-2),'%g%%'),...
                'HorizontalAlignment','center',...
                'VerticalAlignment','bottom');
        end 
    end
    
    colorbar

end