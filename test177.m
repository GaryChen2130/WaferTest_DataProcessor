function test177

global mode;
mode = 2;

% For RS11
%==============================================================================================================
% ReadPos2('../data_Xuyen/rs11_XRD_map.xlsx','RS11-Position','A2:C90',6.333,31.667,6.333,31.667)
% ReadPosBKGD('../data_Xuyen2/RS-11/Position_xy/xy_coordination.xlsx','Sheet1','A2:B178',4.5,31.5,4.5,31.5)
% ReadBKGD('../data_Xuyen2/RS-11/RS11.xlsx','RS11')
% Map177to100(4.5,4.5,6.333,6.333)
% 
% ReadXRF2
% ReadXRF177
% ReadIMP2('../data_Xuyen/4_point/RS11_20190509083509.xlsm','RS11_20190509083509');

%PlotBKGD_XRF()

%FindPeak(2.45,0.15,2)
%FindPeak177(2.45,0.15,2)

%FindPeak(2.946,0.05,1)
%FindPeak177(2.946,0.05,1)

%FindPeak(3.83,0.08,1)
%FindPeak177(3.83,0.08,1)
%==============================================================================================================


% For RS12
%==============================================================================================================
% ReadPos2('../data_Xuyen/rs11_XRD_map.xlsx','RS11-Position','A2:C90',6.333,31.667,6.333,31.667)
% ReadPosBKGD('../data_Xuyen2/RS-11/Position_xy/xy_coordination.xlsx','Sheet1','A2:B178',4.5,31.5,4.5,31.5)
% ReadBKGD('../data_Xuyen2/RS-12/RS-12.xlsx','RS12')
% Map177to100(4.5,4.5,6.333,6.333)
% 
% ReadXRF2
% ReadXRF177
% ReadIMP2('../data_Xuyen/4_point/RS12_20190509101926.xlsm','RS12_20190509101926');

%PlotBKGD_XRF()

%FindPeak(2.53,0.03,1)
%FindPeak177(2.53,0.03,1)

%FindPeak(2.42,0.05,1)
%FindPeak177(2.42,0.05,1)

%FindPeak(3.85,0.02,1)
%FindPeak177(3.85,0.02,1)
%==============================================================================================================

% For SP7
%==============================================================================================================
ReadPos2('../data_Xuyen/sp7_XRD_map.xlsx','Sheet1','A2:C90',6.333,31.667,6.333,31.667);
ReadPosBKGD('../data_Xuyen2/RS-11/Position_xy/xy_coordination.xlsx','Sheet1','A2:B178',4.5,31.5,4.5,31.5)
ReadBKGD('../data_Xuyen2/SP-7/Sp-7.xlsx','SP7')
Map177to100(4.5,4.5,6.333,6.333)

ReadXRF2
ReadXRF177
ReadIMP2('../data_Xuyen/4_point/SP07_20190409213225.xlsm','SP07_20190409213225');

%==============================================================================================================

end