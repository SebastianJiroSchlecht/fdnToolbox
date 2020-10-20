classdef zDomainVector < zDomainMatrix
    % IIR/FIR diagonal Matrix in zDomain and its derivative
    %
    % Sebastian J. Schlecht, Sunday, 29 December 2019
    
    
    methods
        function delays = getDelays(obj, numerator)
            numeratorDiag = polydiag( permute (numerator, [1 3 2]) );
            delays = polyDegree(detPolynomial(numeratorDiag,'z^-1'),'z^-1');
        end
        
        function val = at(obj,z)
            val = diag(at(obj.matrix,z));
        end
        
        function val = der(obj,z)
            val = diag(at(obj.matrixDer,z));
        end
    end 
end