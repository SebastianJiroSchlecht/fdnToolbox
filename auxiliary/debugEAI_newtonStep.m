function debugEAI_newtonStep(loop)
% debug
%
% see Schlecht, S., Habets, E. (2019). Modal Decomposition of Feedback
% Delay Networks IEEE Transactions on Signal Processing  67(20), 5340-5351.
% https://dx.doi.org/10.1109/tsp.2019.2937286
%
%
%
% Sebastian J. Schlecht, Tuesday, 20. October 2020

z = randn(1) + 1i*randn(1);
z = z / abs(z) * 1.2;
iz = 1/z;

% pR = z^loop.numberOfDelayUnits * det(loop.at(iz))
% % 
% % pR = z.^loop.numberOfDelayUnits * det(loop.at(1/z))
% 
% 
% pRR = det(loop.forwardTF.at(iz)) * det(loop.atRev(z))
% 
% abs(pR)
% abs(pRR)
% 
% reversedNewton = trace( loop.atRev(iz)  \ loop.derRev(iz) ) + trace(  loop.feedbackTF.at(z) \ loop.feedbackTF.der(z) / -iz^2 );
% invNewtonStep = loop.numberOfDelayUnits / z - reversedNewton / z^2

invNewtonStep2 = trace( loop.at(z)  \ loop.der(z)  ) + loop.numberOfMatrixDelays / z

invNewtonStep3 = trace(loop.feedbackTF.at(z)\loop.feedbackTF.der(z)) ...
                 + trace(loop.forwardTF.at(z)\loop.forwardTF.der(z)) ...
                 - trace(loop.atRev(iz)\loop.derRev(iz)) / z^2
ok = 1;