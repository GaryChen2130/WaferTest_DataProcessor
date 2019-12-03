function test177

global mode;
mode = 2;

ReadPos2('../data_Xuyen/rs11_XRD_map.xlsx','RS11-Position','A2:C90',6.333,31.667,6.333,31.667)
ReadPosBKGD('../data_Xuyen2/RS-11/Position_xy/xy_coordination.xlsx','Sheet1','A2:B178',4.5,31.5,4.5,31.5)
ReadBKGD('../data_Xuyen2/RS-11/RS11.xlsx','RS11')
ReadXRF177
ReadIMP2('../data_Xuyen/4_point/RS11_20190509083509.xlsm','RS11_20190509083509');
Map177to100(4.5,4.5,6.333,6.333)
%PlotBKGD_XRF()

FindPeak(2.45,0.15,2)
%FindPeak177(2.45,0.15,2)
%FindPeak(2.946)
%FindPeak(3.83)

end