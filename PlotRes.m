function PlotRes(index,len)
    
    global data_imp;
    global pos_num;
    
    bar_data = zeros(2,len);
    for i = 1:len
        
        bar_data(1,i) = data_imp(index(i));
        
        if mod(index(i),11) == 0
            row_index = floor(index(i)/11);
            col_index = 11;
        else
            row_index = floor(index(i)/11) + 1;
            col_index = mod(index(i),11);
        end
        
        bar_data(2,i) = pos_num(row_index,col_index);
        
    end
    
    figure(3)
    bar(bar_data(2,:),bar_data(1,:));
    
    for i = 1:len
       text(bar_data(2,i),bar_data(1,i) + 1,num2str(bar_data(1,i),'%g'),...
                'HorizontalAlignment','center',...
                'VerticalAlignment','bottom'); 
    end
    
    
    set(gca, 'xticklabel', sort(bar_data(2,:)));
    xlabel('point number') 
    ylabel('Resistance')
    ylim([0,(max(bar_data(1,:))*4)/3])
    
end