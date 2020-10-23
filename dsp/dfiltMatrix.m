classdef dfiltMatrix < handle
    %dfiltMatrix - Wrapper for a matrix of filter objects (FIR, IIR, Scalar)
    % Matrix DSP filters of FIR, IIR, and scalar gains. Each matrix entry is a
    % filter, either dfilt.df2 or dfilt.dffir.
    %
    % Constructor:  dfiltMatrix(zF)
    %
    % Inputs:
    %    zF - zF filter or scalar matrix
    %
    % Example:
    %   d = dfiltMatrix(randn(3))
    %   d = dfiltMatrix(zFIR(randn(3,3,10)))
    %
    %
    % Author: Dr.-Ing. Sebastian Jiro Schlecht,
    % Aalto University, Finland
    % email address: sebastian.schlecht@aalto.fi
    % Website: sebastianjiroschlecht.com
    % 10 July 2020; Last revision: 10 July 2020
    
    properties
        filters;
        n
        m
        isDiagonal
    end
    
    methods
        function obj = dfiltMatrix(zF)
            if ismatrix(zF)
                zF = zScalar(zF);
            end
            
            obj.n = zF.n;
            obj.m = zF.m;
            obj.isDiagonal = zF.isDiagonal;
            
            if isa(zF,'zScalar')
                obj.filters = zF.matrix;
            elseif isa(zF,'zFilter')
                type = zF.dfiltType();
                obj.filters = dfilt.(type);
                obj.filters(obj.n,obj.m) = dfilt.(type);
                
                for nn = 1:obj.n
                    for mm = 1:obj.m
                        val = zF.dfiltParameter(nn,mm);
                        obj.filters(nn,mm) = dfilt.(type)(val{:});
                        obj.filters(nn,mm).PersistentMemory = true;
                    end
                end
                
            else
                error('Provide a zFilter or scalar gains');
            end
        end
        
        
        function out = filter(obj,in)
            out = zeros(size(in,1),obj.n);
            
            if isnumeric(obj.filters)
                if obj.isDiagonal
                    out = in.*obj.filters;
                else
                    out = in*obj.filters.';
                end
            else % is dfilt
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
end