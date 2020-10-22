classdef zDelay < zFilter
    % TODO % use delays as negative exponent
    
    properties
        delays
    end
    
    methods
        function obj = zDelay(delays, varargin)
            obj.parseArguments(varargin);
            [obj.n,obj.m] = size(delays);
            
            % TODO check shape
            
            obj.delays = delays;
            
            obj.numberOfDelayUnits = sum(abs(obj.delays)); % TODO not for full delay matrices           
        end
        
        
        function val = at_(obj,z)
            val = (z.^-obj.delays);
        end
        
        function val = der_(obj,z) 
            val = (z.^(-obj.delays-1) .* -obj.delays);
        end
        
        function tf = inverse(obj)
            tf = zDelay(-obj.delays, 'isDiagonal', obj.isDiagonal);
        end
    end
end