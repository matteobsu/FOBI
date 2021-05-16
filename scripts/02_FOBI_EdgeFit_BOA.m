clear all
close all
%% update paths
load Processed/OB.mat; I0 = I; %path to open beam
load Processed/FeCu.mat %path to Sample
load Processed/FeCu_spectrum_tof.mat %path to time-of-flight (or lambda after calibration) spectrum
%% correcting for bad pixels
I0 = InterpBadPixels(I0);
I = InterpBadPixels(I);
%%
t=spectrum_tof;
tmax= 0.04;% for POLDI
nrep= 4;% for POLDI
ChopperId = '4x10';
c= 1e-1; %Wiener constant\
roll = -27;

figure, imagesc(nanmean(I,3)./nanmean(I0,3)), title('Transmission Image'), axis equal tight, caxis([0.1 1]),
%% mask out sample
% maskCu = MaskRoipoly(I,I0);
% maskFe = MaskRoipoly(I,I0);
% maskFeonly = maskFe-maskCu;
load Processed/masks_FeCu.mat
%% FOBI reduction 
% First is better try on a large integrated area to see how it looks; you
% can either select your region from the code and use FobiWiener, or use
% FobiWienerRoipoly and select region from figure
I0 = DataFiltering(I0,[50 50],'movingaverage');
T = FobiWienerRoipoly(I,I0,t,tmax,nrep,ChopperId,c,flag_smooth,roll);
figure, plot(smooth(1./T))
%%
% then you can perform it for the 2D ToF images stacks.
dirname = 'FeCu_25x25';
mkdir(['FOBI_tifs\' dirname])

kernel = [25,25];
I0_filter = DataFiltering(I0,kernel,'movingaverage');
I_filter = DataFiltering(I,kernel,'movingaverage');

flag_smooth=1;
[T_fobi,~,~,t_merged]=FobiWiener2D(I_filter,I0_filter,t,tmax,nrep,ChopperId,c,flag_smooth,roll);

writetiffstack(T_fobi,['FOBI_tifs\' dirname '\T_'],'float')
save(['Processed/' dirname '_Fobi.mat'],'T_fobi')
% alternatively try FobiRegTools / FobiRegTools2D
% moving average or gaussian filtering might be necessary to have enough
% stastics

%% applying here moving average
kernel = [5,5];
T_filter = DataFiltering(T_fobi,kernel,'movingaverage');

figure, 
subplot(1,2,1), imagesc(nanmean(T_fobi,3)), title('Raw'), axis equal tight, caxis([0 1])
subplot(1,2,2), imagesc(nanmean(T_filter,3)), title('Filtered'), axis equal tight, caxis([0 1])
%% Edge fitting
signal = squeeze(T_fobi(300,300,:)); %bragg pattern
signal = signal;
spectrum = t_merged; %tof or lambda spectrum
spectrum_range =[1e-3 9e-3]; %restrict spectrum to a desired window
est_p = 5.4e-3; %estimated position BC_p boundary conditions
est_w = 8.4e-5; %estimated Bragg width BC_w boundary conditions
est_h = 2e-2; %estimated Bragg height BC_h boundary conditions
BC_p = [5.2e-3 5.6e-3];
BC_w = [0 1e-3];
BC_h = [0 1e-1];
pr = 1;
[pos,w,h]=EdgeFitGaussian(signal,spectrum,spectrum_range,est_p,est_w,est_h,BC_p,BC_w,BC_h,pr)
% after testing for a single spectrum go ahead and do it spatially
% resolved:
%%
spectrum_range =[1e-3 9e-3]; %restrict spectrum to a desired window
est_p = 5.2e-3; %estimated position BC_p boundary conditions
est_w = 4.4e-5; %estimated Bragg width BC_w boundary conditions
est_h = 4e-2; %estimated Bragg height BC_h boundary conditions
BC_p = [5.0e-3 5.4e-3];
BC_w = [0 1e-3];
BC_h = [0 1e-1];
[p1,w1,h1] = EdgeFitGaussian2D(T_fobi,t_merged,spectrum_range,est_p,est_w,est_h,BC_p,BC_w,BC_h,maskFe);
figure, imagesc(imgaussfilt(p1,3)), colorbar, axis equal tight
figure, imagesc(w1), colorbar, axis equal tight,% caxis([4.7e-3 4.9e-3])
figure, imagesc(h1), colorbar, axis equal tight,% caxis([4.7e-3 4.9e-3])
%%
est_p = 2.1e-3; %estimated position BC_p boundary conditions
est_w = 4.4e-5; %estimated Bragg width BC_w boundary conditions
est_h = 1e-2; %estimated Bragg height BC_h boundary conditions
BC_p = [1.9e-3 2.3e-3];
BC_w = [0 1e-3];
BC_h = [0 1e-1];
[p2,w2,h2] = EdgeFitGaussian2D(T_fobi,t_merged,spectrum_range,est_p,est_w,est_h,BC_p,BC_w,BC_h,maskFe);
figure, imagesc(p2), axis equal tight
figure, imagesc(w2), colorbar, axis equal tight,% caxis([4.7e-3 4.9e-3])
figure, imagesc(h2), colorbar, axis equal tight,% caxis([4.7e-3 4.9e-3])
%%
est_p = 5.4e-3; %estimated position BC_p boundary conditions
est_w = 8.4e-5; %estimated Bragg width BC_w boundary conditions
est_h = 2e-2; %estimated Bragg height BC_h boundary conditions
BC_p = [5.2e-3 5.6e-3];
BC_w = [0 1e-3];
BC_h = [0 1e-1];
[p3,w3,h3] = EdgeFitGaussian2D(T_fobi,t_merged,spectrum_range,est_p,est_w,est_h,BC_p,BC_w,BC_h,maskCu);
figure, imagesc(p3), axis equal tight
figure, imagesc(w3), colorbar, axis equal tight,% caxis([4.7e-3 4.9e-3])
figure, imagesc(h3), colorbar, axis equal tight,% caxis([4.7e-3 4.9e-3])
%% Horizontally moving window method
close all
clear pos wid he
flag_smooth=1;
spectrum_range =[1e-3 6e-3]; %restrict spectrum to a desired window
est_p = 4.5e-3; %estimated position BC_p boundary conditions
% est_p = 1.3e-3; %estimated position BC_p boundary conditions
% est_p = 2.1e-3; %estimated position BC_p boundary conditions
est_w = 4.4e-5; %estimated Bragg width BC_w boundary conditions
est_h = 1e-2; %estimated Bragg height BC_h boundary conditions
BC_p = [4.2e-3 4.8e-3];
% BC_p = [1.1e-3 1.5e-3];
% BC_p = [1.9e-3 2.3e-3];
BC_w = [0 1e-3];
BC_h = [0 1e-1];

region_x = 110:150;
w = 50;
zz = 0;

pr=0;   
for i=w/2:1:512-w/2
    zz=zz+1;
    disp(['Fitting column:' num2str(i) '/' num2str(512-w/2)])
    region_y = (i-w/2+1):(i+w/2);
    y=squeeze(nanmean(nanmean(I(region_x,region_y,:),2),1)); %,nan sample spectrum
    y0=squeeze(nanmean(nanmean(I0(region_x,region_y,:),2),1)); %open beam spectrum
    [T_fobi,y_fobi,y0_fobi,t_merged]=FobiWiener(y,y0,t,tmax,nrep,ChopperId,c,flag_smooth,roll);
    [pos(zz),wid(zz),he(zz)]=EdgeFitGaussian(smooth(T_fobi),t_merged,spectrum_range,est_p,est_w,est_h,BC_p,BC_w,BC_h,pr);   
end
figure, 
subplot(3,1,1), plot(0.055*[w/2:1:512-w/2],pos,'-.')
subplot(3,1,2), plot(0.055*[w/2:1:512-w/2],he,'-.')
subplot(3,1,3), plot(0.055*[w/2:1:512-w/2],wid,'-.')

figure, 
plot(0.055*[w/2:1:512-w/2],pos,'.')
