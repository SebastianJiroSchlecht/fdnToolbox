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
            if isempty(obj.invFeedbackTF)
                val = obj.forwardTF.at(z) - inv(at(obj.feedbackTF,1/z));
            else
                val = obj.forwardTF.at(z) - obj.invFeedbackTF.at(z);
            end        
        end
        
        function val = derRev(obj,z)
            if isempty(obj.invFeedbackTF)
                val = obj.forwardTF.der(z) - obj.feedbackTF.at(1/z) \ obj.feedbackTF.der(1/z) / obj.feedbackTF.at(1/z) / z^2; % (K^-1)' = - K^-1 * K' * K^-1
            else
                val = obj.forwardTF.der(z) - obj.invFeedbackTF.der(z);
            end          
        end
    end
end
