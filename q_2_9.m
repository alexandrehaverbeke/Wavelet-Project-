clear; close all; clc;

% Load the image and add grid noise
[A, ~] = imread('Images/cameraman.tif');
A = double(A);
[N,~] = size(A);

epsilon = 20;
noisy_A = A + epsilon * randn(size(A));
grid_A = noisy_A;
grid_A(1:10:end, :) = 0; % Add horizontal grid lines
grid_A(:, 1:10:end) = 0; % Add vertical grid lines

% Perform SWT
waveletName = 'sym4';
level = 5;
[A_swt, H_swt, V_swt, D_swt] = swt2(grid_A, level, waveletName);

% Apply soft thresholding
delta = epsilon * sqrt(2*log(N));
H_thr = sign(H_swt) .* max(abs(H_swt) - delta, 0);
V_thr = sign(V_swt) .* max(abs(V_swt) - delta, 0);
D_thr = sign(D_swt) .* max(abs(D_swt) - delta, 0);

% Reconstruct the image
denoised_grid_A = iswt2(A_swt, H_thr, V_thr, D_thr, waveletName);

% Compute SNR
snr_soft_grid = round(10 * log10(sum(A(:).^2) / sum((A(:) - denoised_grid_A(:)).^2)),2);

% Display results
subplot(1, 2, 1); imshow(grid_A, []); title('Image with Grid Noise');
subplot(1, 2, 2); imshow(denoised_grid_A, []); title('Denoised Image (Soft Grid thresholding)');

fprintf('SNR (Soft Grid Thresholding): %.2f dB\n', snr_soft_grid);
