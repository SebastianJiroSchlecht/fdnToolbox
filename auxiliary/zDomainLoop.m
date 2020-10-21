classdef zDomainLoop < handle
% FDN Loop P(z) = Forward(z) - Backward(z)
% Optional argument is invFeedbackTF(z)
%
% Sebastian J. Schlecht, Sunday, 29 December 2019
    properties
        forwardTF
        feedbackTF
        invFeedbackTF
        
        numberOfDelayUnits
        numberOfMatrixDelays
    end
    methods
        function obj = zDomainLoop(forwardTF, feedbackTF, invFeedbackTF)
            obj.forwardTF = forwardTF;
            obj.feedbackTF = feedbackTF;
            
            obj.numberOfMatrixDelays = obj.feedbackTF.numberOfDelayUnits;
            obj.numberOfDelayUnits = obj.forwardTF.numberOfDelayUnits + obj.feedbackTF.numberOfDelayUnits;
            
            if nargin == 3
                obj.invFeedbackTF = invFeedbackTF;
            else
                obj.invFeedbackTF = [];
            end            
        end
        
        function val = at(obj,z)
            val = obj.forwardTF.at(z) - at(obj.feedbackTF,z);
        end
        
        function val = der(obj,z)
            val = obj.forwardTF.der(z) - obj.feedbackTF.der(z);
        end
        
        function val = atRev(obj,z)
%             if isempty(obj.invFeedbackTF)
                val = inv(obj.forwardTF.at(1/z)) - inv(at(obj.feedbackTF,1/z));
%             else
%                 val = inv(obj.forwardTF.at(1/z)) - obj.invFeedbackTF.at(z);
%             end        
        end
        

        
        function val = derRev(obj,z)
%             if isempty(obj.invFeedbackTF)
                % (K^-1)' = - K^-1 * K' * K^-1
                FB = obj.feedbackTF.at(1/z);
                dFB = obj.feedbackTF.der(1/z);
                
                FF = obj.forwardTF.at(1/z);
                dFF = obj.forwardTF.der(1/z);
                
                val = (FF \ dFF / FF - FB \ dFB / FB) / z^2; 
%             else
%                 val = obj.forwardTF.der(z) - obj.invFeedbackTF.der(z);
%             end          
        end
        
        function step = inverseNewtonStep(obj,z)
            iz = 1/z;
            if (abs(z) <= 1)
                step = trace( obj.at(z)  \ obj.der(z)  ) + obj.numberOfMatrixDelays / z;
            else
                step = trace(obj.feedbackTF.at(z)\obj.feedbackTF.der(z)) ...
                    + trace(obj.forwardTF.at(z)\obj.forwardTF.der(z)) ...
                    - trace(obj.atRev(iz)\obj.derRev(iz)) / z^2;
            end
        end
    end
end
