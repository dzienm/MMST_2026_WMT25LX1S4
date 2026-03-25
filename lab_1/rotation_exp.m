function R = rotation_exp(theta, n)

    % Jednostkowy wektor osi
    n = n(:) / norm(n);

    % Generatory obrotu
    sigma_x = [ 0  0   0;
                0  0  -1;
                0  1   0 ];

    sigma_y = [ 0  0   1;
                0  0   0;
               -1  0   0 ];

    sigma_z = [ 0  -1  0;
                1   0  0;
                0   0  0 ];

    % Liniowa kombinacja
    S = n(1)*sigma_x + n(2)*sigma_y + n(3)*sigma_z;

    % Macierz obrotu przez exp(θ S)
    R = expm(theta * S);

end
