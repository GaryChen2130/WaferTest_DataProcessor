function FindPeak177(target_angle,range,peak_num)

    global number_bkgd;
    global pos_num_bkgd;
    
    global peak_value;
    global peak_pos;

    angle = number_bkgd(1:length(number_bkgd),1);
    peak_value = zeros(225,peak_num);
    peak_pos = zeros(225,peak_num);
    for p = 1:peak_num
        for row = 1:15
            for col = 1:15
                                
                if pos_num_bkgd(row,col) == 0
                    continue
                end
                
                for i = 1:length(angle)
                    if angle(i) < target_angle
                        continue
                    end
                    mid_angle = angle(i);
                    mid_index = i;
                    break
                end
                
                offset = 0;
                while angle(mid_index + offset) - mid_angle <= range
                    
                    if (number_bkgd(mid_index - offset,pos_num_bkgd(row,col) + 1) >= number_bkgd(mid_index - offset - 1,pos_num_bkgd(row,col) + 1)) && (number_bkgd(mid_index - offset,pos_num_bkgd(row,col) + 1) >= number_bkgd(mid_index - offset + 1,pos_num_bkgd(row,col) + 1)) && (~ismember(number_bkgd(mid_index - offset,pos_num_bkgd(row,col) + 1),peak_value(pos_num_bkgd(row,col),:)))
                        peak_value(pos_num_bkgd(row,col),p) = number_bkgd(mid_index - offset,pos_num_bkgd(row,col) + 1);
                        peak_pos(pos_num_bkgd(row,col),p) = angle(mid_index - offset);
                        break;
                    end
                    
                    if (number_bkgd(mid_index + offset,pos_num_bkgd(row,col) + 1) >= number_bkgd(mid_index + offset - 1,pos_num_bkgd(row,col) + 1)) && (number_bkgd(mid_index + offset,pos_num_bkgd(row,col) + 1) >= number_bkgd(mid_index + offset + 1,pos_num_bkgd(row,col) + 1)) && (~ismember(number_bkgd(mid_index + offset,pos_num_bkgd(row,col) + 1),peak_value(pos_num_bkgd(row,col),:)))
                        peak_value(pos_num_bkgd(row,col),p) = number_bkgd(mid_index + offset,pos_num_bkgd(row,col) + 1);
                        peak_pos(pos_num_bkgd(row,col),p) = angle(mid_index + offset);
                        break;
                    end
                    
                    offset = offset + 1;
                    
                end
                %break;
                                
            end
            %break;
        end
    end

    %target_angle

end