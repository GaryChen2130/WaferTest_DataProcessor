%% Read in file
clear;
xlsFile = '../XRD/RS5H.xlsm';
[number, text, rawData] = xlsread(xlsFile,'RS5H','A1:CW3342');
row_num = 3342;
col_num = 101;


%% Plot single point
x = input('Input which point to plot\n');
figure(1);
plot(number(2:row_num,1),number(2:row_num,x + 1));


%% Plot multipe point
n = input('Input how many point to plot\n');
record = zeros(n);

figure(2);
for i = 1:n

    x = input('Input which point to plot\n');
    record(i) = x;
    x_vec = zeros(3341,1);
    x_vec(1:3341) = x;
    plt = plot3(x_vec,number(2:3342,1),number(2:3342,x + 1));
    hold on;

end

axis([0, 105, -inf, inf]);
lgd = num2str(record(1:n)','point %d');
legend(lgd)

hold off;


%% Plot all points
figure(3)
[xx,yy] = meshgrid(number(2:row_num,1)', number(1,2:101));
zz = number(2:row_num,2:101);
plot3(xx', yy', zz)
