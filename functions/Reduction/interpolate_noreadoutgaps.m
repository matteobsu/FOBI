function [y_extended,t_merged] = interpolate_noreadoutgaps(y,t,tmax,nrep,plot_flag)
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
%% get tof bin width, figure length and merge overlaps
replen = ceil(length(y)/nrep);
t_tot = linspace(t(1),tmax,nrep*replen);
y_int = interp1(t,y,t_tot);
y_overlap = zeros(replen,nrep);

for i=1:nrep
    y_overlap(:,i) = y_int(replen*(i-1)+1:replen*i);
end
y_merged = nanmean(y_overlap,2);
y_extended = y_merged;
for i=1:nrep-1
    y_extended = [y_extended; y_merged];
end
t_merged = t_tot(1:replen*nrep);

if(plot_flag)
    figure
    for i=1:nrep
        plot(t(1:replen),y_overlap(:,i)), hold on
    end
    plot(t(1:replen),y_merged,'k'),
end

end

