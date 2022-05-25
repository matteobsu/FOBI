function [image_out,spectrum_out] = RebinTOF(image,spectrum,rebinning_order,operation)
%UNTITLED Summary of this function goes here
%Detailed explanation goes here
tof_n = size(image,3);
tof_n_new = round(tof_n / rebinning_order)-1;
image_out = zeros(size(image,1),size(image,2), tof_n_new);
spectrum_out = zeros(tof_n_new,1);
for i =1:tof_n_new
    if (strcmp(operation,'sum'))
        image_out(:,:,i) = nansum(image(:, :, rebinning_order * (i-1)+1:rebinning_order * i),3);
        spectrum_out(i) = nanmean(spectrum(rebinning_order * (i-1)+1:rebinning_order * i ));
    else if (strcmp(operation,'mean'))
        image_out(:,:,i) = nanmean(image(:, :, rebinning_order * (i-1)+1:rebinning_order * i ),3);
        spectrum_out(i) = nanmean(spectrum(rebinning_order * (i-1)+1:rebinning_order * i ));
        end
    end
end
end