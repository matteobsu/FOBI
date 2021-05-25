function [TL2,yL2,y0L2,t_merged] = FobiRegToolsRoi(I,I0,t,tmax,nrep,ChopperId,lambda,flag_smooth,roll,roi)
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

y0 = SpectrumRoi(I0,roi);
y = SpectrumRoi(I,roi);
[y,~] = interpolate_noreadoutgaps(y,t,tmax,nrep,0);
[y0,tn] = interpolate_noreadoutgaps(y0,t,tmax,nrep,0);
%% choose time delays
switch ChopperId
    case 'POLDI'
        D = FobiPoldiTimeDelays(tn);
    case '4x10'
        D = Fobi4x10TimeDelays(tn);
    case '5x8'
        D = Fobi5x8TimeDelays(tn);
    otherwise 
        disp('Please select chopper')
end
%%

n = round(length(tn)/nrep);
for i=1:n
    A(i,:) = circshift(D,i-1);
end
A=A';
L2 = get_l(n,2);
[U,s,V] = cgsvd(A,L2);

%%
if(flag_smooth)
    y = smooth(y);
    y0 = smooth(y0);
end

yL2 = tikhonov(U,s,V,y,lambda);
y0L2 = tikhonov(U,s,V,y0,lambda);
TL2 = yL2./y0L2;
%TL2 =  tikhonov(U,s,V,y./y0,lambda);

yL2 = circshift(yL2,roll);
y0L2 = circshift(y0L2,roll);
TL2 = circshift(TL2,roll);

t_merged = tn(1:n);

figure,
subplot(2,1,1), plot(t_merged,y0L2), hold on, plot(t_merged,yL2),
legend('Open beam','Sample')
subplot(2,1,2), plot(t_merged,TL2),
legend('Transmission')
end

