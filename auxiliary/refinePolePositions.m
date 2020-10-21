function [poles,quality, metaData] = refinePolePositions(poles, loop, varargin)
%refinePolePositions - Improve pole position with Ehrlich-Aberth Iteration
% see Schlecht, S., Habets, E. (2019). Modal Decomposition of Feedback
% Delay Networks IEEE Trans. Signal Process.
% 67(20)https://dx.doi.org/10.1109/tsp.2019.2937286 
% 
% see Bini, D. A., & Noferini, V. (2013). Solving polynomial eigenvalue
% problems by means of the Ehrlich-Aberth method. Linear Algebra Appl.,
% 439(4), 1130-1149. http://doi.org/10.1016/j.laa.2013.02.024
%
% Syntax: [poles,quality, metaData] = refinePolePositions(poles, loop, varargin)
%
% Inputs:
%    poles - Vector of pole positions
%    loop - FDN loop transfer function
%    varargin - Optional
%
% Outputs:
%    poles - Improved vector of pole positions
%    quality - Quality of poles
%    metaData - Extra data on process
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
% 30 December 2019; Last revision: 30 December 2019

%% Input parser
p = inputParser;
validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x > 0);
addParameter(p,'QualityThreshold',1000 * eps,validScalarPosNum);
addParameter(p,'MaximumIterations',50,validScalarPosNum);
addParameter(p,'DeflationType','fullDeflation',@ischar);
addParameter(p,'Verbose',false,@islogical);
parse(p,varargin{:});

QualityThreshold = p.Results.QualityThreshold;
MaximumIterations = p.Results.MaximumIterations;
DeflationType = p.Results.DeflationType;
isVerbose = p.Results.Verbose;


%% Init
stepCounter = 0;
exactCounter = 0;
poles = sortby(poles,angle(poles));
numberOfPoles = length(poles);

recordNeighborDeflation = [];
recordNewton = [];
recordPoles(1,:) = poles;

%% Deflation parameters
numberOfNeighbors = round(numberOfPoles / 100 / 2)*2;
deflationMaxError = 1000;

% Compute quality of poles
quality = poleQuality(poles, loop);
qualityOfLastIteration = quality;

%% Ehrlich Aberth Iteration
if isVerbose
    disp(['Ehrlich-Aberth Iteration with ' num2str(numberOfPoles) ' poles and a maximum of ' num2str(MaximumIterations) ' iterations'] );
end

for steps = 1:MaximumIterations
    
    switch DeflationType
        case 'neighborDeflation' % needs sorted poles for efficiency
            [poles, sortInd] = sortby(poles,angle(poles));
            quality = quality(sortInd);
            qualityOfLastIteration = qualityOfLastIteration(sortInd);
    end
        
    nonConverged = find(quality > QualityThreshold);
    
    %% Change to full deflation at the end
    if( length(nonConverged) < numberOfPoles / 10 )
        DeflationType = 'fullDeflation';
    end
    
    %% Improve pole location with Ehrlich Aberth Step
    for it = nonConverged
        if quality(it) > QualityThreshold
            stepCounter = stepCounter + 1;
            pole = poles(it);
            
            [ehrlichAberthStep,isExact] = EhrlichAberthStep( it, poles, loop, DeflationType, numberOfNeighbors, deflationMaxError, steps);
            pole = pole - ehrlichAberthStep;
            exactCounter = exactCounter + isExact;
                        
            poles(it) = pole;
            quality(it) = poleQuality(pole, loop);
        end
    end
        
    if isVerbose
        recordPoles(end+1,:) = poles;
    end
    
    %% Termination condition
    maximumImprovement = abs(max(qualityOfLastIteration - quality));
    if maximumImprovement < QualityThreshold
        if isVerbose
            disp('No further improvement possible');
        end
        break;
    else
        if isVerbose
            disp(['Iteration: ' num2str(steps) ...
                ', Maximum Improvement: ' num2str(maximumImprovement)...
                ', Worst Pole Quality: ' num2str(max(quality))...
                ', Number of Non-converged Poles: ' num2str(length(nonConverged))]);
        end
        qualityOfLastIteration = quality;
    end
