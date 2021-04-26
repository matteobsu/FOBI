clear all
close all

%% 1 Sort data from MCP and perform overlap correction, please place all the files from the same acquisition (e.g. OpenBeam,Sample1,...) in a folder
maindir = 'OpenBeam'; %path to folder
nfiles = 1400; %number of files per repetition (including txt). Useful so the function will check that there was no issues
PathTpxCorr = 'C:\Users\busi_m\Desktop\Tremsin_overlap_Program-ANDBatchCreator\TPX_CubeRead.exe';
SortDataMcp(maindir,nfiles,PathTpxCorr);
%when this is done a batch file for the overlap correction will be written,
%please run it from the command prompt of windows (windows+r cmd)

%% 2 Merge Data
maindir = 'OpenBeam';%path to folder
saveid = 'OpenBeam';
Nbins = 1500; %numberofbins
frq = 25; %chopper frequency
reps = [1:9]; % select folders (start with all)
test = 1; %we first check the datasets in case we need to discard some
MergeDataMcp(maindir,Nbins,reps,test,frq,saveid)

reps = [1:9]; % select folders from the test
test = 0; % now we merge and save file
MergeDataMcp(maindir,Nbins,reps,test,frq,saveid)

%% FOBI reduction
% you can first try on a large integrated area to see how it looks;
% y= sample spectrum
% y0= open beam spectrum
% t= tof bins: load from spectrum.txt
% tmax= 
% nrep= 4 for POLDI
% c= 1e-1 Wiener constant
% FobiWiener(y,y0,t,tmax,nrep,c,flag_smooth,roll)
% then you can perform it for the 2D ToF images stacks.
% FobiWiener2D(I,I0,t,tmax,nrep,c,flag_smooth,roll)
% alternatively try FobiRegTools / FobiRegTools2D
% moving average or gaussian filtering might be necessary to have enough
% stastics

%% Edge Fitting
% signal = bragg pattern
% spectrum = tof or lambda spectrum
% spectrum_range = restrict spectrum to a desired window
% est_p = estimated position BC_p boundary conditions
% est_w = estimated Bragg width BC_w boundary conditions
% est_h = estimated Bragg height BC_h boundary conditions
% pr = printing option
%EdgeFitGaussian(signal,spectrum,spectrum_range,est_p,est_w,est_h,BC_p,BC_w,BC_h,pr);
% after testing for a single spectrum go ahead and do it spatially
% resolved:
%EdgeFitGaussian2D(data,spectrum,spectrum_range,est_p,est_w,est_h,BC_p,BC_w,BC_h,mask)