classdef filterVector < handle
    % TODO document
    %
    % Monday, 19. October 2020
    % Sebastian J. Schlecht
    properties
        filters = dfilt.df2;
        gains = [];
        numberOfChannels
    end
    
    methods
        function obj = filterVector(m)
            % m is an array of gains or filters of size [1,N]
            obj.numberOfChannels = size(m,2);
            
            if isa(m,'double')
                obj.gains = m;
            else
                for ch = 1:obj.numberOfChannels
                    obj.filters(ch) = copy( m(ch) );
                    obj.filters(ch).PersistentMemory = true;
                end
            end
        end
        
        function out = filter(obj,in)
            
            if( ~isempty(obj.gains) )
                out = in .* obj.gains;
            else
                out = in*0;
                for ch = 1:obj.numberOfChannels
                    out(:,ch) = out(:,ch) + obj.filters(ch).filter(in(:,ch));
                end
            end
        end
        
    end
end