function FIR = absorptionFilters(frequency, targetRT60, filterOrder, delays, fs)
%absorptionFilters - Generate delay-proportional absorption filters
%Generates an FIR filter with given filter order such that placed in a
%recursion loop with a given delay, a specified reverberation time is
%achieved. Multiple channels filters can be generated at once. The first
%and last elements of frequency must equal 0 and fs/2, respectively.
%
%
% Syntax:  FIR = absorptionFilters(unitFrequency, targetRT60, filterOrder, delays, fs)
%
% Inputs:
%    frequency - Frequency points for T60 definition in [hertz]
%    targetRT60 - Target T60 in [seconds] and size [frequency, channels]
%    filterOrder - FIR filter order [samples]
%    delays - Loop delay length in [samples] and size [1, channels]
%    fs - Sampling frequency in [hertz]
%
% Outputs:
%    FIR - FIR filter coefficients
%
% Example:
%    FIR = absorptionFilters([0; 5000; 24000], [1; 1; 0.5], 30, 100, 48000)
%
% Other m-files required: RT602slope
% Subfunctions: none
% MAT-files required: none
%
% See also: absorption2T60
% Author: Dr.-Ing. Sebastian Jiro Schlecht,
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 23 December 2019; Last revision: 23 December 2019

%% abbreviation
numberOfDelays = length(delays);
unitFrequency = hertz2unit(frequency,fs);

%% compute filters per channel
FIR = zeros(numberOfDelays, filterOrder+1);

if( filterOrder == 0)
    rt60 =  targetRT60(1,:);
    delay = delays;
    db = delay.*RT602slope(rt60, fs);
    FIR = db2mag(db);
else
    for ch = 1:numberOfDelays
        rt60 =  targetRT60(:,ch);
        delay = delays(ch);
        
        delay = delay + ceil(filterOrder/2);
        db = delay*RT602slope(rt60, fs);
        targetAmplitude = db2mag(db);
        
        %% Filter Approximation with window method
        FIR(ch,:) = fir2(filterOrder,unitFrequency,targetAmplitude);
    end
end