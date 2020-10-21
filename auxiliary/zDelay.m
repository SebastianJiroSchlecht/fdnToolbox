classdef zDelay < zFilter
    
    properties
        delays
    end
    
    methods
        function obj = zDelay(delays, varargin)
            obj.parseArguments(varargin);
            
            obj.delays = delays;
            
            obj.numberOfDelayUnits = sum(obj.delays); % TODO not for full delay matrices
            
        end
        
        
        function val = at_(obj,z)
            val = (z.^obj.delays);
        end
        
        function val = der_(obj,z) 
            val = (z.^(obj.delays-1) .* obj.delays);
        end
    end
end