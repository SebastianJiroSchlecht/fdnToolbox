function [plotAxes, plotHandles] = plotImpulseResponseMatrix( t, ir, varargin )
% Plot matrix of impulse response / polynomial matrix in subplots [out, in, FIR]
%
% Sebastian J. Schlecht, Sunday, 29 December 2019

if isempty(t)
   t = 1:size(ir,3); 
end

% change order to [FIR, out, in]
ir = permute(ir,[3 1 2]);
numberOfOutputs = size(ir,2);
numberOfInputs = size(ir,3);

for itOut = 1:numberOfOutputs
    for itIn = 1:numberOfInputs
        plotAxes(itOut,itIn) = subplot(numberOfOutputs, numberOfInputs, sub2ind([numberOfInputs,numberOfOutputs], itIn, itOut)); 
        hold on; grid on;
%         plotHandles(itOut,itIn) = reduce_plot(t, ir(:,itOut,itIn),varargin{:});
        plotHandles(itOut,itIn) = stem(t, ir(:,itOut,itIn),varargin{:});
    end
end


