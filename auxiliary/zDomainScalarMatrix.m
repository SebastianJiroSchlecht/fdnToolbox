classdef zDomainScalarMatrix
% Scalar Matrix in zDomain and its derivative (= zeros)
%
% Sebastian J. Schlecht, Sunday, 29 December 2019
    
    properties
        matrix
        matrixDer
        numberOfDelayUnits
    end
    
    methods
        function obj = zDomainScalarMatrix(m)
            if ismatrix(m)
                obj.matrix = m;
                obj.matrixDer = zeros(size(m));
                obj.numberOfDelayUnits = 0;
            else
                error('Not Defined');
            end
        end 
        
        function val = at(obj,z)
            val = obj.matrix;
        end

        function val = der(obj,z)
            val = obj.matrixDer;
        end
        
        function val = b(obj)
           val = obj.matrix; 
        end
        
        function val = a(obj)
           val = ones(size(obj.matrix));
        end
    end 
end