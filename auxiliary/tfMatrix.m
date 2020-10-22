classdef tfMatrix
    % Implementation of transfer function matrix (in z-Domain)
    %
    % var = 'z^1' polynomial variable
    % higher -> lower power
    % ..., z^3, z^2, z^1, 1
    %
    % var = 'z^-1' polynomial variable
    % lower -> higher power
    % 1, z^-1, z^-2, z^-3, ...
    %
    % Sebastian J. Schlecht, Wednesday, 21 August 2019
    
    properties
        numerator
        denominator
        var
    end
    
    properties (Access = private)
        % computation acceleration
        flipNumerator
        flipDenominator
    end
    
    methods
        function obj = tfMatrix(c,d,var)
            if nargin > 0
                if isa(c,'tfMatrix') % copy tfMatrix
                    obj.numerator = c.numerator;
                    obj.denominator = c.denominator;
                    obj.var = c.var;
                else % construct tfMatrix
                    obj.numerator = c;
                    if nargin == 3
                        obj.denominator = d;
                        obj.var = var;
                    else
                        obj.denominator = 1 + 0*c(:,:,1);
                        obj.var = 'z^-1';
                    end
                    
                end
                
                % computation acceleration
                obj.flipNumerator = flip(obj.numerator,3);
                obj.flipDenominator = flip(obj.denominator,3);
            end
        end
        
        function der = derive(obj)
            
            B = permute( obj.numerator, [3 1 2]);
            A = permute( obj.denominator, [3 1 2]);
            
            switch obj.var
                case 'z^1'
                    
                    [num,den] = matrix_polyder(B, A);
                    
                    num = permute( num, [2 3 1]);
                    den = permute( den, [2 3 1]);
                    
                    der = tfMatrix(num,den,obj.var);
                case 'z^-1'
                    
                    [num,den] = matrix_polyder(B, A, obj.var);
                    
                    num = permute( num, [2 3 1]);
                    den = permute( den, [2 3 1]);
                    
                    der = tfMatrix(num,den,obj.var);
            end
        end
        
        function val = at(obj,z)
            switch obj.var
                case 'z^1'
                    num = matrix_polyval(obj.numerator,z);
                    den = matrix_polyval(obj.denominator,z);
                    val = num./den;
                case 'z^-1'
                    iz = 1/z;
                    num = matrix_polyval(obj.flipNumerator,iz);
                    den = matrix_polyval(obj.flipDenominator,iz);
                    val = num./den;
            end
        end
        
        function r = mtimes(obj1,obj2)
            % MTIMES   Implement obj1 * obj2 for tfMatrix.
            obj1 = tfMatrix(obj1);
            obj2 = tfMatrix(obj2);
            num = matrixConvolution(obj1.numerator,obj2.numerator);
            den = matrixConvolution(obj1.denominator,obj2.denominator);
            r = tfMatrix(num,den);
        end
        
        function r = poles(obj)
            R = [];
            [n,m,len] = size(obj.denominator);
            for nn = 1:n
                for mm = 1:m
                    R = [R roots(obj.denominator(nn,mm,:))];
                end
            end
            r = unique(R);
        end
    end
end