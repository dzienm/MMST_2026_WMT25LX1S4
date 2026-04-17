clear; clc; close all;

% 1. Definicja parametrów układu (te zmienne "zobaczy" Twój model .slx)
R_val = 1000;  % [Ohm]
C_val = 1e-6;  % [F]

f_0 = 100;

% Wektor częstotliwości do przebadania
czestotliwosci = logspace(0, 4, 30); % Od 1 Hz do 10 kHz
amplitudy_wyjsciowe = zeros(size(czestotliwosci));

%zmienna pomocnicza do paska postepu
dlugosc_poprzedniego_tekstu = 0;

disp('Rozpoczynam symulację seryjną modelu Simscape...');

% 2. Pętla symulacyjna
for i = 1:length(czestotliwosci)
    % Ustawiamy aktualną częstotliwość dla źródła AC w Simulinku
    f_0 = czestotliwosci(i);
    
    % Obliczamy potrzebny czas symulacji (aby minął stan przejściowy)
    T_sygnalu = 1 / f_0;
    t_end = 5 * (R_val * C_val) + 3 * T_sygnalu; 
    
    % URUCHOMIENIE SIMULINKA Z POZIOMU SKRYPTU
    % Używamy funkcji sim(), przekazując nazwę pliku i czas trwania
    simOut = sim('RC_filter_simulink_model', 'StopTime', num2str(t_end));
    
    % 3. Pobranie i obróbka wyników z bloku "To Workspace"
    % Wyniki zapisują się w obiekcie simOut. Wyciągamy czas i napięcie
    t = simOut.tout;          
    y = simOut.V_out;         
    
    % Analiza amplitudy (mierzymy tylko z ostatniego okresu)
    idx_ostatni_okres = t >= (t_end - T_sygnalu);
    y_ustalone = y.Data(idx_ostatni_okres);
    
    % Wyliczenie amplitudy (połowa rozstępu między minimum a maksimum)
    amplituda = (max(y_ustalone) - min(y_ustalone)) / 2;
    amplitudy_wyjsciowe(i) = amplituda;
    
    %  --- RAPORTOWANIE POSTĘPU ---
    
    % A. Przygotowujemy nowy tekst do wyświetlenia (sprintf nie drukuje, tylko tworzy string)
    nowy_tekst = sprintf('Symulacja w toku... %d/%d (Aktualnie: %.1f Hz)', i, length(czestotliwosci), f_0);
    
    % B. Kasujemy stary tekst drukując odpowiednią liczbę znaków "backspace" (\b)
    % Funkcja repmat powiela znak '\b' tyle razy, ile liter miał stary tekst
    fprintf(repmat('\b', 1, dlugosc_poprzedniego_tekstu));
    
    % C. Drukujemy nowy tekst w miejsce starego
    fprintf('%s', nowy_tekst);
    
    % D. Zapisujemy długość obecnego tekstu dla następnego kroku pętli
    dlugosc_poprzedniego_tekstu = length(nowy_tekst);
end

% 4. Rysowanie wykresu Bodego
figure('Name', 'Bode z Simulinka');
semilogx(czestotliwosci, 20*log10(amplitudy_wyjsciowe), 'bo-', 'LineWidth', 1.5);
grid on;
title('Charakterystyka Amplitudowa Filtra RC (Model Simscape)');
xlabel('Częstotliwość [Hz]');
ylabel('Amplituda [dB]');
axis([1 10000 -40 5]);
disp('Gotowe!');