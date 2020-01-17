function [drivenRes,directTerm,undrivenResidues] = computeResidues(poles,loop,B,C,D)
%computeResidues - Residues from poles and state space
%see Schlecht, S., Habets, E. (2019). Modal
%Decomposition of Feedback Delay Networks IEEE Trans. Signal Process.
%67(20)https://dx.doi.org/10.1109/tsp.2019.2937286
%
% Syntax:  [drivenRes,directTerm,undrivenResidues] = computeResidues(poles,loop,B,C,D)
%
% Inputs:
%    poles - Pole locations
%    loop - Loop transfer function
%    B - Input gains
%    C - Output gains
%    D - Direct gains
%
% Outputs:
%    drivenRes - Residues with input and output relation
%    directTerm - Direct component
%    undrivenResidues - Residues without input and output relation
%
% Example: 
%   
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: 
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 29 December 2019; Last revision: 29 December 2019


numberOfInputs = size(B,2);
numberOfOutputs = size(C,1);
numberOfPoles = length(poles);

%% compute undriven residues
r_denominator = zeros(numberOfPoles,1);
for it = 1:numberOfPoles
    pole = poles(it);
    r_denominator(it) = trace( adjugate(loop.at(pole)) * loop.der(pole) ) ;
end
undrivenResidues = 1 ./ r_denominator;

%% filter multipoles (as they are not resolved before)
isMultiplePoles = isnan(undrivenResidues) | isinf(undrivenResidues);
if sum(isMultiplePoles) > 0
   warning('There are multipoles. The residues are set to zero.'); 
   undrivenResidues(isMultiplePoles) = 0;
   r_denominator(isMultiplePoles) = Inf;
end

%% Compute driven residues
r_nominator = zeros(numberOfPoles,numberOfOutputs,numberOfInputs);
for itOut = 1:numberOfOutputs
    for itIn = 1:numberOfInputs
        for it = 1:numberOfPoles
            b = B(:,itIn);
            c = C(itOut,:);
            r_nominator(it,itOut,itIn) = c*adjugate( loop.at(poles(it)) )* b ;
        end
    end
end

drivenRes = r_nominator ./ r_denominator ;
directTerm = D;