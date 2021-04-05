% Interpolate between two orthogonal matrices
%
% interpolateOrthogonal routine interpolates two orthogonal matrices such
% that each interpolant is orthogonal as well.
%
% See Schlecht, S., Habets, E. (2015). Practical considerations of
% time-varying feedback delay networks Proc. Audio Eng. Soc. Conv.
%
% Sebastian J. Schlecht, Friday, 10. April 2020
clear; clc; close all;


N = 4;

A = fdnMatrixGallery(N,'Hadamard');
A = A * diag(diag(sign(A)));
B = eye(N);

numT = 20;
T = linspace(0,1,numT);
for it = 1:numT
    t = T(it);
    C(:,:,it) = interpolateOrthogonal(A,B,t);
    isP(it) = isParaunitary(C(:,:,it));
end

% plot
figure(1);
plotImpulseResponseMatrix([], C,'xlabel','Time (samples)','ylabel','Amplitude (lin)','ylim',[-1,1])

%% Test: Interpolants are orthogonal
assert( all(isP) )
