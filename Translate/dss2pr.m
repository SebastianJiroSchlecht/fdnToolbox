function [residues, poles, direct, isConjugatePolePair, metaData] = dss2pr(delays,A,B,C,D,varargin)
%dss2pr - From state-space to poles and residues
% Similar to residues, but with delays. Also, this function supports multiple
% input and output. The algorithms is derived in
% Schlecht, S. J., & Habets, E. A. P. (2018). Modal decomposition of
% feedback delay networks. IEEE Trans. Signal Process., submitted.
%
% Syntax:  [residues, poles, direct, isConjugatePolePair, metaData] = dss2pr(delays,absorption,A,B,C,D,deflationType)
%
% Inputs:
%    delays - delays in samples of size [1,N]
%    A - feedback matrix, scalar or polynomial of size [N,N,(order)] or
%    zFilter
%    B - input gains of size [N,in] or zFilter
%    C - output gains of size [out,N] or zFilter
%    D - direct gains of size [out,in] or zFilter
%    inverseMatrix (optional) - provide an inverse matrix of A
%    deflationType (optional) - either 'fullDeflation', 'noDeflation', 'neighborDeflation'
%    absorptionFilter (optional) - per delay filter as zFilter
%    rejectUnstablePoles (optional) - boolean
%
% Outputs:
%    residues - matrix of system residues
%    poles - system poles
%    direct - direct gain
%    isConjugatePolePair - logical index whether poles are pair or real
%    metaData - additional output values
%
% See also: example_dss2pr
% Author: Dr.-Ing. Sebastian Jiro Schlecht,
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 28 December 2019; Last revision: 28 December 2019

%% Input Parser
p = inputParser;
p.addOptional('inverseMatrix', []);
p.addOptional('deflationType','fullDeflation' );
p.addOptional('absorptionFilters', zScalar(ones(numel(delays),1),'isDiagonal',true));
p.addOptional('rejectUnstablePoles', false);

parse(p,varargin{:});

inverseMatrix = p.Results.inverseMatrix;
deflationType = p.Results.deflationType;
absorptionFilters = p.Results.absorptionFilters;
rejectUnstablePoles = p.Results.rejectUnstablePoles;

%% Setup Loop Matrix
delayTF = zDelay(delays.', 'isDiagonal', true);
matrixTF = convert2zFilter(A);
B = convert2zFilter(B);
C = convert2zFilter(C);
loopMatrix = zFDNloop(delayTF, absorptionFilters, matrixTF, inverseMatrix);

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

%% Reject unstable poles
if rejectUnstablePoles
    ind = abs(poles) <= 1;
    poles = poles(ind);
    quality = quality(ind);
end

%% Filter high quality poles
isConverged = quality < qualityThreshold * 1000; % be looser here than in the search
poles = poles(isConverged);
metaData.convergedPoles = poles;

if length(poles) ~= numberOfPoles
    warning('Some poles did not converge: %d instead of %d',length(poles),numberOfPoles);
end

%% TODO: Initialize Extra Filter Poles directly
% filterPoles = loopMatrix.feedbackTF.matrix.poles;
% poles = [poles filterPoles];

%% Pair complex-conjugated pairs
[poles, isConjugatePolePair, metaData.nonPairedPoles] = reduceConjugatePairs(poles);

fprintf('Final number of poles are: %d of possible %d \n',sum(isConjugatePolePair+1),numberOfPoles);

%% Compute residues
[residues,direct,undrivenResidues] = dss2res(poles,loopMatrix,B,C,D);

metaData.undrivenResidues = undrivenResidues;


