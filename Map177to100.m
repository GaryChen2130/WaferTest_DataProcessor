function Map177to100(xstep1,ystep1,xstep2,ystep2)

global mode;
global pos_num;
global pos_num_bkgd;
global position;
global position_bkgd;
global number_bkgd;
global mapped_bkgd;
global mapping_pos;

if mode == 1
    n = 10;
elseif mode == 2
    n = 11;
end

mapped_bkgd = zeros(n*n,800);
mapping_pos = zeros(15,15);
row_offset = [0 1 0 1];
col_offset = [0 0 1 1];

row_tmp = 1;
ystep_tmp = 0;
for i = 1:n
    
    col_tmp = 1;
    xstep_tmp = 0;
    
    % Find row interval of position_bkgd
    while (row_tmp < 15) && (position_bkgd(row_tmp,1) < ystep_tmp)
       row_tmp = row_tmp + 1; 
    end
    
    for j = 1:n     
        
        % Find column interval of position_bkgd
        while (col_tmp < 15) && (position_bkgd(col_tmp,2) < xstep_tmp)
            col_tmp = col_tmp + 1;
        end
        
        
        % Find closest BKGD point for mapping
        if pos_num(i,j) > 0
            
            dis_min = 99999;
            for k = 1:4
            
                row_index = row_tmp + row_offset(k);
                col_index = col_tmp + col_offset(k);
                if (row_index > 15) || (col_index > 15) || (pos_num_bkgd(row_index,col_index) == 0)
                    continue; 
                end
            
                dis_x = position(j,2) - position_bkgd(col_index,2);
                dis_y = position(i,1) - position_bkgd(row_index,1);
                dis = sqrt(power(dis_x,2) + power(dis_y,2));
            
                if dis < dis_min
                    dis_min = dis;
                    mapped_bkgd(pos_num(i,j),:) = number_bkgd(:,pos_num_bkgd(row_index,col_index) + 1);
                    mapping_pos(row_index,col_index) = pos_num(i,j);
                end
            
            end
            
        end
        
        xstep_tmp = xstep_tmp + xstep2;
        
    end
    
    ystep_tmp = ystep_tmp + ystep2;
    
end

end