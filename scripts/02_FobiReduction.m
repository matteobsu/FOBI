clear all
close all
%% update paths
load OB.mat; I0 = I; %path to open beam
load AlSiC.mat %path to Sample
load AlSiC_spectrum_tof.mat %path to time-of-flight (or lambda after calibration) spectrum

I([1:150 400:end],:,:)=[];
I0([1:150 400:end],:,:)=[];
%% FOBI reduction 
% First is better try on a large integrated area to see how it looks; you
% can either select your region from the code and use FobiWiener, or use
% FobiWienerRoipoly and select region from figure
t=spectrum_tof;
tmax= 0.03;
nrep= 4;% for POLDI
ChopperId = 'POLDI';
c= 1e-1; %Wiener constant\
flag_smooth=1;
roll = 165; 

FobiWienerRoipoly(I,I0,t,tmax,nrep,ChopperId,c,flag_smooth,roll)

size_x = 100;
size_y = 20;
K = ones(size_x,size_y,1);
K = K./sum(K(:));
I0_filter = convn(I0,K,'same');
I_filter = convn(I,K,'same');

figure, imagesc(nanmean(I_filter,3))
figure, imagesc(nanmean(I,3))

% y=nan sample spectrum
% y0= open beam spectrum
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