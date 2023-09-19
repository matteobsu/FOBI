function phi = PhaseFractionFit(lac, spectrum, phase1lac, phase2lac, phase_spectrum, lambda_range_norm, lambda_range_fit, plotflag)
% phase_fraction_fit: Fit a phase fraction ratio to a spectrum
% lac - Original spectrum
% spectrum - Wavelengths corresponding to the spectrum
% phase1lac - Spectrum of phase 1
% phase2lac - Spectrum of phase 2
% phase_spectrum - Wavelengths corresponding to the phase spectra
% lambda_range_norm - Range for normalization
% lambda_range_fit - Range for fitting
% plotflag - Flag to control plotting

if nargin < 8
    plotflag = 0;
end

% Cut to the selected range for normalization
idx_low_norm = find_nearest(spectrum, lambda_range_norm(1));
idx_high_norm = find_nearest(spectrum, lambda_range_norm(2));
lac_norm = lac(idx_low_norm:idx_high_norm);

% Prepare reference tables
idx_low_norm = find_nearest(phase_spectrum, lambda_range_norm(1));
idx_high_norm = find_nearest(phase_spectrum, lambda_range_norm(2));
phase1lac_norm = phase1lac(idx_low_norm:idx_high_norm);
phase2lac_norm = phase2lac(idx_low_norm:idx_high_norm);
phase1lac_normalized = phase1lac * mean(lac_norm) / mean(phase1lac_norm);
phase2lac_normalized = phase2lac * mean(lac_norm) / mean(phase2lac_norm);

phase1lac_interp = interp1(phase_spectrum, phase1lac_normalized, spectrum, 'linear');
phase2lac_interp = interp1(phase_spectrum, phase2lac_normalized, spectrum, 'linear');

% Cut the original spectrum for fitting
idx_low_fit = find_nearest(spectrum, lambda_range_fit(1));
idx_high_fit = find_nearest(spectrum, lambda_range_fit(2));
lac_fit = lac(idx_low_fit:idx_high_fit);
phase1lac_fit = phase1lac_interp(idx_low_fit:idx_high_fit);
phase2lac_fit = phase2lac_interp(idx_low_fit:idx_high_fit);
spectrum_fit = spectrum(idx_low_fit:idx_high_fit);

if isrow(lac_fit) && isrow(phase1lac_fit) && isrow(phase2lac_fit)
else
    % Treat A and B as row vectors
    lac_fit = lac_fit(:)';
    phase1lac_fit = phase1lac_fit(:)';
    phase2lac_fit = phase2lac_fit(:)';
end

% Define the cost function to return the sum of squared differences
cost = @(prms) sum((lac_fit - (prms(1) * phase1lac_fit + (1 - prms(1)) * phase2lac_fit)).^2);
% cost = @(prms) sum((prms(3) + prms(2)*lac_fit - (prms(1) * phase1lac_fit + (1 - prms(1)) * phase2lac_fit)).^2);

% Set upper and lower boundaries
lb = [0];
ub = [1];
prms0 = [0.5];
% lb = [0 -inf -inf];
% ub = [1 inf inf];
% prms0 = [0.5 0 0];
% Options for the optimization
options = optimset('Display', 'none');

% Perform the optimization
prms = fmincon(cost, prms0, [], [], [], [], lb, ub, [], options);

phi = prms(1);
% slope = prms(2);
% off = prms(3);
if plotflag
    % Plot the results
    cmap = brewermap(3, 'set1');
    figure;
    plot(spectrum, lac, 'color', cmap(1, :));
    hold on;
%     plot(spectrum, off+slope*lac, 'color', cmap(1, :),'linestyle','--');
    plot(spectrum, phase1lac_interp, 'color', cmap(2, :), 'linestyle', '-.');
    plot(spectrum, phase2lac_interp, 'color', cmap(3, :), 'linestyle', '-.');
    plot(spectrum(idx_low_fit:idx_high_fit),phi * phase1lac_fit + (1 - phi) * phase2lac_fit, 'color', 'k', 'linestyle', '-');
    xlim([spectrum(1), spectrum(end)]);
    title(['$\phi$ = ' num2str(phi)]);
    legend('$\mu$', '$\mu_{\mathrm{ph1}}$', '$\mu_{\mathrm{ph2}}$', '$\mu_{\phi}$');
    xlabel('$\lambda$ ($\AA$)');
    ylabel('Attenuation');
    grid on;
end
end