function f = tf2dfiltVector(b,a)
% convert vector of transfer function to vector of filter objects
%
% Sebastian J. Schlecht, Tuesday, 20. October 2020

numberOfFilters = size(b,1);

f(1, numberOfFilters) = dfilt.df2;

for ch = 1:numberOfFilters
    f(ch) = dfilt.df2(b(ch,:), a(ch,:));  
end