% run all examples

%% generate names
files = dir('*/example_*');
fileNames = {files.name};
fprintf('%s\n',fileNames{:})

%% Run
% fileNames = {fileNames{2}, fileNames{13}}
results = runtests(fileNames)
table(results)
