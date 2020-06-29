function plotMatrix(A, varargin)
% Plot a matrix from a top view (similar to imagesc)
%
% Sebastian J. Schlecht, Tuesday, 31 December 2019
% TODO

N = size(A);
AA = zeros( size(A) + 1 );
AA(1:end-1, 1:end-1) = A;


surf(AA);
view([0 90]);

xticks((1:N(2))+0.5);
xticklabels(1:N(2));

yticks((1:N(1))+0.5);
yticklabels(1:N(1));

set(gca,'XAxisLocation','top','YAxisLocation','left','ydir','reverse');
% set(gca, varargin{:});
