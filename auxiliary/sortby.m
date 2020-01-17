function [A,ind] = sortby(A,B,varargin)
%sortby - Sort an array by another array
%
% Syntax:  [A,ind] = sortby(A,B,varargin)
%
% Inputs:
%    A - Array to sort
%    B - Array to sort by
%    varargin -  extra sort options (like in sort)
%
% Outputs:
%    A - Sorted Array
%    ind - Sorting Indices
%
% Example: 
%    sortby(1:5,[3 2 1 4 5])
%    sortby(1:5,[3 2 1 4 5],'ascend')
%    sortby(1:5,[3 2 1 4 5],'descend')
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: SORT
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 28 December 2019; Last revision: 28 December 2019

[~,ind]=sort(B,varargin{:}); %Get the order of B
A=A(ind);