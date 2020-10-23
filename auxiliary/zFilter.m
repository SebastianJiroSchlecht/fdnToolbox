classdef zFilter < handle
    % Sebastian J. Schlecht, Tuesday, 20. October 2020
    
    properties
        numberOfDelayUnits = 0;
        isDiagonal = false;
        n
        m
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
                
        function checkShape(obj,m)
           assert( ~(obj.isDiagonal && m ~= 1), 'For a diagonal filter matrix, provide a vector of filters.'); 
        end
        
        function [n,m] = size(obj)
            n = obj.n;
            m = obj.m;
            
            if isempty(n) || isempty(m)
               error('Size is not defined'); 
            end
        end
    end
    
    
    methods(Abstract)
         % TODO add description
         inverse(obj) 
        
         at_(obj,z)
          
        
         der_(obj,z)
            
         dfiltType(obj)
         
         dfiltParameter(obj,n,m)
        
    end
end