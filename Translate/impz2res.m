function [residues,b0,b1] = impz2res(ir, poles, isConjugatePolePair)
%impz2res - Compute residues from impulse response and poles
%Given a set of poles and the resulting time-domain impulse response, the
%residues can be computed via a least-squares problem. More details can be
%found in Bank, B. (2018). Converting infinite impulse response filters to
% parallel form [Tips & Tricks]. IEEE Signal Process. Mag., 35(3), 124-130.
% http://doi.org/10.1109/MSP.2018.2805358
%
% Syntax:  [res,b0,b1] = impz2res(ir, poles, isConjugatePolePair)
%
% Inputs:
%    ir - impulse response
%    poles - system poles (half with positive angles)
%    isConjugatePolePair - logical whether the pole is a conjugate pair
%
% Outputs:
%    residues - system residues
%    b0 - First biquad coefficient
%    b1 - Second biquad coefficient
%
%
% See also: 
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 28 December 2019; Last revision: 28 December 2019

%% Initialization
factor = isConjugatePolePair + 1;
impulseResponseLength = 4*length(poles);
ir = ir(2:impulseResponseLength); % no direct sound

%% Synthesize undriven exponentials 
t = 1+(-1:impulseResponseLength-2)';

c = factor .* exp(1i * t .* angle(poles) );
e = exp(  log(abs(poles)) .* t );
ce = real(c.*e);

%% Solve least-squares problem 
U = [ce(1:end-1,:),ce(2:end,:)];
b = U \ ir;
b0 = b(1:end/2);
b1 = b(end/2+1:end);

%% compare real(c.*e*res) with b0*real(c.*e) + b1*real(c.*e)
residues = (b0 + b1.*real(poles.')) + 1i*(imag(poles.').*b1);
