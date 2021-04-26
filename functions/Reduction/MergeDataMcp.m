function [] = MergeDataMcp(id,Nbins,reps,test,frq,saveid)
%MERGEDATAMCP Summary of this function goes here
%   Detailed explanation goes here
if(test==1)
    tof = zeros(512,512,length(reps));
    j = 10;
    for i=reps
        z=z+1;
        sdir = dir(fullfile([id '/' num2str(i) '/Corrected/'],'*.fits'));
        txts = dir(fullfile([id '/' num2str(i) filesep],'*.txt'));
        shutcounts_txt = load([txts(1).folder filesep txts(1).name]);
        counts = shutcounts_txt(1,2);
        tof(:,:,z) = fitsread([sdir(j).folder filesep sdir(j).name])/(counts/frq);
        figure, imagesc(tof(:,:,z))
    end
    figure(199), plot(squeeze(nanmean(nanmean(tof,2),1))), hold on
    I = nanmean(tof,3);
    figure, imagesc(I)
end

if(test==0)
    I=zeros(512,512,Nbins);
    for j = 1:Nbins
        disp(['ToF #' num2str(j)])
        z=0;
        tof = zeros(512,512,length(reps));
        for i=reps
            z=z+1;
            sdir = dir(fullfile([id '/' num2str(i) '/Corrected/'],'*.fits'));
            txts = dir(fullfile([id '/' num2str(i) filesep],'*.txt'));
            shutcounts_txt = load([txts(1).folder filesep txts(1).name]);
            counts = shutcounts_txt(1,2);
            tof(:,:,z) = fitsread([sdir(j).folder filesep sdir(j).name])/(counts/frq);
        end
        I(:,:,j) = nanmean(tof,3);
        clear tof
    end
    save([saveid '.mat'],'I')
    figure, imagesc(nanmean(I,3))
end

end

