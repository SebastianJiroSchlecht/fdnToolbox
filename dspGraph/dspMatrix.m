classdef dspMatrix < dspBlock
    % Matrix multiplication
    
    properties
        matrix
    end
    
    methods
        function obj = dspMatrix(matrix,varargin)
            obj.matrix = matrix;
            [obj.numberOfOutputs, obj.numberOfInputs] = size(matrix);
        end

        function Y = at(obj,X,z,var)
            % Y = einsum(obj.matrix, X, 'mn,fnk->fmk'); % parsing is too
            % slow
            assert(size(X,2) == obj.numberOfInputs); % TODO: add more of these asserts
            Y = sum(permute(obj.matrix, [3 1 4 2]) .* permute(X, [1 4 3 2]),4); 
            assert(size(Y,2) == obj.numberOfOutputs);
            % ok = 1;
        end
         
         function val = der(obj,X,z,var)
            val = 0*obj.matrix;
            val = permute(val,[3 1 2]);
         end

         function output = process(obj,input)
            output = (obj.matrix * input.').';
         end      

         function val = numberOfDelays(obj)
             val = 0;
         end
    end
end