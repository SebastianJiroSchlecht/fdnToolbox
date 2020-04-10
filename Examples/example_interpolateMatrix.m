% Interpolate between two orthogonal matrices
%
% Sebastian J. Schlecht, Friday, 10. April 2020
clear; clc; close all;


N = 4;

A = losslessMatrixGallery(N,'Hadamard');
A = A * diag(diag(sign(A)));
B = eye(N);

numT = 20;
T = linspace(0,1,numT);
for it = 1:numT
    t = T(it);
    C(:,:,it) = interpolateOrthogonal(A,B,t);
    isParaunitary(C(:,:,it))
end

%% plot
figure(1);
plotImpulseResponseMatrix([], C)

