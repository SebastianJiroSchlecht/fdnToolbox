function [allResidues, allPoles] = restoreConjugatePairs(residues, poles, isConjugatePolePair)
% Generate the full set of residues and poles from the conjugate pairs
%
% Sebastian J. Schlecht, Sunday, 13. January 2019

allResidues = [];
if ~isempty(residues)
    conjResidues = conj(residues(isConjugatePolePair == 1,:,:));
    allResidues = cat(1, residues, conjResidues);
end

allPoles = [];
if ~isempty(poles)
    conjPoles = conj(poles(isConjugatePolePair == 1));
    allPoles = [poles, conjPoles];
end
    
