classdef zTF < zFilter
    
    properties
        matrix
        matrixDer
    end
    
    methods
        function obj = zTF(b,a,varargin)
            obj.parseArguments(varargin);
            
            [n,m,len] = size(b);
            [n,m,len] = size(a);
            obj.checkShape(m);
            
            obj.matrix = tfMatrix(b,a,'z^-1');
            
            obj.matrixDer = derive(obj.matrix);
            obj.numberOfDelayUnits = obj.getDelays(b);
        end
        
        function delays = getDelays(obj, numerator)
            if obj.isDiagonal
                numeratorFull = polydiag( permute (numerator, [1 3 2]) );
            else
                numeratorFull = numerator;
            end
            delays = polyDegree(detPolynomial(numeratorFull,'z^-1'),'z^-1');
        end
        
        % shape independent
        function val = at_(obj,z) 
            val = obj.matrix.at(z);
        end
        
        function val = der_(obj,z)
            val = obj.matrixDer.at(z);
        end
    end
end