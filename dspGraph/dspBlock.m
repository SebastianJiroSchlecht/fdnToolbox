classdef dspBlock < handle
    % Filter structure abstract class
    %
    % From this multiple classes are derived 
    %
    % Sebastian J. Schlecht, Tuesday, 28. May 2024
    
    properties
        numberOfInputs
        numberOfOutputs
        blockSize = 100000; % large number
    end
    
    methods
        
        function [n,m] = size(obj)
            n = obj.n;
            m = obj.m;
            
            if isempty(n) || isempty(m)
               error('Size is not defined'); 
            end
        end

    end
    
    methods(Static)
        function var = setVar(var)
            if isempty(var)
                var = 'z^-1';
            end
        end
    end
    
    methods(Abstract)
         % z value 
         at(obj,X,z)
         
         % z value of derivative 
         der(obj,X,z)

         % time-domain processing
         process(obj,input)

         % returns the number of delays
         numberOfDelays(obj)
    end
end