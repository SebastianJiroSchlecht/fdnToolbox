function [residues, poles, direct, isConjugatePolePair, metaData] = ss2pr_fdn(delays,A,B,C,D,varargin)
%ss2pr_fdn - From state-space to poles and residues
% Similar to residues, but with delays. Also, this function supports multiple
% input and output. The algorithms is derived in 
% Schlecht, S. J., & Habets, E. A. P. (2018). Modal decomposition of
% feedback delay networks. IEEE Trans. Signal Process., submitted.
%
% Syntax:  [residues, poles, direct, isConjugatePolePair, metaData] = ss2pr_fdn(delays,absorption,A,B,C,D,deflationType)
%
% Inputs:
%    delays - delays in samples of size [1,N]
%    A - feedback matrix, scalar or polynomial of size [N,N,(order)]
%    B - input gains of size [N,in]
%    C - output gains of size [out,N]
%    D - direct gains of size [out,in]
%    deflationType (optional) - either 'fullDeflation', 'noDeflation', 'neighborDeflation'
%    inverseMatrix (optional) - inverse feedback matrix
%
% Outputs:
%    residues - matrix of system residues
%    poles - system poles
%    direct - direct gain
%    isConjugatePolePair - logical index whether poles are pair or real
%    metaData - additional output values 
%
% See also: example_ss2pr_fdn
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 28 December 2019; Last revision: 28 December 2019

%% Input Parser
p = inputParser;
p.addOptional('inverseMatrix', [], @(x) isnumeric(x) );
p.addOptional('deflationType','fullDeflation',@(x) ischar(x) );
parse(p,varargin{:});

deflationType = p.Results.deflationType;
inverseMatrix = p.Results.inverseMatrix;
inverseMatrixExists = ~isempty(inverseMatrix);


%% Setup Loop Matrix
delayTF = zDomainDelay(delays); 

if isnumeric(A)
    if ismatrix(A) % scalar matrix
        matrixTF = zDomainScalarMatrix(A);
        invmatTF = zDomainScalarMatrix(inv(A));
        loopMatrix = zDomainLoop(delayTF, matrixTF, invmatTF);
    elseif ndims(A) == 3 % FIR matrix
        matrixTF = zDomainMatrix(A);
        if inverseMatrixExists
            invmatrixTF = zDomainMatrix(inverseMatrix);
            loopMatrix = zDomainLoop(delayTF, matrixTF,invmatrixTF);
        else
            loopMatrix = zDomainLoop(delayTF, matrixTF);
        end
    else
        error('Not defined');
    end
else
    if inverseMatrixExists
        loopMatrix = zDomainLoop(delayTF, A, inverseMatrix);
    else
        loopMatrix = zDomainLoop(delayTF, A);
    end
end
numberOfPoles = loopMatrix.numberOfDelayUnits;

%% Pole initialization
poleAngles = linspace(0,2*pi,numberOfPoles+1);
poleAngles = poleAngles(1:end-1);
poles = exp(1i * poleAngles);
qualityThreshold = 1000 * eps;

%% Find poles
[poles,quality, metaDataRefine] = refinePolePositions(poles, loopMatrix,...
    'QualityThreshold', qualityThreshold, 'MaximumIterations',50, ...
    'DeflationType', deflationType, 'Verbose', true);

metaData = metaDataRefine;
metaData.refinedPoles = poles;

%% Filter high quality poles
isConverged = quality < qualityThreshold * 1000; % be looser here than in the search 
poles = poles(isConverged);
metaData.convergedPoles = poles;

if length(poles) ~= numberOfPoles
    warning('Poles did not converge: %d instead of %d',length(poles),numberOfPoles);
end

%% Pair complex-conjugated pairs
[poles, isConjugatePolePair, metaData.nonPairedPoles] = reduceConjugatePairs(poles);

fprintf('Final number of poles are: %d of possible %d \n',sum(isConjugatePolePair+1),numberOfPoles);

%% Compute residues
[residues,direct,undrivenResidues] = computeResidues(poles,loopMatrix,B,C,D);

metaData.undrivenResidues = undrivenResidues;


