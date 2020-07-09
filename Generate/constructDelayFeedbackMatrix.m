function delayMatrix = constructDelayFeedbackMatrix(delayIndices,feedbackMatrix)
%constructDelayFeedbackMatrix - Delay each matrix entry by index
%
% Syntax:  delayMatrix = constructDelayFeedbackMatrix(delayIndices,feedbackMatrix)
%
% Inputs:
%    delayIndices - Delay of each matrix entry in [samples] of size NxN
%    feedbackMatrix - Matrix with scalar entries of size NxN
%
% Outputs:
%    delayMatrix - FIR matrix with delays matrix elements of size NxNxmax(delay)
%
% Example: 
%    delayMatrix = constructDelayFeedbackMatrix(randi(6,[3,3]),randn(3))
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
% 27 December 2019; Last revision: 27 December 2019

N = size(feedbackMatrix,1);
degree = max(delayIndices(:));

delayMatrix = zeros(N, N, degree);

for it1 = 1:N
    for it2 = 1:N
        delayIndex = delayIndices(it1,it2);
        delayMatrix(it1,it2,delayIndex) = feedbackMatrix(it1,it2);
    end
end