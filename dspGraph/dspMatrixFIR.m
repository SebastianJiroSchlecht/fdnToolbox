classdef dspMatrixFIR < dspBlock
    % matrix gains = full matrix multiplication

    properties
        
        numDelay

        TF
        dTFz
        dTFiz

        filters % time-domain filters
    end

    methods
        %b = size N x M x len
        function obj = dspMatrixFIR(b)
            obj.numberOfOutputs = size(b,1);
            obj.numberOfInputs = size(b,2);

            obj.numDelay = numel(b);

            if nargin == 2 % IIR
                
            else % FIR
                a = 1 + 0*b(:,:,1);
            end

            obj.TF = tfMatrix_dsp(b,a);

            obj.dTFz = obj.TF.derive('z^1');
            obj.dTFiz = obj.TF.derive('z^-1');

            obj.filters = dsp_IIRFilter_parallel(b,a);
        end

        function Y = at(obj,X,z,var)
            Z = obj.TF.at(z,var);
            Y = X .* permute(Z,[3 1 2]);
        end

        function Y = der(obj,X,z,var)
            switch var
                case 'z^1'
                    Z = obj.dTFz.at(z,var);
                case 'z^-1'
                    Z = obj.dTFiz.at(z,var);
            end
            Y = X .* permute(Z,[3 1 2]);
        end

        function output = process(obj,input)
            output = obj.filters.process(input);
        end

        function val = numberOfDelays(obj)
            val = obj.numDelay;
        end
    end
end