function [] = MergeDataMcp(id,Nbins,reps,test,frq,saveid)
%MERGEDATAMCP Summary of this function goes here
%   Detailed explanation goes here
if(test==1)
    tof = zeros(512,512,length(reps));
    j = 10;
    z=0;
    counts = 0;
    for i=reps
        z=z+1;
        sdir = dir(fullfile([id '/' num2str(i) '/Corrected/'],'*.fits'));
        txts = dir(fullfile([id '/' num2str(i) filesep],'*.txt'));
        shutcounts_txt = load([txts(1).folder filesep txts(1).name]);
        counts = counts + shutcounts_txt(1,2);
        spectrum_txt = load([txts(3).folder filesep txts(3).name]);
        tof(:,:,z) = fitsread([sdir(j).folder filesep sdir(j).name]);
        figure, imagesc(tof(:,:,z)), colorbar, title(['Rep ' num2str(i)])
        figure(199), plot(spectrum_txt(:,1),spectrum_txt(:,2)), hold on
    end
    legend, grid, title('Uncorrected spectra')
    Slicer(tof)
    I = nansum(tof,3)*frq/counts;
    figure, imagesc(I), colorbar, title('Merged Frame')
    figure, plot(squeeze(nanmean(nanmean(tof,2),1)),'-x'), title('Total counts vs rep'), grid
end

if(test==0)
    I=zeros(512,512,Nbins);
    for j = 1:Nbins
        disp(['Merging ToF #' num2str(j)])
        z=0;
        tof = zeros(512,512,length(reps));
        counts = 0;
        for i=reps
            z=z+1;
            sdir = dir(fullfile([id '/' num2str(i) '/Corrected/'],'*.fits'));
            txts = dir(fullfile([id '/' num2str(i) filesep],'*.txt'));
            shutcounts_txt = load([txts(1).folder filesep txts(1).name]);
            counts = counts + shutcounts_txt(1,2);
            if(z==1)
                spectrum_tof = load([txts(3).folder filesep txts(3).name]);
                spectrum_tof = spectrum_tof(:,1);
            end
            tof(:,:,z) = fitsread([sdir(j).folder filesep sdir(j).name]);
        end
        I(:,:,j) = nansum(tof,3)*frq/counts;
        clear tof
    end
    save([saveid '.mat'],'I')
    save([saveid '_spectrum_tof.mat'],'spectrum_tof')
    figure, imagesc(nanmean(I,3)), colorbar, title('Merged Frame')
end

end

