function c = circspace(N)
% N points as rad degree without repetition of 0
% 
% (c) Sebastian Jiro Schlecht:  16. October 2018

c = linspace(0,2*pi,N+1);
c = c(1:end-1);