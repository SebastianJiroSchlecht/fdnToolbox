classdef zDelay < zFilter
% z-Domain filter for diagonal delay matrix
% Delays are positive for negative exponents
%
% Sebastian J. Schlecht, Friday, 23. October 2020
    
    properties
        delays
    end
    
    methods
        function obj = zDelay(delays, varargin)
            obj.parseArguments(varargin);
            [obj.n,obj.m] = size(delays);
            obj.checkShape(obj.m);
            assert(obj.m == 1 && obj.isDiagonal, 'Currently only defined for diagonal matrices');
            
            obj.delays = delays;
            
            obj.numberOfDelayUnits = sum(abs(obj.delays(:)));         
        end
        
        function isDiagonal = defaultShape(obj)
            isDiagonal = true;
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
        
        function type = dfiltType(obj)
            type = 'none';
        end
        
        function val = dfiltParameter(obj,n,m)
            val = [];
        end
    end
end