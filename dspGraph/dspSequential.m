classdef dspSequential < dspBlock
    % Sequential combination of two dsp blocks
    
    properties
        blockA
        blockB
        lastOutput
    end
    
    methods
        function obj = dspSequential(blockA,blockB, varargin)
            obj.blockA = blockA;
            obj.blockB = blockB;
            
            obj.numberOfInputs = obj.blockA.numberOfInputs;
            obj.numberOfOutputs = obj.blockB.numberOfOutputs;  
        end

        
        function Y = at(obj,X,z,var)
            var = obj.setVar(var);
            Y = obj.blockB.at(obj.blockA.at(X,z,var),z,var);
        end
         
         function Y = der(obj,X,z,var)
            var = obj.setVar(var);
            Y = obj.blockB.der(obj.blockA.at(X,z,var),z,var) + ...
                obj.blockB.at(obj.blockA.der(X,z,var),z,var);
         end

         function output = process(obj,input)
            output = obj.blockB.process(obj.blockA.process(input));
         end   

         function val = numberOfDelays(obj)
             val = obj.blockA.numberOfDelays + obj.blockB.numberOfDelays;
         end
    end
end