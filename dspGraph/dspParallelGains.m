classdef dspParallelGains < dspBlock
    % Parallel gains = diagonal matrix multiplication
    
    properties
        gains
    end
    
    methods
        function obj = dspParallelGains(gains,varargin)
            obj.gains = gains(:).';
            obj.numberOfOutputs = numel(gains);
            obj.numberOfInputs = numel(gains);
        end

        function Y = at(obj,X,z,var)
            Y = X .* obj.gains; 
        end
         
         function Y = der(obj,X,z,var)
            Y = diag(0*obj.gains);
            Y = permute(Y,[3 1 2]);
         end

         function output = process(obj,input)
            output = (obj.gains .* input);
         end   

         function val = numberOfDelays(obj)
             val = 0;
         end
    end
end