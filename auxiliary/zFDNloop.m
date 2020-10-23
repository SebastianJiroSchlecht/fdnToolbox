classdef zFDNloop < handle
    % FDN Loop P(z) = Delay^-1(z) * Forward^-1(z) - Backward(z)
    % Optionally Backward^-1 can be defined
    %
    % Sebastian J. Schlecht, Sunday, 29 December 2019
    properties
        delayTF
        forwardTF
        feedbackTF
        feedbackInv
        
        numberOfDelayUnits
        numberOfMatrixDelays
    end
    methods
        function obj = zFDNloop(delayTF, forwardTF, feedbackTF, feedbackInv)
            obj.delayTF = delayTF.inverse();
            obj.forwardTF = forwardTF.inverse();
            obj.feedbackTF = feedbackTF;
            
            if nargin == 4 && ~isempty(feedbackInv)
               obj.feedbackInv = feedbackInv; 
            end
            
            obj.numberOfMatrixDelays = obj.feedbackTF.numberOfDelayUnits;
            obj.numberOfDelayUnits = obj.delayTF.numberOfDelayUnits + obj.forwardTF.numberOfDelayUnits + obj.feedbackTF.numberOfDelayUnits;
        end
        
        function val = forwardAt(obj,z)
            val = obj.delayTF.at(z) * obj.forwardTF.at(z);
        end
        
        % The delay matrix is inverted explicitely for numerical conditioning
        function val = forwardAtInv(obj,z)
            val = obj.delayTF.at(1/z) / (obj.forwardTF.at(z));
        end
        
        function val = feedbackAtInv(obj,z)
            if isempty(obj.feedbackInv)
                val = inv(obj.feedbackTF.at(z));
            else
                val = obj.feedbackInv.at(z);
            end
        end
        
        function val = forwardDer(obj,z)
            val = obj.delayTF.der(z) * obj.forwardTF.at(z) + obj.delayTF.at(z) * obj.forwardTF.der(z);
        end
        
        function val = at(obj,z)
            val = obj.forwardAt(z) - at(obj.feedbackTF,z);
        end
        
        function val = der(obj,z)
            val = obj.forwardDer(z) - obj.feedbackTF.der(z);
        end
        
        function val = atRev(obj,z)
            val = obj.forwardAtInv(1/z) - obj.feedbackAtInv(1/z);
        end
        
        
        function val = derRev(obj,z)
            % (K^-1)' = - K^-1 * K' * K^-1
            FB = obj.feedbackAtInv(1/z);
            dFB = obj.feedbackTF.der(1/z);
            idFB = FB * dFB * FB;
            
            % FF = obj.forwardAtInv(1/z);
            % dFF = obj.forwardDer(1/z);
            % FF * dFF * FF
            % Attention: minus sign is -obj.delayTF.delays  
            idFF = obj.forwardTF.at(1/z) \ ( obj.forwardTF.der(1/z) / obj.forwardTF.at(1/z) + diag(-obj.delayTF.delays*z) ) * obj.delayTF.at(z); 
            
            val = (idFF - idFB) / z^2;
                         
        end
        
        function step = inverseNewtonStep(obj,z)
            
            if (abs(z) <= 1)
                step = trace( obj.at(z)  \ obj.der(z)  ) + obj.numberOfMatrixDelays / z;
            else
                % iz = 1/z;
                % step = trace(obj.feedbackTF.at(z)\obj.feedbackTF.der(z)) ...
                %     + trace(obj.forwardAtInv(z)*obj.forwardDer(z)) ...
                %     - trace(obj.atRev(iz)\obj.derRev(iz)) / z^2 ...
                %     + obj.numberOfMatrixDelays / z;
                
                reversedNewton = trace( obj.atRev(1/z)  \ obj.derRev(1/z) ) + trace(  obj.feedbackTF.at(z) \ obj.feedbackTF.der(z) / -(1/z)^2 );
                step = obj.numberOfDelayUnits / z - reversedNewton / z^2;
                
                if isnan(step)
                   error('Invalide step due to bad numerical conditioning.') 
                end
            end
        end
    end
end
