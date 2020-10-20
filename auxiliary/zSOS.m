classdef zSOS < zFilter
    % chain of sos
    properties
        sos
        dsos
    end
    
    methods
        function obj = zSOS(sos, varargin)
            obj.parseArguments(varargin);
            
            
            % sos is [n,m,nsos,6]
            [n,m,nsos,len] = size(sos);
            assert( ~(obj.isDiagonal && m ~= 1), 'For a diagonal filter matrix, provide a vector of filters.');
            assert( len == 6, 'SOS need to have 6 coefficients');
            
            obj.sos = sos;
            
            obj.numberOfDelayUnits = n * nsos * 2;
            
            
            for nn = 1:n
                for mm = 1:m
                    for ss = 1:nsos 
                        num = squeeze( sos(nn,mm,ss,1:3));
                        den = squeeze( sos(nn,mm,ss,4:6));
                        [b,a] = negpolyder(num , den );
                        obj.dsos(nn,mm,ss,:) = [b,a];
                    end
                end
            end
        end
        
        function delays = getDelays(obj, numerator)
            % TODO: strange
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
    end
end