%% Section 3: Wavelet-based Inpainting
clear; clc; close all;
%% Step 1: Load the Image and Generate a Mask
% Load the grayscale image
original_image = imread('Images\cameraman.tif'); % Use built-in image or your own
A = double(original_image); % Convert to double for computation

% Generate a mask (simulate damaged regions)
mask = zeros(size(A));
mask(50:60, 70:80) = 1; % Example: Add a block of missing pixels
mask = mask > 0;
A(mask) = 0;
damaged_image = A;
%% Step 2: Initialize Parameters
B = A; % Initial guess (image with zeros in damaged regions)
max_iter = 50;     % Maximum number of iterations
delta = 40;        % Thresholding parameter
wavelet = 'sym4';   % Wavelet to use ('db1' can be replaced with other wavelets)
tol = 1e-4;        % Convergence tolerance
wavelet_levels = 4; % Number of decomposition levels

% Known pixels projection operator
P_Lambda = ~mask;
%% Step 3: Iterative Inpainting Algorithm
for n = 1:max_iter
    % Step 3.1: Wavelet Transform
    [C, S] = wavedec2(B, wavelet_levels, wavelet); % Decompose using wavelet transform
    
    % Step 3.2: Thresholding in Wavelet Domain
    C_thresh = wthresh(C, 's', delta); % Soft thresholding
    
    % Step 3.3: Inverse Wavelet Transform
    B_new = waverec2(C_thresh, S, wavelet); % Reconstruct the image
    
    % Step 3.4: Enforce Known Pixels
    reconstructed_image = waverec2(C_thresh, S, wavelet); % Full reconstruction
    B_new(~P_Lambda) = reconstructed_image(~P_Lambda);   % Update ONLY missing pixels
    B_new(P_Lambda) = damaged_image(P_Lambda);           % Fix known pixels

    % Step 3.5: Check for Convergence (Optional)
    diff = norm(B_new - B, 'fro') / norm(B, 'fro'); % Relative change
    fprintf('Iteration %d: Relative Change = %.3E\n', n, diff);
    if diff < tol
        disp('Convergence achieved!');
        break;
    end
    
    % Update the image
    B = B_new;
end

%% Step 4: Display Results
figure;
subplot(1, 2, 1); imshow(uint8(damaged_image)); title('Damaged Image');
subplot(1, 2, 2); imshow(uint8(B)); title('Inpainted Image');