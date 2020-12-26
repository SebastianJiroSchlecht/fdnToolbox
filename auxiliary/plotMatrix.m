function plotHandle = plotMatrix(A, varargin)
%plotMatrix - Plot a matrix from a top view (similar to imagesc)
%
% Syntax:  plotHandle = plotMatrix(A, varargin)
%
% Inputs:
%    A - Matrix to plot
%    varargin - Extra arguments for surf function
%
% Outputs:
%    plotHandle - Handle to the surf object
%
% Example: 
%    plotMatrix(randn(7),'EdgeColor','none')
%
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 23. October 2020; Last revision: 23. October 2020

N = size(A);
AA = zeros( size(A) + 1 );
AA(1:end-1, 1:end-1) = A;

plotHandle = surf(AA, varargin{:});
view([0 90]);

xticks((1:N(2))+0.5);
xticklabels(1:N(2));

yticks((1:N(1))+0.5);
yticklabels(1:N(1));

colormap(blueWhiteRedColormap())

set(gca,'XAxisLocation','top','YAxisLocation','left','ydir','reverse');

