classdef zFilter < handle
    % z-Domain Filter structure abstract class
    %
    % From this multiple classes such as zFIR, zTF, zSOS are derived 
    %
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
            p.addOptional('isDiagonal', obj.defaultShape());
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
        
        function isDiagonal = defaultShape(obj)
            isDiagonal = false;
        end
    end
    
    
    methods(Abstract)
         % inverse filter
         inverse(obj) 
        
         % raw shape-independent values 
         at_(obj,z)
         
         % raw shape-independent values of derivative 
         der_(obj,z)
            
         % corresponding dfilt filter type
         dfiltType(obj)
         
         % corresponding dfilt parameter format
         dfiltParameter(obj,n,m)
        
    end
end