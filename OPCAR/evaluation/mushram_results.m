function values=mushram_results(filename)

% MUSHRAM_RESULTS   Imports the results contained in a text file
%
% values=mushram_results(filename) retrieves the results contained in the
% text file filename into a matrix object values, where each line
% corresponds to one experiment and each column to one test file (the
% experiments and the test files being in the same order as in the
% configuration file)

%opening the file
fid=fopen(filename,'r');
if fid~=-1,
    results=fscanf(fid,'%c');
    fclose(fid);
else,
    error('The specified file does not exist or cannot be opened.');
end

%suppressing spurious linefeeds and transforming Windows linefeeds into Unix ones
if length(results)>1,
    results=strrep(results,char(13),char(10));
    c=find(results~=10);
    results=[results(1:c(end)) char(10) char(10)];
    while ~isempty(strfind(results,[char(10) char(10) char(10)])),
        results=strrep(results,[char(10) char(10) char(10)],[char(10) char(10)]);
    end
else,
    error('The specified file is empty.');
end

%parsing and checking the values for all experiments
dblines=strfind(results,[char(10) char(10)]);
nbexpe=length(dblines);
expresults=results(1:dblines(1));
lines=strfind(expresults,char(10));
nbfile=length(lines);
values=zeros(nbexpe,nbfile);
dblines=[-1 dblines];
for e=1:length(dblines)-1,
    expresults=results(dblines(e)+2:dblines(e+1));
    lines=strfind(expresults,char(10));
    if length(lines) == nbfile,
        lines=[0 lines];
        for f=1:length(lines)-1,
            rating=expresults(lines(f)+1:lines(f+1)-1);
            if all((rating >= 48) | (rating <= 57)),
                if eval(rating) <= 100,
                    values(e,f)=eval(rating);
                else,
                    error('The specified file contains a value larger than 100.');
                end
            else,
                error('The specified file contains a non-integer value.');
            end
        end
    else,
        error('The number of values must be the same for all experiments.');
    end
end
