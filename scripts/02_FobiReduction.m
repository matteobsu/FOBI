clear all
close all
%% update paths
load OB.mat; I0 = I; %path to open beam
load AlSiC.mat %path to Sample
load AlSiC_spectrum_tof.mat %path to time-of-flight (or lambda after calibration) spectrum

%% cropping out POLDI blind spots
I([1:150 400:end],:,:)=[];
I0([1:150 400:end],:,:)=[];
%% FOBI reduction 
% First is better try on a large integrated area to see how it looks; you
% can either select your region from the code and use FobiWiener, or use
% FobiWienerRoipoly and select region from figure
t=spectrum_tof;
tmax= 0.03;% for POLDI
nrep= 4;% for POLDI
ChopperId = 'POLDI';
c= 1e-1; %Wiener constant\
flag_smooth=1;
roll = 165; %will shift the spectra so that it is re-centered

FobiWienerRoipoly(I,I0,t,tmax,nrep,ChopperId,c,flag_smooth,roll)

%% applying here moving average
kernel = [100,20];
I0_filter = DataFiltering(I0,kernel,'movingaverage');
I_filter = DataFiltering(I,kernel,'movingaverage');

figure, 
subplot(1,2,1), imagesc(nanmean(I,3)), title('Raw')
subplot(1,2,2), imagesc(nanmean(I_filter,3)), title('Filtered')
%%
% region_x = 100:200;
% region_y = 100:200;
% y=squeeze(nanmean(nanmean(I_filter(region_x,region_y,:),2),1)); %,nan sample spectrum
% y0=squeeze(nanmean(nanmean(I0_filter(region_x,region_y,:),2),1)); %open beam spectrum
% FobiWiener(y,y0,t,tmax,nrep,ChopperId,c,flag_smooth,roll)

% then you can perform it for the 2D ToF images stacks.
[T_fobi,~,~,t_merged]=FobiWiener2D(I_filter,I0_filter,t,tmax,nrep,ChopperId,c,flag_smooth,roll);
% alternatively try FobiRegTools / FobiRegTools2D
% moving average or gaussian filtering might be necessary to have enough
% stastics

%% Edge Fitting
signal = smooth(squeeze(T_fobi(150,400,:))); %bragg pattern
spectrum = t_merged; %tof or lambda spectrum
spectrum_range =[0 10]; %restrict spectrum to a desired window
est_p = 4.8e-3; %estimated position BC_p boundary conditions
est_w = 4.4e-5; %estimated Bragg width BC_w boundary conditions
est_h = 3e-3; %estimated Bragg height BC_h boundary conditions
pr =1; % printing option
BC_p = [4e-3 5.4e-3];
BC_w = [0 1e-3];
BC_h = [0 1e-1];
[pos,w,h]=EdgeFitGaussian(signal,spectrum,spectrum_range,est_p,est_w,est_h,BC_p,BC_w,BC_h,pr)
% after testing for a single spectrum go ahead and do it spatially
% resolved:
%[p,w,h] = EdgeFitGaussian2D(T_fobi,spectrum,spectrum_range,est_p,est_w,est_h,BC_p,BC_w,BC_h,mask);

%%
figure, imagesc(p), caxis([4.7e-3 4.9e-3]), colorbar, axis equal tight
figure, imagesc(w), colorbar, axis equal tight,% caxis([4.7e-3 4.9e-3])
figure, imagesc(h), colorbar, axis equal tight,% caxis([4.7e-3 4.9e-3])