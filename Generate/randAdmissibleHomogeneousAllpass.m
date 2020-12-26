function P = randAdmissibleHomogeneousAllpass(G, range)
%randAdmissibleHomogeneousAllpass - Generate random admissible uniallpass FDN 
% see "Allpass Feedback Delay Networks" by Sebastian J. Schlecht
%
% Syntax:  P = randAdmissibleHomogeneousAllpass(G, range)
%
% Inputs:
%    G - Diagonal attenuation matrix 0 < G < 1
%    range - Random range with 0 < range(1) < range(2) < 1 
%
% Outputs:
%    P - Admissible diagonal matrix
%
% Example: 
%    randAdmissibleHomogeneousAllpass(diag([0.9,0.8,0.7]), [0.3,0.8])
%
%
% See also: homogeneousAllpassFDN
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 16. June 2020; Last revision: 16. June 2020

%% init
N = size(G,1);

%% random ratios
ratios = diag(G).^2;
randRatios = rescale(rand(N,1),range(1), range(2)) .* ratios;

P = diag([1; cumprod(1./randRatios(2:end))]);