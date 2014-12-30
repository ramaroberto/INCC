function fileReading()

fid = fopen('./data/*.csv');  %open file
data = fread(fid, '*char')'; %read all contents into data as a char array (don't forget the `'` to make it a row rather than a column).
fclose(fid);
entries = regexp(data, ',', 'split');


%dd = dir('./data/*.csv');

%fileNames = {dd.name}; 

%data = cell(numel(fileNames),2);
%data(:,1) = regexprep(fileNames, '.csv','');

%for ii = 1:numel(fileNames)    
%   data{ii,2} = importdata(fileNames{ii});
%end
end