% Skrypt z przykładem
clear; clc; close all;

% --- 1. PARAMETRY MODELU ---
A = [0 1; -1 0];
t_span = [0, 10];
n_points = 1000; 

% Przygotowanie głównego okna
figure('Name', 'Analiza Układu Dynamicznego', 'NumberTitle', 'off', 'Position', [100, 100, 1200, 600]);

% --- 2. RYSOWANIE TŁA (Siatki i Pole wektorowe) ---
% Płaszczyzna Fazowa (lewa strona)
subplot(2, 2, [1 3]); 
hold on; grid on; axis equal; axis([-5 5 -5 5]);
xlabel('x_1'); ylabel('x_2');
title('Płaszczyzna Fazowa (x_2 vs x_1)');

[X1, X2] = meshgrid(-5:0.5:5, -5:0.5:5);
DX1 = A(1,1)*X1 + A(1,2)*X2;
DX2 = A(2,1)*X1 + A(2,2)*X2;
quiver(X1, X2, DX1, DX2, 'Color', [0.8 0.8 0.8]);

% Wykresy czasowe (prawa strona - puste osie)
subplot(2, 2, 2);
hold on; grid on; xlabel('t [s]'); ylabel('x_1(t)'); title('Zmienna stanu x_1 w czasie');

subplot(2, 2, 4);
hold on; grid on; xlabel('t [s]'); ylabel('x_2(t)'); title('Zmienna stanu x_2 w czasie');

% --- 3. GŁÓWNA PĘTLA OBLICZENIOWA ---
disp('Kliknij na płaszczyźnie fazowej (po lewej), aby wyznaczyć trajektorię.');
disp('Naciśnij klawisz Enter w oknie płaszczyzny, aby zakończyć.');

while true
    % Aktywacja lewego okna i pobranie punktu
    subplot(2, 2, [1 3]);
    [x1_0, x2_0, button] = ginput(1);
    
    % Przerwanie pętli po wciśnięciu Enter
    if isempty(button)
        break; 
    end
    
    % Definicja warunku początkowego
    x0 = [x1_0; x2_0];
    
    % ROZWIĄZANIE MATEMATYCZNE
    [t, x] = solve_model(A, x0, t_span, n_points);
    
    % --- 4. RYSOWANIE WYNIKÓW Z SYNCHRONIZACJĄ KOLORÓW ---
    
    % Rysujemy trajektorię i pobieramy jej parametry do zmiennej 'p'
    subplot(2, 2, [1 3]);
    p = plot(x(1,:), x(2,:), 'LineWidth', 1.5);
    
    % Pobieramy aktualny kolor z narysowanej linii
    aktualny_kolor = p.Color; 
    
    % Rysujemy punkt startowy wypełniony tym samym kolorem
    plot(x0(1), x0(2), 'ko', 'MarkerFaceColor', aktualny_kolor, 'MarkerSize', 6);
    
    % Przebieg x1(t) z wymuszonym kolorem
    subplot(2, 2, 2);
    plot(t, x(1,:), 'LineWidth', 1.5, 'Color', aktualny_kolor);
    
    % Przebieg x2(t) z wymuszonym kolorem
    subplot(2, 2, 4);
    plot(t, x(2,:), 'LineWidth', 1.5, 'Color', aktualny_kolor);
end

disp('Zakończono działanie skryptu.');