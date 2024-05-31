classdef tfMatrix_dsp < handle
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
    % modified: Thursday, 30. May 2024

    properties
        numerator
        denominator
    end

    properties (Access = private)
        % computation acceleration
        flipNumerator
        flipDenominator
    end

    methods
        function obj = tfMatrix_dsp(b,a)
            if nargin > 0

                obj.numerator = b;
                obj.denominator = a;
                
                % computation acceleration
                obj.flipNumerator = flip(obj.numerator,3); % flip time
                obj.flipDenominator = flip(obj.denominator,3);
            end
        end

        function val = at(obj,z,var)
            switch var
                case 'z^-1'
                    num = matrix_polyval_batch(obj.numerator,z);
                    den = matrix_polyval_batch(obj.denominator,z);
                    val = num./den;
                case 'z^1'
                    num = matrix_polyval_batch(obj.flipNumerator,z);
                    den = matrix_polyval_batch(obj.flipDenominator,z);
                    val = num./den;
            end
        end

        function der = derive(obj,var)

            B = permute( obj.numerator, [3 1 2]); % flip time to the front
            A = permute( obj.denominator, [3 1 2]);

            [num,den] = matrix_polyder(B, A, var);

            num = permute( num, [2 3 1]); % flip time to the back
            den = permute( den, [2 3 1]);

            der = tfMatrix_dsp(num,den);
        end

    end
end