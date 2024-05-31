function [drivenRes,directTerm,undrivenResidues,eigenvectors] = dss2res_dsp(poles,F,B,C,D)
%dss2res - Residues from poles and state space
%see Schlecht, S., Habets, E. (2019). Modal
%Decomposition of Feedback Delay Networks IEEE Trans. Signal Process.
%67(20)https://dx.doi.org/10.1109/tsp.2019.2937286
%
%see Schlecht et al. (2024). Modal Excitation in Feedback Delay Networks (submitted)
%
% Syntax:  [drivenRes,directTerm,undrivenResidues,eigenvectors] = dss2res(poles,loop,B,C,D)
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
%    eigenvectors - right and left eigenvectors
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

% B = convert2zFilter(B);
% C = convert2zFilter(C);
% 
numberOfInputs = B.numberOfInputs;
numberOfOutputs = C.numberOfOutputs;
numberOfPoles = length(poles);
% N = loop.forwardTF.n;

%% compute undriven residues
r_denominator = zeros(numberOfPoles,1);
for it = 1:numberOfPoles
    pole = poles(it);
    r_denominator(it) = trace( adjugate(F.atLoop(pole,'z^-1')) * F.derLoop(pole,'z^-1') ) ;
end
undrivenResidues = 1 ./ r_denominator;

%% filter multipoles (as they are not resolved before)
isMultiplePoles = isnan(undrivenResidues) | isinf(undrivenResidues);
if sum(isMultiplePoles) > 0
    warning('There are multipoles. The residues are set to zero.');
    undrivenResidues(isMultiplePoles) = 0;
    r_denominator(isMultiplePoles) = Inf;
end

%% Compute driven residues and eigenvectors
r_nominator = zeros(numberOfPoles,numberOfOutputs,numberOfInputs);

% eigenvectors.right = zeros(N,numberOfPoles);
% eigenvectors.left = zeros(N,numberOfPoles);
for it = 1:numberOfPoles
    pole = poles(it);
    
    % VERY important; the leading dimensions is the z-sampling points (which is here a singleton)
    adjP = adjugate(F.atLoop(pole,'z^-1')); % is missing the leading dimension
    I = ones(1,1,1);
    bb = B.at(I,pole);
    ff = F.feedforward.at(bb,pole,'z^-1');
    pp = einsum(adjP, ff, 'mn,fnk->fmk'); % especially here
    cc = C.at(pp ,pole,'z^-1');
    r_nominator(it,:,:) = cc;

    
    

    % find rank 1 decomposition
    [V,S,W] = svds(adjP,1);

    eigenvectors.right(:,it) = V * sqrt(S) / sqrt(r_denominator(it));
    eigenvectors.left(:,it) = W * conj(sqrt(S)) / conj(sqrt(r_denominator(it)));
end

drivenRes = r_nominator ./ r_denominator ;
directTerm = D; % TODO change to filter
