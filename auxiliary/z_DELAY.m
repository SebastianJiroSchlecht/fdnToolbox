classdef z_DELAY < z_F
    
    properties
        delays
        Bdiff
        filter
    end
    
    methods
        function obj = z_DELAY(delays,varargin)
            obj.delays = delays;
%             A = ones(size(B,[1 2]));
%             [obj.Bdiff,~] = matrix_polyder(B,A,'z^-1');
%             obj.Bfilt = firMatrix(B); % TODO: only temp
            obj.filter = feedbackDelay(max(delays), delays);
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
            blockSize = size(x,1);

%             y = filter(obj.B,1,x);
%             y = matrixConvolution(obj.B,x);
%             y = obj.Bfilt.filter(x);

            
            y = obj.filter.getValues(blockSize);
            obj.filter.setValues(x);

            obj.filter.next(blockSize);
        end 

        function y = getIR(obj)
            y = obj.B;
        end
    end
end