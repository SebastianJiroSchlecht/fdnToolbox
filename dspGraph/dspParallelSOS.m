classdef dspParallelSOS < dspBlock
    % Parallel gains = diagonal matrix multiplication

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
        function obj = dspParallelSOS(sos)
            obj.numberOfOutputs = size(sos,1);
            obj.numberOfInputs = size(sos,1);

            obj.numDelay = numel(sos)/3;

            obj.TF = sosMatrix_dsp(sos);

            % obj.dTFz = obj.TF.derive('z^1');
            % obj.dTFiz = obj.TF.derive('z^-1');

            % obj.filters = dsp_SOSFilter_parallel(b,a);
        end

        function Y = at(obj,X,z,var)
            Z = obj.TF.at(z,var);
            Y = X .* permute(Z,[3 1 2]);
        end

        function Y = der(obj,X,z,var)
            error('not implemented yet');
        end

        function output = process(obj,input)
            % output = obj.filters.process(input);
            error('not implemented yet');
        end

        function val = numberOfDelays(obj)
            val = obj.numDelay;
        end
    end
end