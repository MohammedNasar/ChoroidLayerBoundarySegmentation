
function imgs = imRDImgs(orgPath)

dLst = dir(strcat(orgPath,'*.jpg'));
len = length(dLst);
for i = 1:len  
%% Read Original wide-field images
%     h=waitbar(mn1/(length(fileNames)),sprintf('Processing Step-1/Step-4 at scan number: %d/%d',mn1,length(fileNames)));

    ReadingImg = i
    try
    clear rawImgPath aa11 a1 fn;
    fn = dLst(i).name;
    rawImgPath = strcat(orgPath,fn);%
    aa11 = imread(rawImgPath);
    if size(aa11,3)==3
        a1 = rgb2gray(aa11);
    elseif size(aa11,3)>3
        a1 = rgb2gray(aa11(:,:,1:3));
    else
        a1 = aa11;
    end
%     cropImgs0(:,:,mn1) = a1(:,c2(1)+10:c2(1)+c2(3)-10);
    imgs(:,:,i) = a1;%(c2(2):c2(2)+c2(4),c2(1)+10:c2(1)+c2(3)-10);
%     imwrite(cropImgs(:,:,mn1),strcat(cropImg_folder,'\img',sprintf('%04d',mn1-1),'.jpg'));
    catch ME
        fprintf('Corrupted scan# %d: %s\n',i, ME.message);
        continue;
    end
end

