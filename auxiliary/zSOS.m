classdef zSOS < zFilter
    % chain of sos
    properties
        sos
        dsos
    end
    
    methods
        function obj = zSOS(sos, varargin)
            % sos is [n,m,nsos,6]
            [obj.n,obj.m,nsos,len] = size(sos);
            obj.parseArguments(varargin);
            obj.checkShape(obj.m);
            assert( len == 6, 'SOS need to have 6 coefficients');
            
            obj.sos = sos;
            obj.numberOfDelayUnits = obj.n * nsos * 2;
            
            for nn = 1:obj.n
                for mm = 1:obj.m
                    for ss = 1:nsos 
                        num = squeeze( sos(nn,mm,ss,1:3));
                        den = squeeze( sos(nn,mm,ss,4:6));
                        [b,a] = negpolyder(num , den, 'dontTruncate', true);
                        obj.dsos(nn,mm,ss,:) = [b,a];
                    end
                end
            end
        end
        
        
        function val = at_(obj,z)
            m(1,1,1,:) = 0:-1:-2;
            num = sum(z.^m .* obj.sos(:,:,:,1:3),4); 
            den = sum(z.^m .* obj.sos(:,:,:,4:6),4); 
            
            val = prod(num,3) ./ prod(den,3);            
        end
        
        function val = der_(obj,z)
            % value of sos
            m(1,1,1,:) = 0:-1:-2;
            num = sum(z.^m .* obj.sos(:,:,:,1:3),4); 
            den = sum(z.^m .* obj.sos(:,:,:,4:6),4); 
            h = num./den;
            
            % derivative of sos
            dm(1,1,1,:) = 0:-1:-4;
            dnum = sum(z.^dm .* obj.dsos(:,:,:,1:5),4); 
            dden = sum(z.^dm .* obj.dsos(:,:,:,6:10),4); 
            dh = dnum./dden;
            
            % (f g h)' = (f g h) * ( f'/f + g'/g + h'/h );
            fgh = prod(h,3);
            ffgghh = sum( dh ./ h, 3);
            
            val = fgh .* ffgghh; 
            
        end
        
        function tf = inverse(obj)
            % Switch the denominator and numerator
            isos = obj.sos;
            isos(:,:,:,1:3) = obj.sos(:,:,:,4:6);
            isos(:,:,:,4:6) = obj.sos(:,:,:,1:3);
            
            tf = zSOS(isos, 'isDiagonal', obj.isDiagonal);
        end
        
        function type = dfiltType(obj)
            type = 'df2sos';
        end
        
        function [sos] = dfiltParameter(obj,n,m)
            sos = {permute(obj.sos(n,m,:,:), [3 4 1 2])};
        end
    end
end