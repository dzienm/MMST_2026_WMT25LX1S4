function [t, x] = solve_model(A, x0, t_span, n)
    % solve_model - Ścisłe rozwiązanie liniowego układu równań x' = Ax
    %
    % Argumenty:
    % A      - macierz układu (2x2)
    % x0     - wektor warunków początkowych [x1_0; x2_0]
    % t_span - zakres czasu symulacji, np. [0, 10]
    % n      - stopień dyskretyzacji

    % Wygenerowanie wektora czasu (1000 punktów dla gładkiego wykresu)
    t = linspace(t_span(1), t_span(2), n);
    
    % Inicjalizacja macierzy na wyniki
    x = zeros(length(x0), length(t));
    
    % Obliczenie ścisłego rozwiązania z wykorzystaniem macierzy eksponencjalnej
    for i = 1:length(t)
        x(:, i) = expm(A * t(i)) * x0;
    end
end