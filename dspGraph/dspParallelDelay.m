classdef dspParallelDelay < dspBlock

    properties
        delays
        filter
    end

    methods
        function obj = dspParallelDelay(delays,varargin)
            obj.delays = delays(:).';
            obj.numberOfOutputs = numel(delays);
            obj.numberOfInputs = numel(delays);

            obj.filter = dsp.VariableFractionalDelay;
            obj.filter.MaximumDelay = max(delays)*2;

        end

        function Y = at(obj,X,z,var)
            var = obj.setVar(var);

            switch var
                case 'z^-1'
                    Y = X .* z.^-obj.delays;
                case 'z'
                    Y = X .* z.^obj.delays;
                otherwise
                    error('Undefined');
            end
        end

        function Y = der(obj,X,z,var)
            var = obj.setVar(var);

            switch var
                case 'z^-1'
                    Y = X .* (-obj.delays .* z.^(-obj.delays-1));
                case 'z'
                    Y = X .* (obj.delays .* z.^(obj.delays-1));
                otherwise
                    error('Undefined');
            end
        end

        function output = process(obj,input)
            output = obj.filter(input,obj.delays(:).');
        end

        function val = numberOfDelays(obj)
            val = sum(obj.delays);
        end
    end
end