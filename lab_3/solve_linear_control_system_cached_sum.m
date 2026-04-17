function x = solve_linear_control_system_cached_sum(A, B, x0, u, t)
% Rozwiazuje uklad:
%   x_dot = A*x + B*u
%
% Korzystamy jawnie ze wzoru:
%   x(t) = expm(A*t)*x0 + expm(A*t) * int_0^t expm(-A*tau)*B*u(tau) dtau
%
% Calka jest aproksymowana suma prostokatow:
%   S_k = sum_{j=1}^{k-1} expm(-A*t_j) * B * u_j * dt_j
%
% Zamiast liczyc cala sume od nowa dla kazdego k,
% przechowujemy sume skumulowana.

    A = double(A);
    B = double(B);
    x0 = double(x0(:));
    t = double(t(:));
    u = double(u);

    [n, n2] = size(A);
    if n ~= n2
        error('A musi byc macierza kwadratowa.');
    end

    [nB, m] = size(B);
    if nB ~= n
        error('B musi miec rozmiar (n x m).');
    end

    if length(x0) ~= n
        error('x0 musi miec rozmiar (n x 1).');
    end

    if length(t) < 2
        error('Wektor t musi miec co najmniej 2 elementy.');
    end

    if any(diff(t) <= 0)
        error('Wektor t musi byc scisle rosnacy.');
    end

    if m == 1
        u = u(:);
        if length(u) ~= length(t)
            error('Dla jednego wejscia u musi miec length(t) elementow.');
        end
    else
        [Nu, mu] = size(u);
        if Nu ~= length(t) || mu ~= m
            error('u musi miec rozmiar (length(t) x m).');
        end
    end

    N = length(t);
    x = zeros(N, n);

    % S_1 = 0
    suma = zeros(n, 1);

    for k = 1:N
        tk = t(k);
        Phi_k = expm(A * tk);

        % x(t_k) = expm(A*tk) * x0 + expm(A*tk) * suma
        x(k, :) = (Phi_k * x0 + Phi_k * suma).';

        % aktualizacja sumy do kolejnego kroku:
        % S_{k+1} = S_k + expm(-A*t_k) * B * u_k * dt_k
        if k < N
            dtk = t(k+1) - t(k);

            if m == 1
                uk = u(k);          % skalar
            else
                uk = u(k, :).';     % wektor m x 1
            end

            suma = suma + expm(-A * tk) * B * uk * dtk;
        end
    end
end