classdef zScalar < zFilter
    % Scalar Matrix in zFilter and its derivative (= zeros)
    %
    % Sebastian J. Schlecht, Sunday, 29 December 2019
    
    properties
        matrix
        matrixDer
        
    end
    
    methods
        function obj = zScalar(m, varargin)
            [obj.n, obj.m] = size(m);
            obj.parseArguments(varargin);
            obj.checkShape(obj.m);
            
            assert(ismatrix(m),'Needs a matrix');
            
            obj.matrix = m;
            obj.matrixDer = zeros(size(m));
            obj.numberOfDelayUnits = 0;
            
        end
        
        function val = at_(obj,z)
            val = obj.matrix;
        end
        
        function val = der_(obj,z)
            val = obj.matrixDer;
        end
        
        function tf = inverse(obj)
            if obj.isDiagonal
                tf = zScalar(1./obj.matrix, 'isDiagonal', obj.isDiagonal);
            else
                tf = zScalar(inv(obj.matrix), 'isDiagonal', obj.isDiagonal);
            end
        end
        
        function type = dfiltType(obj)
            type = 'none';
        end
        
        function val = dfiltParameter(obj,n,m)
            val = obj.matrix(n,m);
        end
    end
end