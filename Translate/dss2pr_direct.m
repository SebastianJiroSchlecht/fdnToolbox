function [residues, poles, direct, isConjugatePolePair, metaData] = dss2pr_direct(delays,A,B,C,D,type)
%dss2pr_direct - From state-space to poles and residues
% Similar to residues, but with delays. Also, this function supports multiple
% input and output. Direct and slow version of the algorithms is derived in 
% Schlecht, S. J., & Habets, E. A. P. (2018). Modal decomposition of
% feedback delay networks. IEEE Trans. Signal Process., submitted.
%
% Syntax:  [residues, poles, direct, isConjugatePolePair, metaData] = dss2pr(delays,A,B,C,D,type)
%
% Inputs:
%    delays - delays in samples of size [1,N]
%    A - feedback matrix, scalar or polynomial of size [N,N,(order)]
%    B - input gains of size [N,in]
%    C - output gains of size [out,N]
%    D - direct gains of size [out,in]
%    type - either 'eig', 'roots', 'polyeig'
%
% Outputs:
%    residues - matrix of system residues
%    poles - system poles
%    direct - direct gain
%    isConjugatePolePair - logical index whether poles are pair or real
%    metaData - additional output values 
%
% See also: dss2pr,  example_dss2pr_direct
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 28 December 2019; Last revision: 28 December 2019

%% Initialize
N = length(delays);

%% Find poles
switch type
    case 'eig'
        AA = dss2ss(delays, A);
        polEig = eig(AA);
        poles = polEig.';
    case 'roots'
        p = generalCharPoly(delays, A);
        pol = roots(p);
        poles = pol.';
    case 'polyeig'
        AA = zeros(N,N,max(delays)+1);
        AA(:,:,1) = A;
        for it = 1:N
           AA(it,it,delays(it)+1) = -1;
        end
        len = size(AA,3);
        CC = mat2cell(AA,N,N,ones(len,1));
        [X,E,s] = polyeig(CC{:}); 
        ind = isfinite(E);
        X = X(:,ind);
        E = E(ind);
        poles = E.';
    otherwise
        error('Type not defined');
end

[poles, isConjugatePolePair] = reduceConjugatePairs(poles);

%% Compute residues
loopMatrix = zFDNloopSimple( delays, A);
[residues,direct,undrivenResidues] = dss2res(poles,loopMatrix,B,C,D);

metaData.undrivenResidues = undrivenResidues;


