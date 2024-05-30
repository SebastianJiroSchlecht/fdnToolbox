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
            if ndims(X) == 2 %&& size(X,1) = 1
                Y = einsum(obj.matrix, X, 'mn,fn->fm'); 
            elseif ndims(X) == 3
                Y = einsum(obj.matrix, X, 'mn,fnk->fmk');
            else
                error('Size not defined');
            end
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