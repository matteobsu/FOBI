function phi2D = PhaseFractionFit2D(lac, spectrum, phase1lac, phase2lac, phase_spectrum, lambda_range_norm, lambda_range_fit, mask, test)
% phase_fraction_fit: Fit a phase fraction ratio to a spectrum
% lac - Original spectrum
% spectrum - Wavelengths corresponding to the spectrum
% phase1lac - Spectrum of phase 1
% phase2lac - Spectrum of phase 2
% phase_spectrum - Wavelengths corresponding to the phase spectra
% lambda_range_norm - Range for normalization
% lambda_range_fit - Range for fitting
% plotflag - Flag to control plotting

s = size(lac);
if exist('test','var') == 0
    test=0;
end
if exist('mask','var') == 0
    mask=ones(s);
end
phi2D = zeros(s(1),s(2));

if test
            data = squeeze(lac(test(1),test(2),:));
            data = smooth(data,9,'sgolay');
    PhaseFractionFit(data, spectrum, phase1lac, phase2lac, phase_spectrum, lambda_range_norm, lambda_range_fit, 1)
    return
end

for i=1:s(1)
    disp(['Fitting row:' num2str(i) '/' num2str(s(1))])
    for j=1:s(2)
        if mask(i,j)==1
            data = abs(squeeze(lac(i,j,:)));
            data = smooth(data,9,'sgolay');
            if(iscomplex(data))
                phi=nan;
            else
            [phi] = PhaseFractionFit(data, spectrum, phase1lac, phase2lac, phase_spectrum, lambda_range_norm, lambda_range_fit, 0);
            phi2D(i,j) = phi;
            end
        else
            phi2D(i,j) = nan;
        end
%             pause()
    end
end
end