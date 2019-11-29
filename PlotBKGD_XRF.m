function PlotBKGD_XRF()

    global number_bkgd;
    global data_mnka;
    global data_znka;
    global pos_num;
    
    figure(1)
    for row = 1:15
        for col = 1:15
            
            if pos_num(row,col) == 0
                continue
            end
            
            x_vec = zeros(length(number_bkgd),1);
            x_vec(1:length(number_bkgd)) = data_znka((row - 1)*15 + col);
            plt = plot3(x_vec,number_bkgd(1:length(number_bkgd),1),number_bkgd(1:length(number_bkgd),pos_num(row,col) + 1),'LineWidth',1.2);
            
            hold on
            
        end
    end
    
    hold off
    xlabel('RS-11 ZnKa')
    ylabel('2-theta(degree)') 
    
end