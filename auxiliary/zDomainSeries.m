classdef zDomainSeries < handle
% Series combination of zDomain matrices
%
% Sebastian J. Schlecht, Sunday, 29 December 2019

    properties
        TF1
        TF2
    end
    
    methods
        function obj = zDomainSeries(TF1,TF2)           
            obj.TF1 = TF1;
            obj.TF2 = TF2;            
        end
        
        function val = at(obj,z)
            val = at(obj.TF1,z) * at(obj.TF2,z);
        end
        
        function val = der(obj,z)
            % d(A,B) = d(A) * B + A * d(B)
            val = der(obj.TF1,z) * at(obj.TF2,z) + at(obj.TF1,z) * der(obj.TF2,z);
        end
        
        function val = numberOfDelayUnits(obj)
            val = obj.TF1.numberOfDelayUnits + obj.TF2.numberOfDelayUnits;
        end
        
    end
end