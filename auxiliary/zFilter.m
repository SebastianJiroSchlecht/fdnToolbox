classdef zFilter < handle
    % Sebastian J. Schlecht, Tuesday, 20. October 2020
    
    properties
        numberOfDelayUnits = 0;
        isDiagonal = false;
    end
    
    methods
        function val = at(obj,z)
            if obj.isDiagonal
                val = diag(obj.at_(z));
            else
                val = obj.at_(z);
            end
        end
        
        function val = der(obj,z)
            if obj.isDiagonal
                val = diag(obj.der_(z));
            else
                val = obj.der_(z);
            end
        end
        
        function parseArguments(obj, arg)
            p = inputParser;
            p.addOptional('isDiagonal', false);
            parse(p,arg{:});
            obj.isDiagonal = p.Results.isDiagonal;
         end
                
    end
    
    
    methods(Abstract)
        
         getDelays(obj, numerator)
            
         
        
         at_(obj,z)
            
        
        
         der_(obj,z)
            
        
        
    end
end