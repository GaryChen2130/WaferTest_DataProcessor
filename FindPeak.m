function FindPeak(target_angle,range,peak_num)

    global number_bkgd;
    global mapped_bkgd;
    global mapping_pos;
    
    global peak_value;
    global peak_pos;

    angle = number_bkgd(1:length(number_bkgd),1);
    peak_value = zeros(121,peak_num);
    peak_pos = zeros(121,peak_num);
    for p = 1:peak_num
        for row = 1:15
            for col = 1:15
                                
                if mapping_pos(row,col) == 0
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
                    
                    if (mapped_bkgd(mapping_pos(row,col),mid_index - offset) >= mapped_bkgd(mapping_pos(row,col),mid_index - offset - 1)) && (mapped_bkgd(mapping_pos(row,col),mid_index - offset) >= mapped_bkgd(mapping_pos(row,col),mid_index - offset + 1)) && (~ismember(mapped_bkgd(mapping_pos(row,col),mid_index - offset),peak_value(mapping_pos(row,col),:)))
                        peak_value(mapping_pos(row,col),p) = mapped_bkgd(mapping_pos(row,col),mid_index - offset);
                        peak_pos(mapping_pos(row,col),p) = angle(mid_index - offset);
                        break;
                    end
                    
                    if(mapped_bkgd(mapping_pos(row,col),mid_index + offset) >= mapped_bkgd(mapping_pos(row,col),mid_index + offset - 1)) && (mapped_bkgd(mapping_pos(row,col),mid_index + offset) >= mapped_bkgd(mapping_pos(row,col),mid_index + offset + 1)) && (~ismember(mapped_bkgd(mapping_pos(row,col),mid_index + offset),peak_value(mapping_pos(row,col),:)))
                        peak_value(mapping_pos(row,col),p) = mapped_bkgd(mapping_pos(row,col),mid_index + offset);
                        peak_pos(mapping_pos(row,col),p) = angle(mid_index + offset);
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