function [TL2,yL2,y0L2,t_merged] = FobiRegTools(y,y0,t,tmax,nrep,lambda,flag_smooth,roll)
%FULL_FOB_REDUCTION Summary of this function goes here
%   Detailed explanation goes here
if nargin<8
    roll=0;
    if nargin<7
        flag_smooth=0;
        if(nargin<6)
            lambda = 0.5;
        end
    end
end
[y,tn] = interpolate_noreadoutgaps(y,t,tmax,nrep,0);
[y0,tn] = interpolate_noreadoutgaps(y0,t,tmax,nrep,0);
%% choose time delays
% D = FobiPoldiTimeDelays(tn);
% D = Fobi4x10TimeDelays(tn);
D = Fobi5x8TimeDelays(tn);
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

yL2 = circshift(yL2,roll);
y0L2 = circshift(y0L2,roll);
TL2 = circshift(TL2,roll);

t_merged = tn(1:n);
end

