function SOS = graphicEQ( centerOmega, shelvingOmega, R, gaindB )
% Proportional parametric graphical EQ as described in
% [1]	V. Välimäki and J. Reiss, "All About Audio Equalization: Solutions and Frontiers," 
%       Applied Sciences, vol. 6, no. 5, p. 129, May 2016.
% [2]	J. M. Jot, "Proportional Parametric Equalizers - Application to Digital 
%       Reverberation and Environmental Audio Processing," presented at the 
%       Proc. Audio Eng. Soc. Conv., New York, NY, USA, 2015, pp. 1-8.
%
% The frequency bands are described by the centerOmega and shelvingOmega
% R relates to the quality factor and
% gaindB is the command gain of the bands
%
% Author: Sebastian J Schlecht
% Date: 24.03.2017



numFreq = length(centerOmega) + length(shelvingOmega) + 1;
assert( length(gaindB) == numFreq);
SOS = zeros(numFreq,6);

for band = 1:numFreq
    switch band
        case 1
            b = [1 0 0] * db2mag(gaindB(band));
            a = [1 0 0];
        case 2
            [b,a] = shelvingFilter( shelvingOmega(1), db2mag(gaindB(band)), 'low' );
        case numFreq
            [b,a] = shelvingFilter( shelvingOmega(2), db2mag(gaindB(band)), 'high' );
        otherwise
            Q = sqrt(R) / (R-1);
            [b,a] = bandpassFilter( centerOmega(band-2), db2mag(gaindB(band)), Q );
    end
    
    sos = [b a];
    
    SOS(band,:) = sos;
end















