% Example for inverse polynomial matrix as used in Ehrlich-Aberth-Iteration
%
% Sebastian J. Schlecht, Monday, 23 December 2019

%% Generate paraunitary matrix
N = 3;
K = 2;
delays = randi([10,20],[N,1]);

[matrix,revMatrix] = constructCascadedParaunitaryMatrix( N, K, 'matrixType', 'random' );

loop = zDomainStandardLoop(delays, matrix, revMatrix);

%% Compute matrices at z
z = randn(1) + 1i*randn(1);
mat = loop.feedbackTF.at(z)

invMat = loop.invFeedbackTF.at(1/z)

% is identiy matrix
mat * invMat


%% Identity with inverse matrix 
timeReversed = flip( revMatrix,3 )

% is identiy matrix
matrixConvolution(matrix,  timeReversed  )


