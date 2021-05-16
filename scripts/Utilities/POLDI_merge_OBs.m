clear all
close all
%% registering open beams with detector shift
load Processed/OB1.mat
OB1=I;
load Processed/OB2.mat
OB2=I; clear I

figure, imagesc(OB1(:,:,1)./OB2(:,:,1)), caxis([0 4])
figure, imagesc(OB1(:,:,1)),
figure, imagesc(OB1(:,:,2)),
figure, imagesc(OB1(:,:,3)),
OB1 = InterpBadPixels(OB1);
OB2 = InterpBadPixels(OB2);

figure, imagesc(OB1(:,:,2)./OB2(:,:,2))
figure, imagesc(OB1(:,:,1)),
figure, imagesc(OB1(:,:,2)),
figure, imagesc(OB1(:,:,3)),

OB1 = circshift(OB1,(405-383),1);
figure, plot(squeeze(nanmean(nanmean(OB1,3),2)))
hold on
plot(squeeze(nanmean(nanmean(OB2,3),2)))

I = 0.5*(OB1+OB2);