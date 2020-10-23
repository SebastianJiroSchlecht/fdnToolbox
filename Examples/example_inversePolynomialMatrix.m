% Example for inverse polynomial matrix as used in Ehrlich-Aberth-Iteration
%
% Demonstrate that the inverse polynomial matrix is actual inverse. Inverse
% is used for Ehrlich-Aberth-Iteration in modal decomposition of the FDN.
%
% see Schlecht, S., Habets, E. (2019). Modal Decomposition of Feedback
% Delay Networks IEEE Transactions on Signal Processing  67(20), 5340-5351.
% https://dx.doi.org/10.1109/tsp.2019.2937286
%
% Sebastian J. Schlecht, Monday, 23 December 2019

% Generate paraunitary matrix
N = 3;
K = 2;
delays = randi([10,20],[N,1]);

[matrix,matrixInverse] = constructCascadedParaunitaryMatrix( N, K, 'matrixType', 'random' );
loop = zFDNloopSimple(delays, matrix, matrixInverse);

% Compute matrices at z
z = randn(1) + 1i*randn(1);
mat = loop.feedbackTF.at(z);
invMat = loop.feedbackInv.at(1/z);

%% Test: Is Inverse Matrix
assert( isAlmostZero( mat * invMat - eye(N)), 'tol', 10^-10 )

%% Test: Identity with inverse matrix 
timeReversed = flip( matrixInverse,3 );
identityCheck = matrixConvolution(matrix,  timeReversed) ;
identityCheck(:,:,ceil(end/2)) = identityCheck(:,:,ceil(end/2)) - eye(N);

% is identiy matrix
assert( isAlmostZero( identityCheck ))






