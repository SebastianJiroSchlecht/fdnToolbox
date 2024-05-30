function quality = poleQuality_dsp(poles, loop)
% Computes the pole quality of poles in loop, i.e., whether how singular loop(poles) is. 
% Low value = high quality
% 
% (c) Sebastian Jiro Schlecht:  14. May 2018

quality = zeros(size(poles));

for it=1:numel(quality)
    % if abs(poles(it)) > 1
    %     % m = loop.atRev(1/poles(it));
    %     warning('Poles are out');
    %     m = 1;
    % else
    %     m = loop.atat(poles(it));
    % end
    m = loop.atLoop(poles(it),'z');

    if isscalar(m)
        quality(it) = abs(m);
    else
        quality(it) = rcond(m);    
    end
    
    if max(abs(m(:))) > 10^10 % remove degenerate solutions
        quality(it) = 10^10;
    end
end

