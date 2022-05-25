function [Trec_merged,yrec_merged,y0rec_merged,t_merged] = FobiWiener(y,y0,t,tmax,nrep,ChopperId,c,flag_smooth,roll)
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
    
    method = 'rlowess';
    sp = 0.0025;
    if(flag_smooth)
        y = smooth(y,sp,method);
        y0 = smooth(y0,sp,method);
    end
    
    pr = 0;
    [y0,t_merged] = interpolate_noreadoutgaps(y0,t,tmax,nrep,pr);
    [y,~] = interpolate_noreadoutgaps(y,t,tmax,nrep,pr);
    
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
    
    yrec = nslits*nrep*wiener_deconvolution(y,D,c);
    y0rec = nslits*nrep*wiener_deconvolution(y0,D,c);
    % Trec = yrec./y0rec; %direct T deconvolution seems to give heigher edges
    Trec = nslits.*wiener_deconvolution(y./y0,D,c);
    
    % figure, plot(Trec)
    
    yrec_merged = circshift(yrec,roll);
    y0rec_merged = circshift(y0rec,roll);
    Trec_merged = circshift(Trec,roll);
    
    end