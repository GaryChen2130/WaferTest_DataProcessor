%% Read in file
clear;

BaLafile = '../XRF/PR-15_BaLa.xlsm';
HfLafile = '../XRF/PR-15_HfLa.xlsm';
MoKafile = '../XRF/PR-15_MoKa.xlsm';
TaLafile = '../XRF/PR-15_TaLa.xlsm';
TiKafile = '../XRF/PR-15_TiKa.xlsm';
ZrKafile = '../XRF/PR-15_ZrKa.xlsm';
XRDfile = '../XRD/RS5H.xlsm';

[number_bala, text_bala, rawData_bala] = xlsread(BaLafile,'PR-15_BaLa','A1:BY225');
[number_hfla, text_hfla, rawData_hfla] = xlsread(HfLafile,'PR-15_HfLa','A1:BY225');
[number_moka, text_moka, rawData_moka] = xlsread(MoKafile,'PR-15_MoKa','A1:BY225');
[number_tala, text_tala, rawData_tala] = xlsread(TaLafile,'PR-15_TaLa','A1:BY225');
[number_tika, text_tika, rawData_tika] = xlsread(TiKafile,'PR-15_TiKa','A1:BY225');
[number_zrka, text_zrka, rawData_zrka] = xlsread(ZrKafile,'PR-15_ZrKa','A1:BY225');
[number_xrd, text_xrd, rawData_xrd] = xlsread(XRDfile,'RS5H','A1:CW3342');

%% Map XRF points to XRD points  (7.9mm, 8.1mm) / (1mm, 1mm)
row_index = 152;
col_index = 2;
row_end = 152;
col_end = 2;
row_cnt = 152;
col_cnt = 2;
row_cnt_p = 152;
col_cnt_p = 2;
row_step = 4.05;

cnt = 1;
data_bala = zeros(1,100);
data_hfla = zeros(1,100);
data_moka = zeros(1,100);
data_tala = zeros(1,100);
data_tika = zeros(1,100);
data_zrka = zeros(1,100);

while (row_index < 225) && (col_index < 77)
    
    while row_cnt - row_cnt_p < row_step
        row_end = row_end + 1;
        row_cnt = row_cnt + 1;
    end
    
    col_step = 3.95;
    while col_index <= 77
        
        while col_cnt - col_cnt_p < col_step
            col_end = col_end + 1;
            col_cnt = col_cnt + 1;
        end

        point_cnt = 0;
        row_tmp = row_index;
        while row_tmp < row_end
           
           col_tmp = col_index;
           while col_tmp < col_end
               
                data_bala(cnt) = data_bala(cnt) + number_bala(row_tmp,col_tmp);
                data_hfla(cnt) = data_hfla(cnt) + number_hfla(row_tmp,col_tmp);
                data_moka(cnt) = data_moka(cnt) + number_moka(row_tmp,col_tmp);
                data_tala(cnt) = data_tala(cnt) + number_tala(row_tmp,col_tmp);
                data_tika(cnt) = data_tika(cnt) + number_tika(row_tmp,col_tmp);
                data_zrka(cnt) = data_zrka(cnt) + number_zrka(row_tmp,col_tmp);
                
                point_cnt = point_cnt + 1;
                col_tmp = col_tmp + 1;
                if col_tmp > 77
                    break;
                end
                
           end
           
           row_tmp = row_tmp + 1;
           if row_tmp > 225
               break;
           end
           
        end
        
        data_bala(cnt) = data_bala(cnt)/point_cnt;
        data_hfla(cnt) = data_hfla(cnt)/point_cnt;
        data_moka(cnt) = data_moka(cnt)/point_cnt;
        data_tala(cnt) = data_tala(cnt)/point_cnt;
        data_tika(cnt) = data_tika(cnt)/point_cnt;
        data_zrka(cnt) = data_zrka(cnt)/point_cnt;
        cnt = cnt + 1;

        col_index = col_tmp;
        col_cnt_p = col_cnt_p + col_step;
        col_step = 7.9;
        
    end
    
    % Advance row index
    row_index = row_tmp;
    row_cnt_p = row_cnt_p + row_step;
    row_step = 8.1;
    
    % Reset column index
    col_index = 2;
    col_end = 2;
    col_cnt = 2;
    col_cnt_p = 2;
    