end

if isVerbose
     disp(['Number of Exact Deflations: ' num2str(exactCounter)]); 
end

metaData.stepCounter = stepCounter;
metaData.exactCounter = exactCounter;
metaData.recordNeighborDeflation = recordNeighborDeflation;
metaData.recordNewton = recordNewton;
metaData.recordPoles = recordPoles;






function [ehrlichAberthStep,isExact] = EhrlichAberthStep( it, poles, loop, DeflationType, numberOfNeighbors, deflationMaxError, steps)
%% Compute Ehrlich Aberth Iteration step
invNewtonStep = computeNewtonStep( it, poles, loop);
[deflation,isExact] = computeDeflation( it, poles, invNewtonStep, DeflationType, numberOfNeighbors, deflationMaxError, steps);

ehrlichAberthStep = 1 ./ (invNewtonStep - deflation);



function invNewtonStep = computeNewtonStep( it, poles, loop)
%% Compute inverse Newton step
pole = poles(it);

invNewtonStep = loop.inverseNewtonStep(pole);

% if abs(pole) > 1
% %     reversedNewton = trace( loop.atRev(1/pole)  \ loop.derRev(1/pole) ) + trace(  loop.invMatrix.at(1/pole) * loop.matrixDer.at(pole) / -(1/pole)^2 );
%     reversedNewton = trace( loop.atRev(1/pole)  \ loop.derRev(1/pole) ) + trace(  loop.feedbackTF.at(pole) \ loop.feedbackTF.der(pole) / -(1/pole)^2 );
%     invNewtonStep = loop.numberOfDelayUnits / pole - reversedNewton / pole^2;
% else
%     invNewtonStep = trace( loop.at(pole)  \ loop.der(pole)  ) + loop.numberOfMatrixDelays / pole;
% end


function [deflation,isExact] = computeDeflation( it, poles, invNewtonStep, DeflationType, numberOfNeighbors, deflationMaxError, steps)
%% Compute deflation depending on type
pole = poles(it);

switch DeflationType
    case 'fullDeflation'
        neighborDistance = pole - poles;
        neighborDistance(it) = 1/eps; % exlude self
        deflation = sum( 1./neighborDistance );
        isExact = 1;
    case 'noDeflation'
        deflation = 0;
        isExact = 0;
    case 'neighborDeflation'
        [deflation,isExact] = closeNeighborDeflation(it, poles, numberOfNeighbors, invNewtonStep, deflationMaxError, steps);
    otherwise
        error('Unknown deflation type');
end




function [deflation,isExact,neighborDeflation,equiDeflation] = closeNeighborDeflation(it, poles, numberOfNeighbors, invNewtonStep, deflationMaxError, steps)
%% Compute Deflation approximation
pole = poles(it);
numberOfPoles = length(poles);
if steps == 1 % use fact that in first iteration all poles a equidistributed
    neighborDeflation = 0;
    factorNonneighbor = (numberOfPoles-1)/2;
else % normal step
    neighborDeflation = sum(1./(pole-poles(mod( it + [-numberOfNeighbors/2:-1,1:numberOfNeighbors/2] - 1, numberOfPoles) + 1)));
    factorNonneighbor = (numberOfPoles - numberOfNeighbors-1)/2;
end
equiDeflation = + conj(pole)*factorNonneighbor;

deflation = neighborDeflation + equiDeflation;

%% Check the quality of the approximation, and do exact step if neccessary
isExact = 0;
if steps ~= 1 
    if abs(invNewtonStep - deflation) < deflationMaxError
        [deflation,isExact] = computeDeflation( it, poles, invNewtonStep, 'fullDeflation', numberOfNeighbors, deflationMaxError, steps);
    end
end

