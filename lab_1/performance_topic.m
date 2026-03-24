%%
% Comparison of efficiency between embedded MATLAB functions and direct
% basic operations within a loop

% Size of the vector
N = 1e8;
v = rand(1, N);

%%
% Method 1: Using a for loop
tic;
v_squared_loop = zeros(1, N);
for i = 1:N
    v_squared_loop(i) = v(i)^2;
end
time_loop = toc;

% Method 2: Using vectorized operation
tic;
v_squared_vectorized = v.^2;
time_vectorized = toc;

%%
% Display results
fprintf('Time using loop: %.4f seconds\n', time_loop);
fprintf('Time using vectorized operation: %.4f seconds\n', time_vectorized);
fprintf('Gain using vectorized operation: %.2f times faster\n', time_loop/time_vectorized);

%%
% Comparison of MATLAB performance with respect to memory preallocation

%First example - creating a matrix composed by appended 3D vectors
%columwise with matrix extension within every loop iteration

% Appending vectors without memory preallocation
clear; clc;
N = 10000;
matrix_append = [];

tic;
for i = 1:N
    v = rand(3, 1); %random 3D column vector
    matrix_append = [matrix_append, v]; % Appending column-wise
end
time_append = toc;

%%
%Preallocating memory before the loop execution
N = 10000;
matrix_prealloc = zeros(3, N);

tic;
for i = 1:N
    v = rand(3, 1); %random 3D column vector
    matrix_prealloc(:, i) = v; %inserting vector to its column in preallocated matrix
end
time_prealloc = toc;

%%
%Displaying execution times
fprintf('Time without preallocation: %.4f seconds\n', time_append);
fprintf('Time using preallocated matrix: %.4f seconds\n', time_prealloc);
fprintf('Gain using preallocated memory: %.2f times faster\n', time_append/time_prealloc);