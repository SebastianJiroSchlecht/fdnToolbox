function [MinCurve,MaxCurve,w] = poleBoundaries(delays, absorption, feedbackMatrix, nfft)
%poleBoundaries - Find upper and lower pole boundaries for FDN loop
%see Schlecht, S. J., & Habets, E. A. P. (2018). Modal decomposition of
% feedback delay networks. IEEE Trans. Signal Process.
%
% Syntax:  [MinCurve,MaxCurve,w] = poleBoundaries(delays, absorption, feedbackMatrix, nfft)
%
% Inputs:
%    delays - Vector of delays in FDN in [samples]
%    absorption - Vector of absorption filters of size [numel(delays),1,len]
%    feedbackMatrix - Matrix of feedback gains / filters
%    nfft (optional) - Number of Frequency Bins 
%
% Outputs:
%    MinCurve - Lower bound of pole magnitude
%    MaxCurve - Upper bound of pole magnitude
%    w - Frequency points 
%
% Example: 
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
% 29 December 2019; Last revision: 29 December 2019


if nargin == 3
    nfft = 2^12;
end
N = length(delays);

%% Compute extremal SVD per frequency bin
[~,w] = freqz( 1,1,nfft);
FeedbackMatrix = fft(feedbackMatrix,nfft*2,3);
FeedbackMatrix = FeedbackMatrix(:,:,1:end/2);


Min = zeros(nfft,1);
Max = zeros(nfft,1);
for it = 1:nfft
    Min(it) = min(abs(svd(FeedbackMatrix(:,:,it))))^ (1/min(delays));
    Max(it) = max(abs(svd(FeedbackMatrix(:,:,it))))^ (1/max(delays));
end

%% combine with absorption
b = permute(absorption.b, [1 3 2]);
a = permute(absorption.a, [1 3 2]);

H = zeros(nfft,N);
G = zeros(nfft,N);
for it=1:N
    [H(:,it),w] = freqz(b(it,:),a(it,:),nfft);
    [G(:,it),w] = grpdelay(b(it,:),a(it,:),nfft);
end

d = abs(H).^(1./(delays+G));
dMin = min(d,[],2);
dMax = max(d,[],2);

MinCurve = dMin.*Min;
MaxCurve = dMax.*Max;



