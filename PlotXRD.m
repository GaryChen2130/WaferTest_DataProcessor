function PlotXRD(index,len)

    global number_xrd
    global row_num;
    
    figure(3);
    for i = 1:len
        x_vec = zeros(row_num - 1,1);
        x_vec(1:row_num - 1) = index(i);
        plt = plot3(x_vec,number_xrd(2:row_num,1),number_xrd(2:row_num,index(i) + 1));
        hold on;
    end
    
    axis([0, 105, -inf, inf]);
    lgd = num2str(index(1:len)','point %d');
    legend(lgd)
    xlabel('point number') 
    ylabel('2-theta(degree)')

    hold off;
    
end