classdef filterMatrix < handle
%filterMatrix - Wrapper for a matrix of filter objects (FIR, IIR, Scalar)
% Matrix DSP filters of FIR, IIR, and scalar gains. Each matrix entry is a
% filter, either dfilt.df2 or dfilt.dffir.
%
% Constructor:  filterMatrix(m)
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
        filters = dfilt.df2;
        matrix = 0;
        numberOfOutputs
        numberOfInputs
        filterType
    end
    
    methods
        function obj = filterMatrix(m)
            
            if isnumeric(m)
                b = m;
                a = [];
            else
                b = m.matrix.numerator;
                a = m.matrix.denominator;
            end
            
            obj.filterType = obj.whatFilterType(b,a);
            
            obj.numberOfOutputs = size(b,1);
            obj.numberOfInputs = size(b,2);
            
            switch obj.filterType
                case 'FIR'
                    obj.filters(obj.numberOfOutputs,obj.numberOfInputs) = dfilt.dffir;
                    for itOut = 1:obj.numberOfOutputs
                        for itIn = 1:obj.numberOfInputs
                            obj.filters(itOut,itIn) = dfilt.dffir(b(itOut,itIn,:));
                            obj.filters(itOut,itIn).PersistentMemory = true;
                        end
                    end
                case 'IIR'
                    obj.filters(obj.numberOfOutputs,obj.numberOfInputs) = dfilt.df2;
                    for itOut = 1:obj.numberOfOutputs
                        for itIn = 1:obj.numberOfInputs
                            obj.filters(itOut,itIn) = dfilt.df2(b(itOut,itIn,:),a(itOut,itIn,:));
                            obj.filters(itOut,itIn).PersistentMemory = true;
                        end
                    end
                case 'scalar'
                    obj.matrix = m;
                otherwise
                    error('Not Defined');
            end
        end
        
        function out = filter(obj,in)
            switch obj.filterType
                case {'FIR','IIR'}
                    out = in*0;
                    for itOut = 1:obj.numberOfOutputs
                        for itIn = 1:obj.numberOfInputs
                            out(:,itOut) = out(:,itOut) + obj.filters(itOut,itIn).filter(in(:,itIn));
                        end
                    end
                case 'scalar'
                    out = in*obj.matrix.';
            end
        end
        
        
        
        function filterType = whatFilterType(obj,b,a)
            bSize = [size(b,1), size(b,2), size(b,3)];
            aSize = [size(a,1), size(a,2), size(a,3)];
            
            if aSize(1) == 0
                filterType = 'noRecursion';
            else
                filterType = 'IIR';
            end
            
            if strcmp(filterType,'noRecursion')
                if bSize(3) == 1
                    filterType = 'scalar';
                else
                    filterType = 'FIR';
                end
            end
            
        end
    end
end