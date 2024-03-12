% Sebastian J. Schlecht, Wednesday, 01 November 2023

% zFilter might be a good basis
% - at(z) and der(z) is important
% - inv(z) might not be a thing
% - time-domain processing should be part of the class
% - diag seems clumsy, but ok
% 
% zSequential is important
% - list of zFilter
% - needs at(), which is just a multiplication; but der() needs a sum of n
% elements. It might not be the cheapest
% - time-domain is just sequential
% 
% Need to check the zLoop again
% - time-domain might be tricky
% - can this be done with a normal delay line (without shortening?)
% - 


% - 'z^1' can be completely removed

% function y = feedback_loop(u)
%     y = zeros(size(u));
%     for k = 2:length(u) % Start from the second element since y(1) = 0 (or some initial condition)
%         feedback_signal = H(y(k-1));
%         y(k) = G(u(k) - feedback_signal);
%     end
% end