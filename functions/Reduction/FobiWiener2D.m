function [T,y_rec,y0_rec,t_merged] = FobiWiener2D(I,I0,t,tmax,nrep,c,flag_smooth,roll)
%FULL_FOB_REDUCTION Summary of this function goes here
%   Detailed explanation goes here
siz = size(I);
if nargin<8
    roll=0;
    if nargin<7
        flag_smooth=0;
        if(nargin<6)
            c = 0.1;
        end
    end
end

y = squeeze(I(round(siz(1)/2),round(siz(2)/2),:));
y0 = squeeze(I0(round(siz(1)/2),round(siz(2)/2),:));
[y,tn] = interpolate_noreadoutgaps(y,t,tmax,nrep,0);
[y0,tn] = interpolate_noreadoutgaps(y0,t,tmax,nrep,0);
%% choose time delays
% D = FobiPoldiTimeDelays(tn);
% D = Fobi4x10TimeDelays(tn);
D = Fobi5x8TimeDelays(tn);

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

        y0rec = wiener_deconvolution(y0,D,c);
        yrec = wiener_deconvolution(y,D,c);
        Trec = yrec./y0rec;

        replen = length(y)/nrep;
        for ii=1:nrep
            yover(:,ii) = yrec(replen*(ii-1)+1:replen*ii);
            y0over(:,ii) = y0rec(replen*(ii-1)+1:replen*ii);
            Tover(:,ii) = Trec(replen*(ii-1)+1:replen*ii);
        end
        yrec_merged = nanmean(yover,2);
        y0rec_merged = nanmean(y0over,2);
        Trec_merged = nanmean(Tover,2);

        yrec_merged = circshift(yrec_merged,roll);
        y0rec_merged = circshift(y0rec_merged,roll);
        Trec_merged = circshift(Trec_merged,roll);

        T(i,j,:)=Trec_merged;
        y_rec(i,j,:)=yrec_merged;
        y0_rec(i,j,:)=y0rec_merged;
    end
end
t_merged = tn(1:replen);

end

