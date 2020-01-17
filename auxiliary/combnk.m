function c = combnk(v,k)
%COMBNK All combinations of the N elements in V taken K at a time.
%   C = COMBNK(V,K) produces a matrix, with K columns. Each row of C has
%   K of the elements in the vector V. C has N!/K!(N-K)! rows.  K must be
%   a nonnegative integer.
%   Copyright 1993-2004 The MathWorks, Inc. 
%
% Sebastian J. Schlecht, Saturday, 28 December 2019
% Edit: removed convert to char

[m, n] = size(v);

if min(m,n) ~= 1
   error(message('stats:combnk:VectorRequired'));
end

if n == 1
   n = m;
   flag = 1;
else
   flag = 0;
end

if n == k
   c = v(:).';
elseif n == k + 1
   tmp = v(:).';
   c   = tmp(ones(n,1),:);
   c(1:n+1:n*n) = [];
   c = reshape(c,n,n-1);
elseif k == 1
   c = v(:);
elseif n < 17 && (k > 3 || n-k < 4)
   rows = 2.^(n);
   ncycles = rows;

   for count = 1:n
      settings = (0:1);
      ncycles = ncycles/2;
      nreps = rows./(2*ncycles);
      settings = settings(ones(1,nreps),:);
      settings = settings(:);
      settings = settings(:,ones(1,ncycles));
      x(:,n-count+1) = settings(:);
   end

   idx = x(sum(x,2) == k,:);
   nrows = size(idx,1);
   [rows,~] = find(idx');
   c = reshape(v(rows),k,nrows).';
else 
   P = zeros(1,0); % want 1 row even for k=0
   if flag == 1,
      v = v.';
   end
   if k < n && k > 1
      for idx = 1:n-k+1
         Q = combnk(v(idx+1:n),k-1);
         P = [P; [v(ones(size(Q,1),1),idx) Q]];
      end
   end
   c = P;
end
