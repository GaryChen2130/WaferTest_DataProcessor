function PlotRes(index,len)
    
    global data_imp;
    global pos_num;
    
    bar_data = zeros(len,2);
    plot_data = zeros(len,2);
    for i = 1:len
        
        bar_data(i,1) = data_imp(index(i));
        plot_data(i,1) = data_imp(index(i));
        
        if mod(index(i),11) == 0
            row_index = floor(index(i)/11);
            col_index = 11;
        else
            row_index = floor(index(i)/11) + 1;
            col_index = mod(index(i),11);
        end
        
        bar_data(i,2) = pos_num(row_index,col_index);
        plot_data(i,2) = pos_num(row_index,col_index);
        
    end
    
    figure(3)
    plot_data = sortrows(plot_data,2);
    plot(plot_data(:,2),plot_data(:,1),'-o');
    
    xlabel('point number') 
    ylabel('Resistance')
    ylim([0,(max(plot_data(:,1))*4)/3])
    
    figure(4)
    bar_data = sortrows(bar_data,2);
    bar(bar_data(:,2),bar_data(:,1));
    
    %for i = 1:len
    %   text(bar_data(2,i),bar_data(1,i) + 1,num2str(bar_data(1,i),'%g'),...
    %            'HorizontalAlignment','center',...
    %            'VerticalAlignment','bottom'); 
    %end
       
    xlabel('point number') 
    ylabel('Resistance')
    ylim([0,(max(bar_data(:,1))*4)/3])
    
end