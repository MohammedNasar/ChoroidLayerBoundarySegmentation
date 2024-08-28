
clearvars;clc;
close all;
lst = dir('D:\Elham_3D_AMD_data\unZip\P*\P*');
issues_id = [];
% tic
for volno = 1:length(lst)

    try
    processing_volume = volno
    clear mainFolder;
    filePath0 = [lst(volno).folder,filesep];
    fileName0 = lst(volno).name;
    % orgPath = [filePath,filesep,fileName(1:end-4),'\Org\'];
    % [fileName0,filePath0,~] = uigetfile('E:\Razeen\Data\*.img');  %%%%%%%%%%%%%  Angio*_cube_*
    % fileNames0 = handles.fileNames0;
    % filePath0 = handles.filePath0;
    fileNames = strrep(fileName0,' ','_');
    filePath = strrep(filePath0,' ','_');
    srcPath = strcat(filePath0,fileName0);
    modPath = strcat(filePath,fileNames);
    if ~strcmp(filePath,filePath0)
        mkdir(filePath);
    end
    if ~strcmp(srcPath,modPath)
        movefile(srcPath,modPath);
    end
    fn = fileNames(1:end-4);
    mainFolder = strcat(filePath,fn);
    clear imgs;
    
    orgPath = strcat(mainFolder,'/Org/');mkdir(orgPath);
    imgs = ImagesExtraction(filePath,fileNames,orgPath);

     catch ME
        fprintf('Failed to process file numner %d: %s\n',volno, ME.message);
        issues_id = [issues_id; volno];
        continue;
    end
end
