clear; close all; clc
% Parameters
N = 1000; % Number of sample points
x = linspace(-1, 1, N);
f = (cos(4*x).^2) ./ (1 + x.^2);

% Wavelet decomposition
waveletName = 'db4';
level = 4; % decomposition level 
[C, L] = wavedec(f, level, waveletName); 

% Visualize coefficients 
figure;
subplot(2, 1, 1);
plot(f); title('Original Signal');
xlim([0, N]);
subplot(2, 1, 2);
semilogy(abs(C)); title('Wavelet Coefficients');
xlim([0, N]);



% Check boundary condition
dwtmode('per'); 

