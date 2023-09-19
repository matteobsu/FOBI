function E = SabinePrimaryExtinction(S, l, l_hkl)
    N = length(l);
    theta = asin(l ./ l_hkl);
    theta(iscomplex(theta))=0;
    x = S^2 .* (l).^2;
    E = zeros(1, N);
    for i = 1:N
        if(iscomplex(theta(i)))
            theta(i)=0;
        end
        E_B = 1 / sqrt(1 + x(i));
        if (x(i) > 1)
            E_L = sqrt(2 / (pi * x(i))) * (1 - 1 / (8 * x(i)) - 3 / (128 * x(i)^2) - 15 / (1024 * x(i)^3));
        else
            E_L = 1 - x(i) / 2 + x(i)^2 / 4 - 5 * x(i)^3 / 48 + 7 * x(i)^4 / 192;
        end
        E(i) = E_L * cos(theta(i))^2 + E_B * sin(theta(i))^2;
    end
    id = find_nearest(l,l_hkl);
    E(id:end)=1;
end