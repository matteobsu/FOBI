function [Trec_merged,yrec_merged,y0rec_merged,t_merged] = FobiWiener(y,y0,t,tmax,nrep,ChopperId,c,filter,roll,flag_smooth)
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
        filter = 'none';
    end
    %% reformat arrays
    y = squeeze(y);
    if(size(y,2)>1)
        y=y';
    end
    y0 = squeeze(y0);
    if(size(y0,2)>1)
        y0=y0';
    end
    t = squeeze(t);
    if(size(t,2)>1)
        t=t';
    end
    %%
    if(flag_smooth)
        sp = 3;
        y = smooth(y,sp);
        y0 = smooth(y0,sp);
    end
    pr = 1;
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
        case '3x14'
            D = Fobi3x14TimeDelays(t_merged);
            nslits = 14;
        case 'manual'
            D = FobiManual(t_merged);
            nslits = 42;
        otherwise 
            disp('Please select chopper')
    end
    %%
    yrec = nslits*nrep*wiener_deconvolution(y,D,c,filter);
    y0rec = nslits*nrep*wiener_deconvolution(y0,D,c,filter);
    % Trec = yrec./y0rec; %direct T deconvolution seems to give heigher edges
    Trec = nslits.*wiener_deconvolution(y./y0,D,c,filter);
    
    % figure, plot(Trec)
    
    yrec_merged = circshift(yrec,roll);
    y0rec_merged = circshift(y0rec,roll);
    Trec_merged = circshift(Trec,roll);
    
    end