function rotationMatrix = tinyRotationMatrix(N,delta,varargin)
%tinyRotationMatrix - orthogonal matrix with a small eigenvalue angles
%
% Syntax:  rotationMatrix = tinyRotationMatrix(N,delta)
%
% Inputs:
%    N - Matrix size 
%    delta - Mean normalized eigenvalue angle
%    spread - (optional) Spreading of eigenvalue angle 
%    logMatrix - (optional) Initial logarithm matrix
%
% Outputs:
%    rotationMatrix - output matrix
%
% Example: 
%    rotationMatrix = tinyRotationMatrix(4,1/48000,0)
%    rotationMatrix^48000 is identity
%
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 17. January 2020; Last revision: 17. January 2020

%% Input Parser
p = inputParser;
p.addOptional('spread',0.1);
p.addOptional('logMatrix',randn(N));
parse(p,varargin{:});

spread = p.Results.spread;
x = p.Results.logMatrix;

%% Generate skew symmetric matrix
skewSymmetric = (x - x')/2;

[v,e] = eig(skewSymmetric);

%% Make complex conjugate
IDX = nearestneighbour(v,conj(v));
frequencySpread = 2*(rand(N,1)-0.5) * spread + 1;
frequencySpread = (frequencySpread(IDX) + frequencySpread) / 2;
frequencySpread( IDX - 1:N == 0 ) = 0; % non-complex eigenvalue 

%% Scale and spread
E = diag(e);
nE = E ./ abs(E) .* frequencySpread * delta * pi;

%% Create orthogonal matrix
skewSymmetric = real(v* diag(nE)*v');
skewSymmetric = (skewSymmetric - skewSymmetric') / 2;

rotationMatrix = expm(skewSymmetric);

%% Alternative
% rotationMatrix = v*diag(exp(nE))*v';
% nearestOrthogonal
