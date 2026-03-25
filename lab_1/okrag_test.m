% -----------------------------------------------------
% Test generujący okrąg z obrotu jednego punktu
% -----------------------------------------------------

% Punkt początkowy:
p0 = [1; 0; 0];   % np. punkt na osi X (możesz zmienić)

% Oś obrotu (musi być jednostkowa)
n = [0 0 1];      % obrót wokół osi Z

% Przygotowanie wykresu
figure; hold on; axis equal;
xlabel('X'); ylabel('Y'); zlabel('Z');
title('Trajektoria punktu przy obrocie 0..360°');

% Kolory
plot3(p0(1), p0(2), p0(3), 'ro', 'MarkerSize', 8, 'LineWidth', 2);

% Tablica na wszystkie punkty
traj = zeros(3, 361);

% Obliczenia i wykres
for deg = 0:360

    theta = deg * pi/180;    % stopnie → radiany

    R = rotation_exp(theta, n);   % Twoja funkcja

    p = R * p0;   % obrócony punkt

    traj(:, deg+1) = p;

    % Możesz punktować każdy krok:
    plot3(p(1), p(2), p(3), 'b.');
    drawnow;   % opcjonalnie animacja krok-po-kroku

end

% Rysowanie pełnej trajektorii jako okręgu
plot3(traj(1,:), traj(2,:), traj(3,:), 'k-', 'LineWidth', 1.5);

grid on;
