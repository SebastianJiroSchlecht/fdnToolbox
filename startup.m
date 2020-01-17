% startup

clear; clc; close all;

restoredefaultpath;

addpath(genpath('./'))

%% List File and Product dependencies
% files = dir('./**/*.m');
% ff = {files.name}'
% [fList,pList] = matlab.codetools.requiredFilesAndProducts(ff)
% pList.Name