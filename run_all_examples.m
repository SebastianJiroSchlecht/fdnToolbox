% run all examples

%% generate names
files = dir('*/example_*');
fileNames = {files.name};
fprintf('%s\n',fileNames{:})

%% Run
% fileNames = {fileNames{2}, fileNames{13}}
results = runtests({fileNames{35}})
table(results)

% example_FDNdecorrelation
% example_absorptionFilters
% example_absorptionFiltersFDN
% % example_absorptionGEQ
% example_absorptionScatteringFDN
% example_allpassFilterFDN
% example_complexOscillatorBank
% example_delayEquivalent
% example_delayMatrix
% example_delayMatrixDensity
% example_dss2pr
% example_dss2pr_direct
% example_dss2ss
% example_dss2tf
% example_generalCharPoly
% % example_graphicEQ
% example_interpolateMatrix
% example_inversePolynomialMatrix
% example_isDiagonallyEquivalentToOrthogonal
% example_fdnMatrixGallery
% example_nearestSignAgnosticOrthogonal
% example_nestedAllpass
% example_newtonStep
% example_onePoleAbsorption
% example_paraunitaryFDN
% example_poleBoundaries
% example_processFDN
% example_proportionalAbsorption
% example_randomFDNstatistics
% example_reversedGCP
% example_scatteringFDN
% example_spreadFDNpoles
% example_timeVaryingFDN
% example_timeVaryingMatrix
% example_zDomainLoop