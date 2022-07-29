function [y_merged,t_merged] = interpolate_noreadoutgaps_MCP(y,t,tmax,nrep,plot_flag)
    %INTERPOLATE_NOREADOUTGAPS Summary of this function goes here
    %   Detailed explanation goes here
    %% reformat arrays
    y = squeeze(y);
    if(size(y,2)>1)
        y=y';
    end
    t = squeeze(t);
    if(size(t,2)>1)
        t=t';
    end
    
    %% last bin is typically bad :(
%     y(end)=[];
%     t(end)=[];
    %% get tof bin width, figure length and merge overlaps
    replen = ceil(length(y)/nrep);
    t_tot = linspace(t(1),tmax,nrep*replen);
    y_int = interp1(t,y,t_tot);
    y_overlap = zeros(replen,nrep);
    
    %interpolate here readout gap
%     y_int(end-length(y_int(isnan(y_int))):end)=0.5*y_int(replen-length(y_int(isnan(y_int))):replen)+0.5*y_int(3*replen-length(y_int(isnan(y_int))):3*replen);
    
    for i=1:(nrep)
        y_overlap(:,i) = y_int(replen*(i-1)+1:replen*i);
    end
%     y_merged = nanmean(y_overlap,2);
    y_merged = nanmedian(y_overlap,2);


    % y_merged = nanmedian(y_overlap,2); %% median gives more artifact. not a
    % good idea
    t_merged = t_tot(1:replen);
    
    if(plot_flag)
        figure
        for i=1:nrep
            plot(t(1:replen),y_overlap(:,i)), hold on
        end
        plot(t(1:replen),y_merged,'k'),
    end
    
    end