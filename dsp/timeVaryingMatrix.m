classdef timeVaryingMatrix < handle
% Time-varying orthogonal matrix processor  
%
% Sebastian J. Schlecht, Sunday, 29 December 2019
    properties
        filters = dfilt.df2;
        matrix = 0;
        currentMatrix;
        
        numberOfOutputs
        numberOfInputs  
    end
    
    properties (Access = private)
        osc
        transform
    end
    
    methods
        function obj = timeVaryingMatrix(N, cyclesPerSecond, amplitude, fs, spread)
            
            obj.matrix = tinyRotationMatrix(N,1/fs);
            
            [v,e] = eig(obj.matrix);
            obj.transform = v;
            
            cyclesPerSample = cyclesPerSecond / fs;
            
            frequencySpread = 2*(rand(1,N)-0.5) * spread + 1;
            amplitudeSpread = 2*(rand(1,N)-0.5) * spread + 1;
            
            % make conjugate pairs
            IDX = nearestneighbour(v,conj(v));
            amplitudeSpread = (amplitudeSpread(IDX) + amplitudeSpread) / 2;
            frequencySpread = (frequencySpread(IDX) + frequencySpread) / 2;
            complexConjugateSign = sign(angle(diag(e))).';
            oscAmplitude = complexConjugateSign * amplitude * pi/2;
            
            % make eigenvalue oscillators
            obj.osc = complexOscillatorBank( frequencySpread .* cyclesPerSample, amplitudeSpread .* oscAmplitude);
            
            
            obj.numberOfOutputs = N;
            obj.numberOfInputs = N;
            
        end
        
        function out = filter(obj,in)
            len = size(in,1);
            % get time-varying eigenvalues
            e = obj.osc.get(len);
            
            % process
            in = in * obj.transform;
            in = in .* e;
            out = real( in * obj.transform' );
        end
    end
end

