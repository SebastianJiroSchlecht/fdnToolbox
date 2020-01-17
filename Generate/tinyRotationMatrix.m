function rotationMatrix = tinyRotationMatrix(N,delta)
%Sebastian J. Schlecht, Tuesday, 17 September 2019
% TODO: check for time-varying FDN
% TODO: quantify delta ( = angle of )

x = randn(N);
skewSymmetric = x - x';



[v,e] = eig(skewSymmetric);
E = diag(e);
nE = E ./ abs(E);
% TODO for odd N
% spreadAmount = 0.1;
% spread = rand(N/2,1)*spreadAmount + (1 - spreadAmount/2);
% spread = [spread, spread]';
% spread = spread(:);

IDX = nearestneighbour(v,conj(v));


frequencySpread = 2*(rand(N,1)-0.5) * 0.1 + 1;
frequencySpread = (frequencySpread(IDX) + frequencySpread) / 2;


nE = E ./ abs(E) .* frequencySpread * delta;


skewSymmetric = real(v* diag(nE)*v');
skewSymmetric = (skewSymmetric - skewSymmetric') / 2;


rotationMatrix = (expm(skewSymmetric));

