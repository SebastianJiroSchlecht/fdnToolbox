classdef zFIR < zFilter
    
    properties
        matrix
        matrixDer
    end
    
    methods
        function obj = zFIR(b,varargin)
            [obj.n,obj.m,len] = size(b);
            obj.parseArguments(varargin);
            obj.checkShape(obj.m);
            
            obj.matrix = tfMatrix(b,ones(obj.n,obj.m),'z^-1');
            
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
        
        function tf = inverse(obj)
            tf = zTF(obj.matrix.denominator, obj.matrix.numerator, 'isDiagonal', obj.isDiagonal);
        end
        
        function type = dfiltType(obj)
            type = 'dffir';
        end
        
        function val = dfiltParameter(obj,n,m)
            val = {obj.matrix.numerator(n,m,:)};
        end
    end
end