classdef dsp_IIRFilter_parallel < handle
% parallel iir filters

    properties
        iirfilters
    end
       
    methods
        function obj = dsp_IIRFilter_parallel(nums,dens)
            numberOfChannels = size(nums,1);
            for it = 1:numberOfChannels
                num = nums(it,:);
                den = dens(it,:);
                obj.iirfilters{it} = dsp.IIRFilter(num(:).',den(:).');
            end
        end
        
        function [output] = process(obj, input)       
            output = input*0;
            for it = 1:length(obj.iirfilters)
                output(:,it) = obj.iirfilters{it}(input(:,it));
            end
        end
    end
    
end