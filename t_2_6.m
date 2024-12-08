clear; close all; clc;

% Load a sample grayscale image
[A, ~] = imread('Images\cameraman.tif'); % Example image
A = double(A); % Convert to double for processing
[N,~] = size(A);
epsilon = 20; % Noise level

% Add Gaussian noise
noisy_A = A + epsilon * randn(size(A));

% Parameters for SWT
waveletName = 'sym4'; 
% Try: 'haar', 'db4', 'sym4', 'coif5'
level = 5; % Decomposition level
% try: level = 1,2,3,4,5

% Perform SWT
[A_swt, H_swt, V_swt, D_swt] = swt2(noisy_A, level, waveletName);

% Define the threshold
% delta = epsilon * sqrt(2*log(N));
% Also try the minimax threshold 
delta = 0.7 * epsilon * sqrt(2 * log(log(N)));

H_thr = sign(H_swt) .* max(abs(H_swt) - delta, 0);
V_thr = sign(V_swt) .* max(abs(V_swt) - delta, 0);
D_thr = sign(D_swt) .* max(abs(D_swt) - delta, 0);

% Reconstruct the image using ISWT
denoised_A = iswt2(A_swt, H_thr, V_thr, D_thr, waveletName);

% Compute SNR
snr_original = 10 * log10(sum(A(:).^2) / sum((A(:) - noisy_A(:)).^2));
snr_denoised = 10 * log10(sum(A(:).^2) / sum((A(:) - denoised_A(:)).^2));

% Display results
figure;
subplot(1, 2, 1); imshow(noisy_A, []); title(sprintf('Noisy Image (SNR: %.2f dB)', snr_original));
subplot(1, 2, 2); imshow(denoised_A, []); title(sprintf('Denoised Image (SNR: %.2f dB)', snr_denoised));


