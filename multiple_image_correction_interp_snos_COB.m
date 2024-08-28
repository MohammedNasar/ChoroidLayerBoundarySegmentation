function [cob_3Dsm, oPath] = multiple_image_correction_interp_snos_COB(snos,mFd,imgs)
% mFd = 'E:\Razeen\Data\05Oct2023\Kafley\P737960854_Angio_(12mmx12mm)_6-6-2023_9-16-26_OD_sn0236_cube_z';
% ManCorrection\',date,'\Mul
oPath = strcat(mFd,'\Analysis\Corrections\ManCorrection\',date,'\Mul\Segmentations\');
MatF_NewPath = strcat(mFd,'\Analysis\Corrections\ManCorrection\',date,'\Mul\MatFile\');
mkdir(oPath);
mkdir(MatF_NewPath);
sy = size(imgs,2);
sx = size(imgs,3);
COB0 = nan(sy,sx);
% COB0 = nan(500,500);
for i = 1:length(snos)
    clear sno;
    sno = snos(i);
    fn = strcat('image',sprintf('%04d',sno),'.jpg');
    clear img;
    img = squeeze(imgs(:,:,sno));
    close(figure(1));
    figure(1);
    imshow(img,'InitialMagnification','fit');
    title(fn);
    [y_1, x_1] = getpts;
    [cob, COB_image] = RefineOneBoundary3(x_1, y_1,img);   
%     fgsh(CIB_image,1)
%     handles.imageHandle =
    close(figure(1));
    figure(1); 
    imshow(COB_image,'InitialMagnification','fit');
    title(fn);
%     fgsh(CIB_COB_image,1)
%     handles.imageHandle = imshow(CIB_COB_image);
%     title(fn);
    filname_boundary = strcat(oPath,fn);
    imwrite(COB_image,filname_boundary); 
    COB0(:,sno) = cob;  
end
if snos(2) == 50
    uinp = '2-49,51-99,101-149,151-199,201-249,251-299,301-349,351-399,401-449,451-499';
elseif snos(2) == 25
    uinp = '2-24,26-49,51-74,76-99,101-124,126-149,151-174,176-199,201-224,226-249,251-274,276-299,301-324,326-349,351-374,376-399,401-424,426-449,451-474,476-499';
end

[cob_3Dsm,~,~] = chSeg_corr_cob(COB0,uinp);
% [cob_3Dsm,~,~] = chSeg_corr_cob(COB0,uinp);
% cib_3Dsm = smoothdata(CIB0,2,'rloess');
% cob_3Dsm = smoothdata(COB0,2,'rloess');
% cib_3Dsm = smoothdata(smoothdata(cib_3Dsm0,1,'rloess'),2,'rloess');
% cob_3Dsm = smoothdata(smoothdata(cob_3Dsm0,1,'rloess'),2,'rloess');

save(strcat(MatF_NewPath,'Data.mat'),'cob_3Dsm');
