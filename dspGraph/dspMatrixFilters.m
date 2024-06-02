classdef dspMatrixFilters < dspBlock
    % matrix of filters

    properties
        
        numDelay

        TF
        dTFz
        dTFiz

        filters % time-domain filters
    end

    methods
        %b = size N x 1 x len
        %a = size N x 1 x len
        function obj = dspMatrixFilters(b,a)
            obj.numberOfOutputs = size(b,1);
            obj.numberOfInputs = size(b,1);

            obj.numDelay = numel(b); % TODO overestimates; better to use polydet degree
            obj.numDelay = max(size(b,[1 2])) * size(b,3);
            
            if nargin == 2 % IIR
                
            else % FIR
                a = 1 + 0*b(:,:,1);
            end

            obj.TF = tfMatrix_dsp(b,a);

            obj.dTFz = obj.TF.derive('z^1');
            obj.dTFiz = obj.TF.derive('z^-1');

            % obj.filters = dsp_IIRFilter_matrix(b,a);
        end

        function Y = at(obj,X,z,var)
            Z = obj.TF.at(z,var);
            % Y = einsum(Z,X,'mnf,fnk->fmk');
            Y = sum(permute(Z,[3 1 4 2]) .* permute(X,[1 4 3 2]),4); 
        end

        function Y = der(obj,X,z,var)
            switch var
                case 'z^1'
                    Z = obj.dTFz.at(z,var);
                case 'z^-1'
                    Z = obj.dTFiz.at(z,var);
            end
            Y = sum(permute(Z,[3 1 4 2]) .* permute(X,[1 4 3 2]),4);
        end

        function output = process(obj,input)
            output = obj.filters.process(input);
        end

        function val = numberOfDelays(obj)
            val = obj.numDelay;
        end
    end
end