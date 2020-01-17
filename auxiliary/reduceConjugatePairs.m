function [poles, isConjugatePolePair, nonPairedPoles] = reduceConjugatePairs(poles)
% Find complex conjugate pairs and reduce those with flags isConjugatePolePair
% 
% Sebastian J. Schlecht, Sunday, 29 December 2019

%% Find nearest neighbor pairs
numberOfPoles = length(poles);
pairIndex = nearestneighbour([real(poles); imag(poles)],[real(poles); -imag(poles)]);

%% Pair poles
pairType = zeros(size(poles));
for it=1:numberOfPoles
    if pairType(it) == 0 % not paired yet
        if (it == pairIndex(it) )
            pairType(it) = 1; % self-pair = real pole
        elseif it == pairIndex(pairIndex(it))
            pairType(it) = 2; % pair 1 = complex pole
            pairType(pairIndex(it)) = 3; % second pair
        else
            pairType(it) = -1; % not paired
        end     
    end
end

if any(pairType == -1)
    warning('%d poles could not be paired', sum(pairType == -1) )
end

%% set isConjugatePolePair flag
isConjugatePolePair = ones(size(poles));
isConjugatePolePair( pairType == 1 ) = 0;

nonPairedPoles = poles(pairType == -1);
selectPoles = pairType == 1 | pairType == 2 | pairType == -1;
poles = poles( selectPoles );
poles = real(poles) + 1i*abs(imag(poles));
isConjugatePolePair = isConjugatePolePair( selectPoles );
