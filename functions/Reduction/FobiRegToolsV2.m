function [TL2,yL2,y0L2,t_merged] = FobiRegToolsV2(y,y0,t,tmax,nrep,ChopperId,lambda,flag_smooth,roll)
%FULL_FOB_REDUCTION Summary of this function goes here
%   Detailed explanation goes here
if exist('roll','var') == 0
    roll=0;
end
if exist('flag_smooth','var') == 0
    flag_smooth=0;
end
if exist('lambda','var') == 0
    lambda = 0.5;
end
% figure(999), plot(t,y), hold on
dt = diff(t);
dt = dt(2);
tD=t(1):dt:tmax;
% plot(t,y), hold on
%% choose time delays
switch ChopperId
    case 'POLDI'
        D = FobiPoldiTimeDelays(tD);
    case '4x10'
        D = Fobi4x10TimeDelays(tD);
    case '5x8'
        D = Fobi5x8TimeDelays(tD);
    otherwise 
        disp('Please select chopper')
end
%% v1 cut time delays
% figure, plot(tD,D)
% D = D(1:length(y));
% figure, plot(t,D)
%% v2 add constant to readoutgap
y = [y; nanmean(y)*ones(length(tD)-length(y),1)];
y0 = [y0; nanmean(y0)*ones(length(tD)-length(y0),1)];
% figure(999), plot(tD,y), hold on
%%
n = round(length(tD)/nrep);
for i=1:n
    A(i,:) = circshift(D,i-1);
end
A=A';
% figure, imagesc(A')
L2 = get_l(n,2);
[U,s,V] = cgsvd(A,L2);

%%
if(flag_smooth)
    sp = 3;
    y = smooth(y,sp);
    y0 = smooth(y0,sp);
end
% plot(t,y), hold on

yL2 = tikhonov(U,s,V,y,lambda);
y0L2 = tikhonov(U,s,V,y0,lambda);
TL2 = yL2./y0L2;
% figure, plot(y0L2)
yL2 = circshift(yL2,roll);
y0L2 = circshift(y0L2,roll);
TL2 = circshift(TL2,roll);

t_merged = t(1:n);
end

