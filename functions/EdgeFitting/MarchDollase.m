function P = MarchDollase(A, R, l, l_hkl, Nbeta, bool_plotPole)
    % A : angle between the hkl plane and preferred orientation
    theta = asin(l / l_hkl);
    beta = linspace(0, 2 * pi, Nbeta);
    [Theta, Beta] = meshgrid(theta, beta);
    B = cos(A) * sin(Theta) + sin(A) * (cos(Theta) .* sin(Beta));
    P = sum((R.^2 .* B.^2 + (1 - B.^2) ./ R).^(-3/2), 1) / Nbeta;
    P(isnan(P)) = 1;
    if bool_plotPole
        figure;
        imagesc((R.^2 .* B.^2 + (1 - B.^2) ./ R).^(-3/2));
        colorbar;
        title('Pole Figure');
        xlabel('l');
        ylabel('Beta');
        figure;
        plot(l, P);
        title('Intensity vs. l');
        xlabel('l');
        ylabel('Intensity');
    end
end