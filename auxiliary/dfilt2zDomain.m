function z = dfilt2zDomain( filter )
% convert dfilt to a zDomain matrix (vector form): TODO needs to be
% generalized
%
% Sebastian J. Schlecht, Tuesday, 20. October 2020

numberOfChannels = filter.numberOfChannels;

for ch = 1:numberOfChannels
    numerator(ch,1,:) = filter.filters(ch).Numerator;
    denominator(ch,1,:) = filter.filters(ch).Denominator;
end

% TODO invert filters is a hack
z = zDomainVector(denominator, numerator);