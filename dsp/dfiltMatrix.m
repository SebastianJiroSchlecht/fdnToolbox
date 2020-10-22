classdef dfiltMatrix < handle
    %dfiltMatrix - Wrapper for a matrix of filter objects (FIR, IIR, Scalar)
    % Matrix DSP filters of FIR, IIR, and scalar gains. Each matrix entry is a
    % filter, either dfilt.df2 or dfilt.dffir.
    %
    % Constructor:  dfiltMatrix(m) % TODO check
    %
    % Inputs:
    %    m - Filter matrix. Data format is decided by whatFilterType(obj,b,a)
    %
    %
    % Example:
    %   TODO
    %
    % Other m-files required: none
    % Subfunctions: none
    % MAT-files required: none
    %
    % Author: Dr.-Ing. Sebastian Jiro Schlecht,
    % Aalto University, Finland
    % email address: sebastian.schlecht@aalto.fi
    % Website: sebastianjiroschlecht.com
    % 10 July 2020; Last revision: 10 July 2020
    
    %
    %
    % Sebastian J. Schlecht, Sunday, 29 December 2019
    properties
        filters;
        n
        m
        isDiagonal
    end
    
    methods
        function obj = dfiltMatrix(n,m,isDiagonal)
            obj.n = n;
            obj.m = m;
            obj.isDiagonal = isDiagonal;
            
            %filters(n,m) = dfilt.df2;
        end
        
        function out = filter(obj,in)
            out = in*0;
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