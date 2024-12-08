clear; close all; clc;

% Load a sample grayscale image
[A, ~] = imread('Images\cameraman.tif');
A = double(A); % Convert to double precision
[N,~] = size(A);

% Display the original image
figure;
subplot(1, 2, 1); imshow(A, []);
title('Original Image');

% Add Gaussian noise
epsilon = 20; % Noise level
noisy_A = A + epsilon * randn(size(A));

% Display the noisy image
subplot(1, 2, 2); imshow(noisy_A, []);
title('Noisy Image');
% try: level = 1,2,3,4,5
% Perform 2D wavelet decomposition
waveletName = 'sym4';
% try: 'haar', 'db4', 'sym4', 'coif5'
level = 5; % Decomposition level
% try: level = 1,2,3,4,5
[C, S] = wavedec2(noisy_A, level, waveletName);

% Define the threshold
% delta = epsilon * sqrt(2*log(N));
% Also try the minimax threshold 
delta = epsilon * sqrt(2 * log(log(N)));

% Hard thresholding
C_hard = C .* (abs(C) >= delta);

% Soft thresholding
C_soft = sign(C) .* max(abs(C) - delta, 0);

% Reconstruct the images
hard_denoised_A = waverec2(C_hard, S, waveletName);
soft_denoised_A = waverec2(C_soft, S, waveletName);

% Compute SNR
snr_hard = round(10 * log10(sum(A(:).^2) / sum((A(:) - hard_denoised_A(:)).^2)),2);
snr_soft = round(10 * log10(sum(A(:).^2) / sum((A(:) - soft_denoised_A(:)).^2)),2);

% Display the denoised images
tit_hard = append('Hard, SNR : ', num2str(snr_hard), 'dB');
tit_soft = append('Soft, SNR : ', num2str(snr_soft), 'dB');
figure;
subplot(1, 2, 1); imshow(hard_denoised_A, []);
title(tit_hard);
subplot(1, 2, 2); imshow(soft_denoised_A, []);
title(tit_soft);

sgtitle('Thresholding methods')

% Display results
fprintf('SNR (Hard Thresholding): %.2f dB\n', snr_hard);
fprintf('SNR (Soft Thresholding): %.2f dB\n', snr_soft);


    



