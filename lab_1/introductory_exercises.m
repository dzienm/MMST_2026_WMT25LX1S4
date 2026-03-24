% MATLAB Introductory Exercises

%% 1. Vector and Matrix Creation
% Create a row vector with elements from 1 to 10
row_vector = 1:10; %with suprresing printing
row_vector = 1:10;  %with print after declaration

% Create a column vector with elements from 10 to 1
col_vector = (10:-1:1)'
row_vector = (1:2:20)
row_vector'

% Create a 3x3 matrix with random integers between 1 and 20
matrix_3x3 = randi([1, 20], 3, 3);
matrix_3x3 = [1,2,3;4,5,6;7,8,9]

% Use linspace and logspace to generate vectors
lin_vector = linspace(1, 10, 5);
log_vector = logspace(1, 3, 5);

%% 2. Loops and Control Flow
% For loop: Sum the numbers from 1 to 100
sum_100 = 0;
for i = 1:100
    sum_100 = sum_100 + i;
end

% While loop: Find the smallest n such that the sum of numbers from 1 to n exceeds 1000
n = 0;
sum_n = 0;
while sum_n <= 1000
    n = n + 1;
    sum_n = sum_n + n;
end


%% 3. Vector and Matrix Operations
% Add, subtract, and multiply two matrices
A = randi([1, 10], 3, 3);
B = randi([1, 10], 3, 3);
matrix_sum = A + B;
matrix_diff = A - B;
matrix_prod = A * B;

% Perform element-wise multiplication using .*
elementwise_prod = A .* B;

% Transpose a matrix and compute its inverse (if it exists)
A_transpose = A';
if det(A) ~= 0
    A_inverse = inv(A);
else
    disp('Matrix is singular and cannot be inverted.');
end

% Use sum, mean, max, min, and std on vectors/matrices
vector = randi([1, 10], 1, 10);
vector_sum = sum(vector);
vector_mean = mean(vector);
vector_max = max(vector);
vector_min = min(vector);
vector_std = std(vector);

%% 4. Logical Operations and Indexing
% Create a vector of 20 random integers between 1 and 100
rand_vector = randi([1, 100], 1, 20);

% Find all elements greater than 50
greater_than_50 = rand_vector(rand_vector > 50);

% Replace all even numbers with zero
rand_vector(mod(rand_vector, 2) == 0) = 0;

% Count how many elements are divisible by 3
divisible_by_3_count = sum(mod(rand_vector, 3) == 0);

%% 5. Vector Appending and Reshaping


% Concatenate two vectors horizontally and vertically
vector1 = 1:5;
vector2 = 6:10;
[vector1, vector2]
[vector1', vector2']
[vector1'; vector2']
[vector1;vector2]

% Append a new row to a matrix
A = randi([1, 10], 3, 3)
new_row = randi([1, 10], 1, 3)
matrix_with_new_row = [A; new_row]
matrix_with_new_column = [A,new_row']

% Reshape a 1x9 vector into a 3x3 matrix using reshape
vector_1x9 = 1:9;
reshaped_matrix = reshape(vector_1x9, 3, 3);


