% 1. Konfiguracja początkowa
modelName = 'model_RC_filtr_simscape'; % WPISZ TUTAJ NAZWĘ SWOJEGO PLIKU .slx (bez rozszerzenia)

% Zdefiniuj wektor częstotliwości (np. od 1 Hz do 100 kHz, skala logarytmiczna)
f_vec = logspace(0, 5, 50); 
A_out = zeros(size(f_vec)); % Prealokacja wektora na wyniki
A_in = 1; % Zakładamy amplitudę wejściową 1 V. Jeśli jest inna, zmień tę wartość.

% Załadowanie modelu w tle
load_system(modelName);

% Inicjalizacja paska postępu
h_waitbar = waitbar(0, 'Inicjalizacja symulacji...');
num_steps = length(f_vec);

% 2. Pętla symulacyjna
for i = 1:length(f_vec)
    f0 = f_vec(i);
    t_sim = 10 / f0;
    
    % Aktualizacja paska postępu
    progress = i / num_steps;
    waitbar(progress, h_waitbar, sprintf('Symulacja w toku... %d%% (Krok %d z %d)', round(progress*100), i, num_steps));

    % Uruchomienie symulacji
    simOut = sim(modelName);
    
    % --- EKSTRAKCJA WYNIKÓW ---
    % Odczyt z przestrzeni roboczej (z bloku out.V_capacitor)
    t = simOut.V_capacitor.Time(:);
    v = simOut.V_capacitor.Data(:);
    
    % Wyodrębnienie stanu ustalonego (odrzucamy pierwszą połowę symulacji)
    idx_steady_state = t > (t_sim / 2);
    v_steady = v(idx_steady_state);
    
    % Obliczenie amplitudy w stanie ustalonym: (max - min) / 2
    A_out(i) = (max(v_steady) - min(v_steady)) / 2;
end

% 3. Obliczenie wzmocnienia i rysowanie wykresu
Gain_dB = 20 * log10(A_out / A_in);

figure;
semilogx(f_vec, Gain_dB, 'LineWidth', 2);
grid on;
title('Charakterystyka amplitudowa filtra RC');
xlabel('Częstotliwość (Hz)');
ylabel('Wzmocnienie (dB)');
xlim([min(f_vec) max(f_vec)]);