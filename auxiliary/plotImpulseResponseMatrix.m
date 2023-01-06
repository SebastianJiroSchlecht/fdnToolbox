function [plotAxes, plotHandles, commonAx] = plotImpulseResponseMatrix( t, ir, varargin )
%plotImpulseResponseMatrix - Plot matrix of impulse response / polynomial matrix in subplots
%
% Syntax:  [plotAxes, plotHandles] = plotImpulseResponseMatrix( t, ir, varargin )
%
% Inputs:
%    t - x-values, e.g., time-domain variable of size [FIR,1] or [1,FIR]
%    ir - matrix of y-values of size [out, in, FIR]
%    varargin - extra plotting parameters
%
% Outputs:
%    plotAxes - Matrix of axes handles; size [out, in]
%    plotHandles - Matrix of axes handles; size [out, in]
%    commonAx - Struct of commnon axes handles with the joint labels
%
% Example: 
%    [plotAxes, plotHandles] = plotImpulseResponseMatrix( 1:100, randn(3,2,100), 'xlabel','Time (seconds)','ylim',[-1, 1])
%
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 29. December 2019; Last revision: 5. April 2021

%% parse input
p = inputParser;
p.KeepUnmatched = true;
addParameter(p,'xlabel',[]);
addParameter(p,'ylabel',[]);
addParameter(p,'title',[]);
addParameter(p,'xlim',[]);
addParameter(p,'ylim',[]);
parse(p,varargin{:});

xLabel = p.Results.xlabel;
yLabel = p.Results.ylabel;
Title = p.Results.title;
xLim = p.Results.xlim;
yLim = p.Results.ylim;
plotArg = [fieldnames(p.Unmatched), struct2cell(p.Unmatched)].';

%% plot
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
        plotHandles(itOut,itIn) = plot(t, ir(:,itOut,itIn),plotArg{:}); 
    end    
end

%% remote ticks of inner subplots
set(plotAxes(:,2:end), 'YTickLabel', [])
set(plotAxes(1:end-1,:), 'XTickLabel', [])

%% Give common xlabel, ylabel and title to your figure
commonAx=axes(gcf,'visible','off');
commonAx.Title.Visible='on';
commonAx.XLabel.Visible='on';
commonAx.YLabel.Visible='on';
ylabel(commonAx,yLabel);
xlabel(commonAx,xLabel);
title(commonAx,Title);

%% set limits
if isempty(xLim)
    xLims = cell2mat(get(plotAxes,'XLim'));
    commonXLim = [min(xLims(:,1)),max(xLims(:,2))];
    set(plotAxes,'XLim',commonXLim);
else
    set(plotAxes,'XLim',xLim);
end

if isempty(yLim)
    yLims = cell2mat(get(plotAxes,'YLim'));
    commonYLim = [min(yLims(:,1)),max(yLims(:,2))];
    set(plotAxes,'YLim',commonYLim);
else
    set(plotAxes,'YLim',yLim);
end

