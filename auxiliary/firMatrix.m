classdef firMatrix < handle


    properties
        filters;
        n
        m
        isDiagonal
    end

    methods
        function obj = firMatrix(B)
            obj.n = size(B,1);
            obj.m = size(B,2);
            obj.isDiagonal = false;
            
            obj.filters = dfilt.('dffir');
            for nn = 1:obj.n
                for mm = 1:obj.m
                    val = B(nn,mm,:);
                    obj.filters(nn,mm) = dfilt.('dffir')(squeeze(val));
                    obj.filters(nn,mm).PersistentMemory = true;
                end
            end
        end


        function out = filter(obj,in)
            % in : size = (time, in)
            out = zeros(size(in,1),obj.n);


            if obj.isDiagonal
                for itOut = 1:obj.n
                    out(:,itOut) = out(:,itOut) + obj.filters(itOut,1).filter(in(:,itOut));
                end
            else
                for itOut = 1:obj.n
                    for itIn = 1:obj.m
                        out(:,itOut) = out(:,itOut) + obj.filters(itOut,itIn).filter(in(:,itIn));
                    end
                end
            end

        end
    end
end