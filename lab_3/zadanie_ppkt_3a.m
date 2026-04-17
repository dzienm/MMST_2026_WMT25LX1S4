% Skrypt z przykładem
clear; clc; close all;

m=1;
F=1;

% --- 1. PARAMETRY MODELU ---
A = [0 1; 0 0];
B = [0,1]';
t=linspace(0, 10, 1000);
x0 = [0; 0];
u=t;
u(:)=F/m;

x = solve_linear_control_system(A, B, x0, u, t);

x=x';
%sprawdzamy wynik
plot(t,x(2,:)) %wykres predkosci
hold on
plot(t,x(1,:))

%zadanie domowe
%sprawdzzic x=at^2/2; v=a*t

%czas wykonania
tic
x = solve_linear_control_system(A, B, x0, u, t);
czas_wykonania = toc;