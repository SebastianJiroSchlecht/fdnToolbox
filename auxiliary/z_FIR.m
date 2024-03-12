classdef z_FIR < z_F
    
    properties
        B
        Bdiff
        Bfilt
    end
    
    methods
        function obj = z_FIR(B,varargin)
            obj.B = B;
            A = ones(size(B,[1 2]));
%             [obj.Bdiff,~] = matrix_polyder(B,A,'z^-1');
            obj.Bfilt = firMatrix(B); % TODO: only temp
        end
        
        % shape independent
        function val = at_(obj,z) 
            iz = 1/z; % TODO: is this necessary?
            num = matrix_polyval(obj.flipNumerator,iz);
        end
        
        function val = der_(obj,z)
            val = obj.matrixDer.at(z);
        end
        
        function tf = inverse(obj) % TODO: is this necessary?
            tf = zTF(obj.matrix.denominator, obj.matrix.numerator, 'isDiagonal', obj.isDiagonal);
        end
        
        function y = filt(obj,x)
%             y = filter(obj.B,1,x);
%             y = matrixConvolution(obj.B,x);
            y = obj.Bfilt.filter(x);
        end

        function y = getIR(obj)
            y = obj.B;
        end
    end
end