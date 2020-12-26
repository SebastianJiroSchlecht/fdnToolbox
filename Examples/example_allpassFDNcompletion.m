% Sebastian J. Schlecht, Tuesday, 9. June 2020
%
% TODO: add description; change sys to V and sim to X

clear; clc; close all;

rng(1);

switch 5
    case 1 % complete orthogonal
        N = 5;
        k = 2;
        X = randomOrthogonal(N);
        A = X(1:end-k,1:end-k);
        
        [b,c,d,XX] = completeOrthogonal(A, k, 'verbose', true);
     
    case 2 % complete diagonally similar to orthogonal
        N = 4;
        k = 1;
        P1 = blkdiag( diag(rand(N-1,1)), 1);
        X = randomOrthogonal(N);
        PXP = P1 \ X * P1;
        PAP = PXP(1:end-k,1:end-k);
        
        [b,c,d,P,X] = completeAllpassFDN(PAP, 'verbose', true);
        
    case 3 % complete series allpass
        N = 4;
        g = rescale(rand(N,1),0.5,0.99);

        [A, b, c, d] = seriesAllpass(g);
        
        [b,c,d,P,X] = completeAllpassFDN(A, 'verbose', true);
        
    case 4 % nested allpass
        N = 3;
        g = rescale(rand(N,1),0.5,0.99);
        [A, b, c, d] = nestedAllpass(g);
        
        [isA, P] = isUniallpass(A, b, c, d)
        
        P - A*P*A' - b*b'
        
        [b,c,d,P,X] = completeAllpassFDN(A, 'verbose', true);
        
    case 5
        delays = [32 19 13];
        g = 0.99;
        G = diag( g.^delays )
        P = -diag([0.4, 0.6, .85])
        [A, b, c, d] = homogeneousAllpassFDN(G, P, 'verbose', true);  
        [isA, P] = isUniallpass(A, b, c, d)
        
        [b,c,d,P,X] = completeAllpassFDN(A, 'verbose', true);
end

%% verify orthogonal
X*X'

