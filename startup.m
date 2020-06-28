% startup

clear; clc; close all;

% restoredefaultpath;

addpath(genpath('./'))

%% create dummy file in case matlab tikz is not present
if isempty(which('matlab2tikz_sjs'))
    fid = fopen('./Temporary/matlab2tikz_sjs.m', 'wt');
    fprintf(fid, 'function matlab2tikz_sjs(varargin)');
    fclose(fid);
end

%% List File and Product dependencies
% files = dir('./**/*.m');
% ff = {files.name}'
% [fList,pList] = matlab.codetools.requiredFilesAndProducts(ff)
% pList.Name