end

%% Plot XRF
index = zeros(1,100);
for i = 1:100
   index(i) = i; 
end

figure(1)
subplot(2,3,1)
plot(index,data_bala);
xlabel('points number') 
ylabel('PR-15 BaLa') 

subplot(2,3,2)
plot(index,data_hfla);
xlabel('points number') 
ylabel('PR-15 HfLa') 

subplot(2,3,3)
plot(index,data_moka);
xlabel('points number') 
ylabel('PR-15 MoKa') 

subplot(2,3,4)
plot(index,data_tala);
xlabel('points number') 
ylabel('PR-15 TaLa') 

subplot(2,3,5)
plot(index,data_tika);
xlabel('points number') 
ylabel('PR-15 TiKa') 

subplot(2,3,6)
plot(index,data_zrka);
xlabel('points number') 
ylabel('PR-15 ZrKa') 


%% Plot XRD with XRF
figure(2)
zz = number_xrd(2:3342,2:101);

subplot(2,3,1)
[xx,yy] = meshgrid(number_xrd(2:3342,1)', data_bala(1,1:100));
plot3(xx', yy', zz)
xlabel('2-theta(degree)') 
ylabel('PR-15 BaLa')

subplot(2,3,2)
[xx,yy] = meshgrid(number_xrd(2:3342,1)', data_hfla(1,1:100));
plot3(xx', yy', zz)
xlabel('2-theta(degree)') 
ylabel('PR-15 HfLa')

subplot(2,3,3)
[xx,yy] = meshgrid(number_xrd(2:3342,1)', data_moka(1,1:100));
plot3(xx', yy', zz)
xlabel('2-theta(degree)') 
ylabel('PR-15 MoKa')

subplot(2,3,4)
[xx,yy] = meshgrid(number_xrd(2:3342,1)', data_tala(1,1:100));
plot3(xx', yy', zz)
xlabel('2-theta(degree)') 
ylabel('PR-15 TaLa')

subplot(2,3,5)
[xx,yy] = meshgrid(number_xrd(2:3342,1)', data_tika(1,1:100));
plot3(xx', yy', zz)
xlabel('2-theta(degree)') 
ylabel('PR-15 TiKa')

subplot(2,3,6)
[xx,yy] = meshgrid(number_xrd(2:3342,1)', data_zrka(1,1:100));
plot3(xx', yy', zz)
xlabel('2-theta(degree)') 
ylabel('PR-15 ZrKa')


%% Plot XRD and XRF for a given point
x = input('Input which point to plot\n');

figure(3);
subplot(1,2,1)
plot(number_xrd(2:3342,1),number_xrd(2:3342,x + 1));
xlabel('2-theta(degree)')
ylabel('Intensity(arb.units)')

subplot(1,2,2)
bar_data = [data_bala(x);data_hfla(x);data_moka(x);data_tala(x);data_tika(x);data_zrka(x)];
bar(bar_data)
xlabel('Element')
ylabel('Density')
set(gca, 'xticklabel', {'BaLa','HfLa','MoKa', 'TaLa', 'TiKa', 'ZrKa'});


%% Plot XRD and XRF for multipe points
n = input('Input how many point to plot\n');
record = zeros(n);

figure(4);
subplot(1,2,1)
for i = 1:n
    x = input('Input which point to plot\n');
    record(i) = x;
    plt = plot(number_xrd(2:3342,1),number_xrd(2:3342,x + 1));
    hold on;
end

lgd = num2str(record(1:n)','point %d');
legend(lgd)

hold off;

subplot(1,2,2)

