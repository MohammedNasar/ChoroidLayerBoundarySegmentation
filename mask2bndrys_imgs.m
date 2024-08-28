
function [BND11, BND22] = mask2bndrys_imgs(orgPath,ilm_rpe_analysis_Path,fname)
% [BND11, BND22, imgs] = mask2bndrys_imgs(orgPath,analPath,fno,fname)
rawLst = dir(strcat(orgPath,'*.jpg'));
maskLst = dir(strcat(ilm_rpe_analysis_Path,'Mask/*.jpg'));
% bndOvPath = strcat(analPath,'ILM_RPE/');
% mkdir(bndOvPath);

img0 = imread(strcat(rawLst(1).folder,'/',rawLst(1).name));
sz = size(img0,1);
sy = size(img0,2);
clear img0;
clear imgs;
for sno = 1:length(maskLst)

    strcat('Processing_Boundary = ',int2str(sno),'---outof---',int2str(length(maskLst)),'--fname---',fname)
    % Processing_Boundary = i
    % clear img0 img;
    % img0 = imread(strcat(rawLst(sno).folder,'/',rawLst(sno).name));
    % if size(img0,3) == 1
    %     img = img3(img0);
    % else
    %     img = img0;
    % end
    % imgs(sno,:,:,:) = img;
    clear rsz_mask;
    rsz_mask = imresize(imbinarize(imread(strcat(maskLst(sno).folder,'\',maskLst(sno).name))),[sz sy]);
%     fgsh(temp)
    clear bnd1 bnd2;
    [bnd1,bnd2] = bndry_detection1(rsz_mask);
    BND1(sno,:) = bnd1;
    BND2(sno,:) = bnd2;
end

BND11 = round(smoothdata(smoothdata(BND1,2,'rloess'),1,'rloess'));
BND22 = round(smoothdata(smoothdata(BND2,2,'rloess'),1,'rloess'));

