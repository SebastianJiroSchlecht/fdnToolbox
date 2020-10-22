function [drivenRes,directTerm,undrivenResidues] = dss2res(poles,loop,B,C,D)
%dss2res - Residues from poles and state space
%see Schlecht, S., Habets, E. (2019). Modal
%Decomposition of Feedback Delay Networks IEEE Trans. Signal Process.
%67(20)https://dx.doi.org/10.1109/tsp.2019.2937286
%
% Syntax:  [drivenRes,directTerm,undrivenResidues] = dss2res(poles,loop,B,C,D)
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

B = convert2zFilter(B);
C = convert2zFilter(C);

numberOfInputs = B.m;
numberOfOutputs = C.n;
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
for it = 1:numberOfPoles
    pole = poles(it);
    b = B.at(pole);
    c = C.at(pole);
    l = loop.at(pole);
    
    r_nominator(it,:,:) = c*adjugate(l)* b;
end

drivenRes = r_nominator ./ r_denominator ;
directTerm = D; % TODO change to filter