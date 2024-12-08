clear; close all; clc
% Define the smooth function
N = 1000;
x = linspace(-1, 1, N);
f = sqrt(cos(4 * x).^2 ./ (1 + x.^2));

% Add Gaussian noise
epsilon = 0.1;
noisy_f = f + epsilon * randn(size(f));

% Perform SWT
waveletName = 'db4';
level = 2;
[C_swt, ~] = swt(noisy_f, level, waveletName);

% Soft thresholding
delta = epsilon * sqrt(2*log(N));
C_thr = sign(C_swt) .* max(abs(C_swt) - delta, 0);

% Reconstruct the function
denoised_f = iswt(C_thr, waveletName);

mse_noisy = mean((f - noisy_f).^2);
mse_soft = mean((f - denoised_f).^2);

% Plot results
plot(x, f, 'k', 'LineWidth', 1.5); hold on;
plot(x, noisy_f, 'r--');
plot(x, denoised_f, 'b'); hold off;
ylim([min(f) max(f)])
legend('Original', 'Noisy', 'Denoised');
title('Smooth Function Denoising');

% Display results
fprintf('MSE (noisy signal): %.4f\n', mse_noisy);
fprintf('MSE (Soft Thresholding): %.4f\n', mse_soft);
