classdef zDomainMatrix < handle
% IIR/FIR Matrix in zDomain and its derivative
%
% Sebastian J. Schlecht, Sunday, 29 December 2019

    properties
        matrix
        numberOfDelayUnits
        matrixDer
    end
    methods
        function obj = zDomainMatrix(numerator,denominator)
            if nargin == 2 % IIR
                obj.matrix = tfMatrix(numerator,denominator,'z^-1');
            else % FIR
                N = size(numerator,2);
                obj.matrix = tfMatrix(numerator,ones(N),'z^-1');
            end
            
            obj.matrixDer = derive(obj.matrix);
            obj.numberOfDelayUnits = obj.getDelays(numerator);
        end
        
        function delays = getDelays(obj, numerator)
            delays = polyDegree(detPolynomial(numerator,'z^-1'),'z^-1');
        end
        
        function val = at(obj,z)
            val = at(obj.matrix,z);
        end
        
        function val = der(obj,z)
            val = at(obj.matrixDer,z);
        end
        
        function val = b(obj)
           val = obj.matrix.numerator; 
        end
        
        function val = a(obj)
           val = obj.matrix.denominator; 
        end
    end
end