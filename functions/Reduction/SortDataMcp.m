function [] = SortDataMcp(maindir,nfiles,PathTpxCorr)
%SORTDATAMCP Summary of this function goes here
%   Detailed explanation goes here
d = dir(maindir);
reps = (length(d)-2)/files;
if(floor(reps)~=ceil(reps))
    disp('Non-integer number of repetitions. Stopped to avoid bad sorting')
    return
end

for i=1:reps
    disp(['Moving Dataset: ' num2str(i) '/' num2str(reps)])
    subsubf = [id '/' num2str(i)];
    mkdir(subsubf)

    for j=1:nfiles
        movefile([d(nfiles*(i-1)+1 + (j-1) + 2).folder filesep d(nfiles*(i-1)+1 + (j-1) + 2).name],subsubf);
    end    
end

%making batch file
fid = fopen('CorrectionBatch.bat','w');
for i=1:reps
    fdir = dir(fullfile([id '/' num2str(i)],'*.fits'));
    string = [PathTpxCorr fdir(i).folder fdir(1).name];
    fprintf(fid,string);
end
fclose(fid);

end

