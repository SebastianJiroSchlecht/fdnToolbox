classdef feedbackDelay < handle
    % Array of feedback delay processors
    %
    % Sebastian J. Schlecht, Friday, 17. January 2020
    properties
        delays
        values
        pointers
    end
    methods
        function obj = feedbackDelay(maxBlockSize, delays)
            obj.delays = delays;
            obj.values = zeros( max(delays) + maxBlockSize, length(delays) );
            obj.pointers = ones(1,length(delays));
        end
        
        function setValues(obj, val)
            blockSize = size(val,1);
            obj.values( obj.getIndex(blockSize) ) = val;
        end
        
        function val = getValues(obj,blockSize)
            
            val = obj.values( obj.getIndex(blockSize) );
        end
        
        function next(obj,blockSize)
            obj.pointers = obj.modDelay( obj.pointers + blockSize );
            
        end
        
        function ind = getIndex(obj,blkSz)
            rowInd = obj.pointers + (1:blkSz).';
            rowInd = obj.modDelay(rowInd);
            
            numberOfDelays = length(obj.delays);
            columnInd = ones(blkSz,1) .* (1:numberOfDelays);
            
            ind = sub2ind([size(obj.values,1),numberOfDelays],rowInd,columnInd);
        end
        
        function ind = modDelay(obj,ind)
            ind = ind - (ind - obj.delays > 0) .* obj.delays;
        end
    end
end