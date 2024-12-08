clear; close all; clc
% Define the smooth sine wave signal
N = 1000; % Number of samples
x = linspace(-1, 1, N);
f = sqrt(cos(4*x).^2) ./ (1 + x.^2); % Original function

% Add Gaussian noise
epsilon = 0.1; % Noise level
noise = epsilon * randn(size(f)); % Gaussian noise
f_noisy = f + noise; % Noisy signal

% Plot the noisy signal
figure;
plot(x, f, 'b', x, f_noisy, 'r'); legend('Original', 'Noisy');
title('Original and Noisy Signals');
ylim([min(f) max(f)])

% Wavelet decomposition
waveletName = 'db4';
level = 4; % decomposition level 
[C, L] = wavedec(f_noisy, level, waveletName);

% Define threshold
delta = epsilon * sqrt(2*log(N));

% Hard thresholding:  sets coefficients smaller than delta to 0
C_hard = C .* (abs(C) >= delta);

% Soft thresholding: shrinks coefficients by delta while retaining the sign
C_soft = sign(C) .* max(abs(C) - delta, 0);

% Reconstruct signals
f_hard = waverec(C_hard, L, waveletName);
f_soft = waverec(C_soft, L, waveletName);

% Behaviour near edges?

% f_hard: Abrupt changes in coefficients can lead to 
% artifacts near discontinuities

% f_soft: Smoother transitions help preserve features 
% near edges without introducing significant artifacts.

% Plot the results
figure;
plot(x, f, 'b', x, f_hard, 'g', x, f_soft, 'm');
legend('Original', 'Hard Thresholding', 'Soft Thresholding');
title('Denoised Signals');
ylim([min(f) max(f)])

% Compute MSE
mse_noisy = mean((f - f_noisy).^2);
mse_hard = mean((f - f_hard).^2);
mse_soft = mean((f - f_soft).^2);

% Display results
fprintf('MSE (noisy signal): %.4f\n', mse_noisy);
fprintf('MSE (Hard Thresholding): %.4f\n', mse_hard);
fprintf('MSE (Soft Thresholding): %.4f\n', mse_soft);




