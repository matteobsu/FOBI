function [ynew,tnew] = interpolate_readoutgaps_v2(y,t0,tmax,cut_bins,plot_flag)
%INTERPOLATE_READOUTGAPS Summary of this function goes here
%   Detailed explanation goes here
if(nargin<5)
    plot_flag=0;
end
y = squeeze(y);
if(size(y,2)>1)
    y=y';
end
t0 = squeeze(t0);
if(size(t0,2)>1)
    t0=t0';
end

dt = diff(t0);
[gaps,gaps_idx] = findpeaks(diff(t0),'Threshold',mean(diff(t0)));
y_new0 = []; j=1;
for i=1:length(gaps_idx)
    
    y_new0 = [y_new0; y(j:gaps_idx(i)); nan*zeros(round(gaps(i)/dt(gaps_idx(i)-1)),1)];
    j = gaps_idx(i)+1;
end
y_new0 = [y_new0; y(j:end)];

y_new5 = []; j=1;
for i=1:length(gaps_idx)
    if(i==1)
        y_new5 = [y_new5; y(j:gaps_idx(i)); nan*zeros(cut_bins+round(gaps(i)/dt(gaps_idx(i)-1)),1)];
    else
        y_new5 = [y_new5; y(cut_bins+j:gaps_idx(i)); nan*zeros(cut_bins+round(gaps(i)/dt(gaps_idx(i)-1)),1)];
    end
    j = gaps_idx(i)+1;
end
y_new5 = [y_new5; y(cut_bins+j:end); nan*zeros(round((tmax-t0(end))/dt(gaps_idx(i)-1)),1)];

if(plot_flag)
    figure, plot(y_new0,'-.'), hold on, plot(y_new5),
    title('total signal')
    legend('Truncated Signal','Good Signal')
end

if(plot_flag)
    figure,
end
y_new5 = imresize(y_new5,[length(y_new5)*round(length(y_new5)/4)/(length(y_new5)/4),1]);
for i = 1:4
    if(plot_flag)
        plot(y_new5(1+(i-1)*length(y_new5)/4:i*length(y_new5)/4)), hold on
    end
    ynewnew(:,i) = y_new5(1+(i-1)*length(y_new5)/4:i*length(y_new5)/4);
end
if(plot_flag)
    plot(nanmean(ynewnew,2),'color','k','linestyle','-.')
    legend('Frame 1','Frame 2','Frame 3','Frame 4','Merged')
end
ynew = nanmean(ynewnew,2);
% if(plot_flag)
%     figure, plot(tnew,nanmean(ynewnew,2),'color','k')
% end

ynew = [ynew; ynew; ynew; ynew];
tnew = linspace(0,tmax,length(ynew));
end

