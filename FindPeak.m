function [peak_value] = FindPeak(target_angle)

    global pos_num;
    global number_bkgd;

    angle = number_bkgd(1:length(number_bkgd),1);
    peak_value = zeros(15,15);
    for row = 1:15
        for col = 1:15
            
            if pos_num(row,col) == 0
                continue
            end
            
            for i = 1:length(angle)
                if angle(i) < target_angle
                    continue 
                end
                peak_value(row,col) = number_bkgd(i,pos_num(row,col) + 1);
                break
            end
            
        end
    end

    %target_angle
    %peak_value

end