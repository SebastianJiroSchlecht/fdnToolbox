classdef zTF < zFilter
    
    properties
        matrix
        matrixDer
    end
    
    methods
        function obj = zTF(b,a,varargin)
            obj.parseArguments(varargin);
            
            [bn,bm,len] = size(b);
            [obj.n,obj.m,len] = size(a);
            assert(bn == obj.n, 'Filter sizes need to match')
            assert(bm == obj.m, 'Filter sizes need to match')
            obj.checkShape(obj.m);
            
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
        
        function tf = inverse(obj)
            tf = zTF(obj.matrix.denominator, obj.matrix.numerator, 'isDiagonal', obj.isDiagonal);
        end
        
        function type = dfiltType(obj)
            type = 'df2';
        end
        
        function val = dfiltParameter(obj,n,m)
            b = permute(obj.matrix.numerator(n,m,:),[3 1 2]);
            a = permute(obj.matrix.denominator(n,m,:),[3 1 2]);
            val = {b,a};
        end
    end
end