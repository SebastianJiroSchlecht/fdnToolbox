function [matrix, matrixRev, randLeftShift, randRightShift] = randomMatrixShift(maxShift, matrix, matrixRev )
%randomMatrixShift - Shift polynomial matrix entries randomly in time
%
% Syntax:   [matrix, matrixRev] = randomMatrixShift(maxShift, matrix, matrixRev )
%
% Inputs:
%    maxShift - Maximum shift in [samples]
%    matrix - Matrix or FIR matrix
%    matrixRev (optional) - In/Reverse of matrix
%
% Outputs:
%    matrix - Shifted matrix
%    matrixRev (optional) - In/Reverse of shifted matrix
%    randRightShift - Samples of right shift
%    randLeftShift - Samples of left shift
%
% Example:
%    Line 1 of example
%    Line 2 of example
%    Line 3 of example
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also:
% Author: Dr.-Ing. Sebastian Jiro Schlecht,
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 28 December 2019; Last revision: 28 December 2019

N = size(matrix,1);

if maxShift >= N
    randLeftShift = randperm(maxShift,N);
    randRightShift = randperm(maxShift,N);
elseif maxShift <= 0
    randLeftShift = zeros(1,N);
    randRightShift = zeros(1,N);
else
    randLeftShift = randi(maxShift,1,N);
    randRightShift = randi(maxShift,1,N);
end

randLeftShift = randLeftShift - min(randLeftShift);
randRightShift = randRightShift - min(randRightShift);

matrix = shiftMatrix(matrix, randLeftShift, 'left');
matrix = shiftMatrix(matrix, randRightShift, 'right');


if nargin == 3
    matrixRev = shiftMatrix(matrixRev, randRightShift, 'left');
    matrixRev = shiftMatrix(matrixRev, randLeftShift, 'right');
end