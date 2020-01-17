function plotMatrix(A)
% Plot a matrix from a top view (similar to imagesc)
%
% Sebastian J. Schlecht, Tuesday, 31 December 2019

N = size(A);
AA = zeros( size(A) + 1 );
AA(1:end-1, 1:end-1) = A;


surf(AA);
view([0 90])

xticks((1:N)+0.5)
xticklabels(1:N)

yticks((1:N)+0.5)
yticklabels(1:N)

set(gca,'XAxisLocation','top','YAxisLocation','left','ydir','reverse');

