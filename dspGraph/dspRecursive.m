classdef dspRecursive < dspBlock
    % Recursive combination of feedforward and feedback loop. Because of the
    % time-domain block processing, there is an inherent additional delay
    % of one block. This extra buffer is included in the frequency domain
    % sampling as well so the two methods align.

    properties
        feedforward
        feedback
        feedbackWithoutBufferDelay

        lastOutput
        bufferDelay
    end

    methods
        function obj = dspRecursive(blockSize, feedforward, feedback, varargin)
            obj.blockSize = blockSize;
            obj.numberOfOutputs = feedforward.numberOfOutputs;
            obj.numberOfInputs = feedforward.numberOfInputs;

            obj.bufferDelay = dspParallelDelay(blockSize * ones(obj.numberOfInputs,1));

            obj.feedforward = dspSequential(obj.bufferDelay,feedforward);
            obj.feedback = dspSequential(feedback,obj.bufferDelay);
            obj.feedbackWithoutBufferDelay = feedback; % for time-domain processing

            obj.lastOutput = zeros(blockSize,obj.numberOfOutputs);


        end

        % G is the feedforward path with size (nfft,m,n)
        % H is the feedback path with size (nfft,n,m)
        % Y/X = (I - GH)^-1 G
        % https://en.wikipedia.org/wiki/Closed-loop_transfer_function
        function Y = at(obj,X,z,var)
            var = obj.setVar(var);

            B = obj.feedforward.at(X,z,var);
            
            I = eyeBatch(numel(z),obj.numberOfOutputs,obj.numberOfInputs);
            HH = obj.feedback.at(I,z,var);
            A = I - obj.feedforward.at(HH,z,var);

            Y = linsolveBatch(A,B);
        end

        function val = der(obj,z,var)
            % val = 0*obj.matrix; % TODO
        end


        function A = atLoop(obj,z,var) % loop has no signal input
            var = obj.setVar(var);

            I = eyeBatch(numel(z),obj.numberOfOutputs,obj.numberOfInputs);
            HH = obj.feedback.at(I,z,var);
            A = I - obj.feedforward.at(HH,z,var);

            A = permute(A,[2 3 1]); % TODO
        end

        function A = derLoop(obj,z,var) % loop has no signal input
            var = obj.setVar(var);

            I = eyeBatch(numel(z),obj.numberOfOutputs,obj.numberOfInputs);

            HH = obj.feedback.at(I,z,var);
            HHder = obj.feedback.der(I,z,var);

            A = - obj.feedforward.at(HHder,z,var) - obj.feedforward.der(HH,z,var);

            A = permute(A,[2 3 1]); % TODO
        end

        function output = process(obj,input)
            output = obj.feedforward.process(input + obj.feedbackWithoutBufferDelay.process(obj.lastOutput));
            obj.lastOutput = output; % loop delay
        end

        function val = numberOfDelays(obj)
            val = obj.feedforward.numberOfDelays + obj.feedback.numberOfDelays;
        end
    end
end