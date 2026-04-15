function x = solve_linear_control_system(A, B, x0, u, t)
% Rozwiazuje uklad:
%   x_dot = A*x + B*u
%
% Korzystamy jawnie ze wzoru:
%   x(t) = expm(A*t)*x0 + expm(A*t) * int_0^t expm(-A*tau)*B*u(tau) dtau
%
% Calka jest aproksymowana suma.
%
% Wejscie:
%   A  - macierz stanu (n x n)
%   B  - macierz wejscia (n x m)
%   x0 - warunek poczatkowy (n x 1)
%   u  - probki sterowania (N x m) lub (N x 1)
%   t  - wektor czasu (N x 1) lub (1 x N)
%
% Wyjscie:
%   x  - trajektoria stanu (N x n)

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

    % Jesli jedno wejscie, dopuszczamy tez u jako wektor
    if isvector(u)
        u = u(:);
        if m ~= 1
            error('Wektor u mozna podac tylko dla ukladu z jednym wejsciem.');
        end
    end

    N = length(t);
    [Nu, mu] = size(u);

    if Nu ~= N || mu ~= m
        error('u musi miec rozmiar (length(t) x m).');
    end

    x = zeros(N, n);

    % x(t_1) = x(0) = x0, zakladamy zwykle t(1)=0
    % ale ponizszy kod zadziala tez dla innego t(1)
    for k = 1:N
        tk = t(k);

        % pierwszy skladnik: exp(A tk) x0
        Phi_k = expm(A * tk);

        % drugi skladnik: exp(A tk) * suma_j exp(-A tj) B u_j dt_j
        suma = zeros(n, 1);

        for j = 1:(k-1)
            tj = t(j);
            dtj = t(j+1) - t(j);


            [du1, du2] = size(u);
            if min(du1,du2)==1
                uj = u(j);
            else
                uj = u(j, :).';
            end

            suma = suma + expm(-A * tj) * B * uj * dtj;
        end

        x(k, :) = Phi_k * x0 + Phi_k * suma;
    end

    x = x.';   % wynik jako (N x n)
end