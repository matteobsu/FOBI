function [TL2,yL2,y0L2,t_merged] = FobiRegTools2D(I,I0,t,tmax,nrep,lambda,flag_smooth,roll)
%FULL_FOB_REDUCTION Summary of this function goes here
%   Detailed explanation goes here
siz = size(I);
if nargin<8
    roll=0;
    if nargin<7
        flag_smooth=0;
        if(nargin<6)
            lambda = 0.5;
        end
    end
end
y = squeeze(I(round(siz(1)/2),round(siz(2)/2),:));
y0 = squeeze(I0(round(siz(1)/2),round(siz(2)/2),:));
[y,tn] = interpolate_noreadoutgaps(y,t,tmax,nrep,0);
[y0,tn] = interpolate_noreadoutgaps(y0,t,tmax,nrep,0);
%% choose time delays
% D = FobiPoldiTimeDelays(tn);
D = Fobi4x10TimeDelays(tn);
% D = Fobi5x8TimeDelays(tn);
%%

n = round(length(tn)/nrep);
for i=1:n
    A(i,:) = circshift(D,i-1);
end
A=A';
L2 = get_l(n,2);
[U,s,V] = cgsvd(A,L2);

for i=1:siz(1)
    disp(['FOBI reduction of row:' num2str(i) '/' num2str(siz(1))])
    for j=1:siz(2)
        y = squeeze(I(i,j,:));
        y0 = squeeze(I0(i,j,:));
		[y,tn] = interpolate_noreadoutgaps(y,t,tmax,nrep,0);
		[y0,tn] = interpolate_noreadoutgaps(y0,t,tmax,nrep,0);
        if(flag_smooth)
			y = smooth(y);
			y0 = smooth(y0);
		end

		b = tikhonov(U,s,V,y,lambda);
		c = tikhonov(U,s,V,y0,lambda);
		a = b./c;

		b = circshift(b,roll);
		c = circshift(c,roll);
		a = circshift(a,roll);

		d = tn(1:n);
        TL2(i,j,:)=a;
        yL2(i,j,:)=b;
        y0L2(i,j,:)=c;
    end
end
t_merged = d;
end