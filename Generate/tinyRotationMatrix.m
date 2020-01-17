function rotationMatrix = tinyRotationMatrix(N,delta,varargin)
%tinyRotationMatrix - orthogonal matrix with a small eigenvalue angles
%
% Syntax:  rotationMatrix = tinyRotationMatrix(N,delta)
%
% Inputs:
%    N - Matrix size 
%    delta - Mean normalized eigenvalue angle
%    spread - Spreading of eigenvalue angle 
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
parse(p,varargin{:});

spread = p.Results.spread;

%% Generate skew symmetric matrix
x = randn(N);
skewSymmetric = x - x';

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
