% Skrypt z przykładem
clear; clc; close all;

% Parametry filtra RC
R = 1e3;       % 1 kOhm
C = 1e-6;      % 1 uF

% Model stanu: q_dot = -(1/RC) q + (1/R) u
A = -1/(R*C);
B = 1/R;

% Amplituda wejscia
U0 = 1;

% Zakres czestosci kolowych
omega = logspace(1, 5, 40);   % 10 ... 1e5 rad/s

% Wektor na wynik
gain = zeros(size(omega));

% Parametry symulacji
samples_per_period = 200;   % liczba probek na okres
n_periods_total    = 40;    % liczba okresow do symulacji
steady_part         = 0.2;  % ostatnie 20% probek

%dt=0.00001;

for i = 1:length(omega)
    w = omega(i);
    T = 2*pi / w;

    % Czas symulacji dopasowany do aktualnej czestosci
    dt = T / samples_per_period;
    %dt = min(T / samples_per_period, 0.0001);
    t_end = n_periods_total * T;
    t = 0:dt:t_end;

    % Sygnał wejsciowy
    u = U0 * sin(w * t);

    % Warunek poczatkowy: ladunek
    x0 = 0;

    % Symulacja stanu q(t)
    q = solve_linear_control_system_approx_first_order(A, B, x0, u, t);
    %q = solve_linear_control_system_approx_nth_order_ex_2(A, B, x0, u, t, 8);
    %q = solve_linear_control_system_exact(A, B, x0, u, t);

    % Napiecie na kondensatorze: uC = q/C
    uC = q / C;

    % Wyznaczenie amplitudy w stanie ustalonym
    n_tail = max(10, round(steady_part * length(t)));
    uC_ss = uC((end-n_tail)+1:end);

    amp_out = (max(uC_ss) - min(uC_ss)) / 2;

    % Stosunek amplitud
    gain(i) = amp_out / U0;
end

% Wykres charakterystyki amplitudowej
figure;
semilogx(omega, gain, 'LineWidth', 1.5);
grid on;
xlabel('\omega [rad/s]');
ylabel('A_{out} / A_{in}');
title('Charakterystyka amplitudowa filtra RC z symulacji czasowej');

% Czestotliwosc graniczna do orientacji
omega_c = 1/(R*C);
hold on;
xline(omega_c, '--', '\omega_c');

