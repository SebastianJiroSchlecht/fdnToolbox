% demonstrate a solution to the absolute Procrustes problem. Given is a
% non-negative square matrix B which indicates the amount of energy
% going from one delay line to another. We would like to find the closest
% orthogonal matrix C to B in terms of absolute values. The challenge is in
% finding the right +- signs which are missing in B. A brute force search 
% would need to check 2^(N^2) sign combinations which is excessive even for
% small N.
%
% In this approach, we initialize random signs and then improve towards a
% local minimum by an exchange of variables approach.
% 1) Compute closest orthogonal with SVD
% 2) Take signs from new solution
% 3) Repeat from 1) if any sign changed
%
% This approach guarantees on each step to improve the error norm. Below is
% given an example for N=4. First an orthogonal matrix A is generated, and
% then matrix B is A without signs. 
%
%
clear; clc; close all;

N = 4;
% original matrix
A = orth(randn(N))

% problem target matrix
B = abs(A)

% naive solution
[U,~,V] = svd(B);
D = U*V'
    
% problem solution matrix
C = nearestSignAgnosticOrthogonal(B)



% absolute difference matrix
abs(C) - abs(A)

% mean value difference
norm(abs(C) - abs(A),'fro') / N^2
norm(abs(D) - abs(A),'fro') / N^2
