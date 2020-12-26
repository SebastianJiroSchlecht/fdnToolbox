function plotSystemMatrix(A,b,c,d)
% Sebastian J. Schlecht, Monday, 29. June 2020
% TODO

V = [A, b; c, d];

NV = size(V,1);
N = size(A,1);
NIO = size(c,1);

spaceBetween = 0.05;
spaceBorder = 0.05;
colorBorder = 0.02;

plotSpace = 1 - 2*spaceBorder - spaceBetween - colorBorder;

tileSize = plotSpace/NV;

climits = [-1 1];
colormap(blueWhiteRedColormap())

pos1 = [spaceBorder+[0,1]*spaceBetween + [0 NIO]*tileSize, tileSize*([N N])];
subplot('Position',pos1)
plotMatrix(A);
caxis(climits);


pos1 = [spaceBorder+[1,1]*spaceBetween + [N NIO]*tileSize, tileSize*([NIO N])];
subplot('Position',pos1)
plotMatrix(b);
caxis(climits);
xticks([])
yticks([])

pos1 = [spaceBorder+[0,0]*spaceBetween + [0 0]*tileSize, tileSize*([N NIO])];
subplot('Position',pos1)
plotMatrix(c);
caxis(climits);
xticks([])
yticks([])

pos1 = [spaceBorder+[1,0]*spaceBetween + [N 0]*tileSize, tileSize*([NIO NIO])];
subplot('Position',pos1)
plotMatrix(d);
caxis(climits);
xticks([])
yticks([])

pos1 = [ 1-spaceBorder-colorBorder spaceBorder spaceBorder 1-2*spaceBorder-colorBorder];
subplot('Position',pos1)
plot([0,0])
caxis(climits);
set(gca,'visible','off')
colorbar 