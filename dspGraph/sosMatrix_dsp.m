classdef sosMatrix_dsp < handle
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
        sos
    end

    properties (Access = private)
        % computation acceleration
        flipNumerator
        flipDenominator
    end

    methods
        function obj = sosMatrix_dsp(sos)
            if nargin > 0

                obj.sos = sos;
                % obj.denominator = a;
                % 
                % % computation acceleration
                % obj.flipNumerator = flip(obj.numerator,3); % flip time
                % obj.flipDenominator = flip(obj.denominator,3);
            end
        end

        function val = at(obj,z,var)
            

            switch var
                case 'z^-1'
                    m = 0:-1:-2;
                    zm = z.^m;
                    
                    num = einsum(zm,obj.sos(:,:,:,1:3),'ft,mnlt->mnfl');
                    den = einsum(zm,obj.sos(:,:,:,4:6),'ft,mnlt->mnfl');
                    
                    val = prod(num,4) ./ prod(den,4);    

                    ok = 1;
                    % num = sum(z.^m .* obj.sos(:,:,:,1:3),4); 
                    % den = sum(z.^m .* obj.sos(:,:,:,4:6),4); 
                    % 
                    % val = prod(num,3) ./ prod(den,3);    
                case 'z^1'
                    error('not implemented');
            end
        end

        function der = derive(obj,var)
            error('not implemented');
        end

    end
end