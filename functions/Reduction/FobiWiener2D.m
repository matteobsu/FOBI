function [T,y_rec,y0_rec,t_merged] = FobiWiener2D(I,I0,t,tmax,nrep,ChopperId,c,filter,roll,flag_smooth)
%FULL_FOB_REDUCTION Summary of this function goes here
%   Detailed explanation goes here
if exist('roll','var') == 0
    roll=0;
end
if exist('flag_smooth','var') == 0
    flag_smooth=0;
end
if exist('c','var') == 0
    c = 0.1;
end
if exist('filter','var') == 0
    filter = 'LowPassBu';
end

siz = size(I);
y0 = squeeze(I0(round(siz(1)/2),round(siz(2)/2),:));
[~,t_merged] = interpolate_noreadoutgaps(y0,t,tmax,nrep,0);
%% choose time delays
switch ChopperId
case 'POLDI'
    D = FobiPoldiTimeDelays(t_merged);
    nslits = 8;
case '4x10'
    D = Fobi4x10TimeDelays(t_merged);
    nslits = 10;
case '5x8'
    D = Fobi5x8TimeDelays(t_merged);
    nslits = 8;
otherwise 
    disp('Please select chopper')
end
%%

for i=1:siz(1)
    disp(['FOBI reduction of row:' num2str(i) '/' num2str(siz(1))])
    for j=1:siz(2)
        y = squeeze(I(i,j,:));
        y0 = squeeze(I0(i,j,:));    
        
        if(flag_smooth)
            method = 'rlowess';
            sp = 0.0025;
            y = smooth(y,sp,method);
            y0 = smooth(y0,sp,method);
        end

		[y,~] = interpolate_noreadoutgaps(y,t,tmax,nrep,0);
		[y0,~] = interpolate_noreadoutgaps(y0,t,tmax,nrep,0);

        yrec = nslits*nrep*wiener_deconvolution(y,D,c,filter);
        y0rec = nslits*nrep*wiener_deconvolution(y0,D,c,filter);
        % Trec = yrec./y0rec; %direct T deconvolution seems to give heigher edges
        Trec = nslits*wiener_deconvolution(y./y0,D,c,filter);
        yrec_merged = circshift(yrec,roll);
        y0rec_merged = circshift(y0rec,roll);
        Trec_merged = circshift(Trec,roll);

        T(i,j,:)=Trec_merged;
        y_rec(i,j,:)=yrec_merged;
        y0_rec(i,j,:)=y0rec_merged;
    end
end

end

