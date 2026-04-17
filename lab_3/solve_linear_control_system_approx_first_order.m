function x = solve_linear_control_system_approx_first_order(A, B, x0, u, t)
% Rozwiazuje:
%   x_dot = A*x + B*u
%
% Metoda krokowa:
%   x_k = Phi_k x_{k-1} + Gamma_k u_{k-1}
%
% gdzie:
%   Phi_k   = expm(A*dt)
%   Gamma_k = integral_0^dt expm(A*s) ds * B \approx exp(0)*B*dt = B*dt
%
% Dla wejscia stalego na przedziale [t(k-1), t(k)].

    A = double(A);
    B = double(B);
    x0 = double(x0(:));
    t  = double(t(:));
    u  = double(u);

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

    if isvector(u)
        if m ~= 1
            error('Wektor u mozna podac tylko dla ukladu z jednym wejsciem.');
        end
        u = u(:);
    end

    N = length(t);
    [Nu, mu] = size(u);

    if Nu ~= N || mu ~= m
        error('u musi miec rozmiar (length(t) x m).');
    end

    x = zeros(N, n);
    x(1, :) = x0.';

    for k = 2:N
        dt = t(k) - t(k-1);
        Phi = expm(A * dt);
        Gamma = eye(n)* dt;
        
        if m == 1
            ukm1 = u(k-1);
        else
            ukm1 = u(k-1, :).';
        end
        
        x_prev = x(k-1, :).';
        x_curr = Phi * x_prev + Phi *Gamma * B* ukm1;
        x(k, :) = x_curr.';
    end
end