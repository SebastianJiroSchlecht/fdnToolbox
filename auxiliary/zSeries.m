classdef zSeries < zFilter
% Series combination of zFilter matrices
%
% Sebastian J. Schlecht, Sunday, 29 December 2019

    properties
        z1
        z2
    end
    
    methods
        function obj = zSeries(z1,z2)           
            obj.z1 = z1;
            obj.z2 = z2;            
        end
        
        function delays = getDelays(obj, numerator)
            % TODO: strange
        end
        
        function val = at(obj,z)
            val = at(obj.z1,z) * at(obj.z2,z);
        end
        
        function val = der(obj,z)
            % d(A,B) = d(A) * B + A * d(B)
            val = der(obj.z1,z) * at(obj.z2,z) + at(obj.z1,z) * der(obj.z2,z);
        end
        
        function val = numberOfDelayUnits(obj)
            val = obj.z1.numberOfDelayUnits + obj.z2.numberOfDelayUnits;
        end
        
    end
end