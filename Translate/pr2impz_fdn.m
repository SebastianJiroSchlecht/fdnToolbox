function response = pr2impz(residues, poles, direct, isConjugatePolePair, impulseResponseLength, type)
%pr2impz - From poles and residues to impulse response
% Each pole and residue form an exponential decaying sinusoid. The sum of
% these sinusoids is the impulse response. The algorithms is presented in
% Schlecht, S. J., & Habets, E. A. P. (2018). Modal decomposition of
% feedback delay networks. IEEE Trans. Signal Process., submitted.
%
% Syntax:  response = pr2impz(residues, poles, direct, isConjugatePolePair, impulseResponseLength, type)
%
% Inputs:
%    residues - matrix of system residues
%    poles - system poles
%    direct - direct gain
%    isConjugatePolePair - logical index whether poles are pair or real
%    impulseResponseLength - length of impulse response in samples
%    type - computation type 'fast' or 'lowMemory'
%
% Outputs:
%    response - matrix of impulse responses 
%
% See also: 
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 28 December 2019; Last revision: 28 December 2019

%% Input parser
if nargin == 5
   type = 'fast'; 
end

%% Initialize
factor = isConjugatePolePair + 1; % conjugate pairs have a factor of 2
numberOfPoles = size(poles,2);
numberOfOutputs = size(residues,2);
numberOfInputs = size(residues,3);
response = zeros( impulseResponseLength, numberOfOutputs, numberOfInputs );

%% Synthesize exponentials
t = (-1:impulseResponseLength-2)';

switch type
    case 'fast'
        c = factor .* exp(1i * t .* angle(poles) );
        e = exp(  log(abs(poles)) .* t );
        ce = c.*e;
        
        for itIn = 1:numberOfInputs
            thisRes = residues(:,:,itIn);
            response(:,:,itIn) = real(ce * thisRes);
        end
    case 'lowMemory'
        for it = 1:numberOfPoles
            c = factor(it) .* exp(1i * t .* angle(poles(it)) );
            e = exp(  log(abs(poles(it))) .* t );
            ce = c.*e;
            
            for itIn = 1:numberOfInputs
                thisRes = residues(it,:,itIn);
                response(:,:,itIn) = response(:,:,itIn) + real(ce * thisRes);
            end
        end
end

response(1,:,:) = direct;

