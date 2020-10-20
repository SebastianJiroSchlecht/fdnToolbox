classdef zDelay < zFilter
    
    properties
        delays
    end
    
    methods
        function obj = zDelay(delays)
            
            obj.isDiagonal = true; % TODO: not nessarily
            
            obj.delays = delays(:);
            
            obj.numberOfDelayUnits = sum(obj.delays);
            
        end
        
        function delays = getDelays(obj, numerator)
            % TODO: strange
        end
        
        function val = at(obj,z)
            val = (z.^obj.delays);
        end
        
        function val = der(obj,z) 
            val = (z.^(obj.delays-1) .* obj.delays);
        end
    end
end