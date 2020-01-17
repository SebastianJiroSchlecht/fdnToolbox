classdef zDomainDelay < handle
% Delay Matrix D(1/z) = diag(z^delays)
%
% Sebastian J. Schlecht, Sunday, 29 December 2019

    properties
        delays        
        numberOfDelayUnits
    end
    methods
        function obj = zDomainDelay(delays)
            obj.delays = delays(:);
            obj.numberOfDelayUnits = sum(obj.delays);
        end
        
        function val = at(obj,z)
            val = diag(z.^obj.delays);
        end
        
        function val = der(obj,z) 
            val = diag(z.^(obj.delays-1) .* obj.delays);
        end
    end
end