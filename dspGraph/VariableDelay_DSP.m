classdef VariableDelay_DSP < DSP
    % Multiple input, multiple output delay line
    % Usage:
    %     variablePropagationDelay.setDelay( 0 );
    %     outSig = variablePropagationDelay.process(frame);
    % PROVIDED %
    %
    % See usage demo in test_VariableDelay_DSP

    properties
        % DSP
        delayUnit

        % Parameters
        newDelay
        lastDelay
    end


    methods
        function obj = VariableDelay_DSP(numberOfInputs, config)
            % Set block size
            obj.blockSize = config.blockSize;

            % Define the input and output number of channels
            obj.numberOfInputs = numberOfInputs;
            obj.numberOfOutputs = numberOfInputs; % output is delayed input

            % The processing is handled by MATLABs VariableFractionalDelay
            obj.delayUnit = dsp.VariableFractionalDelay;
            obj.delayUnit.MaximumDelay = config.maximumDelay;

            % For the delay interpolation, the last and new delays are
            % stored
            obj.lastDelay = zeros(1, obj.numberOfInputs);
            obj.newDelay = obj.lastDelay;

            obj.CheckConfig();
        end

        function outSig = process(obj, inSig)
            % Delay the input signal [t x nCH] by the delay specified with
            % setDelay()
            blockSize = size(inSig,1);

            % compute the interpolated delay values
            delayCurve = obj.interpolateDelays(blockSize);

            % process the input signal with the time-varying delays
            outSig = obj.delayUnit(inSig, delayCurve);
            % outSig = obj.delayUnit(inSig, obj.newDelay);
            
            % update last delays with current
            obj.lastDelay = obj.newDelay;
        end

        function setDelay(obj, newDelay)
            % set new delay (in samples) [val x nCH]
            assert( size(newDelay, 2) == obj.numberOfInputs, 'Incorrect size of delays');
            obj.newDelay = newDelay;
        end

        function delayCurve = interpolateDelays(obj, blockSize)
            % linear interpolation between delay values on a block by block
            % basis.
            linearFadeIn = linspace(0, 1, blockSize).';
            linearFadeOut = linspace(1, 0, blockSize).';

            delayCurve = linearFadeIn .* obj.newDelay + ...
                linearFadeOut .* obj.lastDelay;
        end

        function runTest(obj) % required for provided inclusion
            test_VariableDelay_DSP;
        end
    end

end