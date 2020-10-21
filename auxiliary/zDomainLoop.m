classdef zDomainLoop < handle
    % FDN Loop P(z) = Delay(z) * Forward(z) - Backward(z)
    %
    %
    % Sebastian J. Schlecht, Sunday, 29 December 2019
    properties
        delayTF
        forwardTF
        feedbackTF
        
        numberOfDelayUnits
        numberOfMatrixDelays
    end
    methods
        function obj = zDomainLoop(delayTF, forwardTF, feedbackTF)
            obj.delayTF = delayTF;
            obj.forwardTF = forwardTF;
            obj.feedbackTF = feedbackTF;
            
            obj.numberOfMatrixDelays = obj.feedbackTF.numberOfDelayUnits;
            obj.numberOfDelayUnits = obj.delayTF.numberOfDelayUnits + obj.forwardTF.numberOfDelayUnits + obj.feedbackTF.numberOfDelayUnits;
        end
        
        function val = forwardAt(obj,z)
            val = obj.delayTF.at(z) * obj.forwardTF.at(z);
        end
        
        % The delay is inverted explicitely for numerical conditioning
        function val = forwardAtInv(obj,z)
            val = obj.delayTF.at(1/z) / (obj.forwardTF.at(z));
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
            val = obj.forwardAtInv(1/z) - inv(at(obj.feedbackTF,1/z));
        end
        
        
        function val = derRev(obj,z)
            % (K^-1)' = - K^-1 * K' * K^-1
            FB = obj.feedbackTF.at(1/z);
            dFB = obj.feedbackTF.der(1/z);
            
            FF = obj.forwardAtInv(1/z);
            dFF = obj.forwardDer(1/z);
            
            val = (FF * dFF * FF - FB \ dFB / FB) / z^2;
        end
        
        function step = inverseNewtonStep(obj,z)
            iz = 1/z;
            if (abs(z) <= 1)
                step = trace( obj.at(z)  \ obj.der(z)  ) + obj.numberOfMatrixDelays / z;
            else
                step = trace(obj.feedbackTF.at(z)\obj.feedbackTF.der(z)) ...
                    + trace(obj.forwardAtInv(z)*obj.forwardDer(z)) ...
                    - trace(obj.atRev(iz)\obj.derRev(iz)) / z^2 ...
                    + obj.numberOfMatrixDelays / z;
            end
        end
    end
end
