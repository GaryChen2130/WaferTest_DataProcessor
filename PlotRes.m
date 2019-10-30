function PlotRes(index,len)
    
    global data_imp;
    global pos_num;
    global mode;
    
    if mode == 1
        col = 10;
    elseif mode == 2
        col = 11;
    end
    
    bar_data = zeros(len,2);
    plot_data = zeros(len,2);
    for i = 1:len
        
        bar_data(i,1) = data_imp(index(i));
        plot_data(i,1) = data_imp(index(i));
        
        if mod(index(i),col) == 0
            row_index = floor(index(i)/col);
            col_index = col;
        else
            row_index = floor(index(i)/col) + 1;
            col_index = mod(index(i),col);
        end
        
        bar_data(i,2) = pos_num(row_index,col_index);
        plot_data(i,2) = pos_num(row_index,col_index);
        
    end
    
    figure(3)
    plot_data = sortrows(plot_data,2);
    plot(plot_data(:,2),plot_data(:,1),'-o');
    hold on
    
    xlabel('point number') 
    ylabel('Resistance')
    if max(plot_data(:,1)) > 0
        ylim([0,(max(plot_data(:,1))*4)/3])
    end
    
    % Equation Fitting
    pow = 5;
    p = polyfit(plot_data(:,2),plot_data(:,1),pow);
    str = '';
    for i = 1:(pow + 1)
        if i == 1 || p(i) < 0
            str = [str num2str(p(i)) ' x^' int2str((pow + 1) - i) ' '];
        else p(i) >= 0
            str = [str '+' num2str(p(i)) ' x^' int2str((pow + 1) - i) ' '];
        end
    end
    str
    
    x_fit = linspace(min(bar_data(:,2)),max(bar_data(:,2)),100);
    y_fit = polyval(p,x_fit);
    plot(x_fit,y_fit)
    hold off
    
    %figure(4)
    %bar_data = sortrows(bar_data,2);
    %bar(bar_data(:,2),bar_data(:,1));
    
    %for i = 1:len
    %   text(bar_data(2,i),bar_data(1,i) + 1,num2str(bar_data(1,i),'%g'),...
    %            'HorizontalAlignment','center',...
    %            'VerticalAlignment','bottom'); 
    %end
       
    %xlabel('point number') 
    %ylabel('Resistance')
    %if max(bar_data(:,1)) > 0
    %    ylim([0,(max(bar_data(:,1))*4)/3])
    %end
    
end