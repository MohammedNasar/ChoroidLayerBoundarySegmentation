function [cib_3Dsm, cob_3Dsm, oPath] = multiple_image_correction_interp_snos(snos,mFd,imgs)
% mFd = 'E:\Razeen\Data\05Oct2023\Kafley\P737960854_Angio_(12mmx12mm)_6-6-2023_9-16-26_OD_sn0236_cube_z';
% ManCorrection\',date,'\Mul
oPath = strcat(mFd,'\Analysis\Corrections\ManCorrection\',date,'\Mul\Segmentations\');
MatF_NewPath = strcat(mFd,'\Analysis\Corrections\ManCorrection\',date,'\Mul\MatFile\');
mkdir(oPath);
mkdir(MatF_NewPath);
sy = size(imgs,2);
sx = size(imgs,3);
CIB0 = nan(sy,sx);
COB0 = nan(sy,sx);
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
%     y_1 = round(y_1);
%     x_1 = round(x_1);
    [cib, CIB_image] = RefineOneBoundary3(x_1, y_1,img);   
%     fgsh(CIB_image,1)
%     handles.imageHandle =
    close(figure(1));
    figure(1); 
    imshow(CIB_image,'InitialMagnification','fit');
    title(fn);
    [y_2, x_2] = getpts;
    [cob, CIB_COB_image] = RefineOneBoundary3(x_2, y_2,CIB_image);  
%     fgsh(CIB_COB_image,1)
    handles.imageHandle = imshow(CIB_COB_image);
    title(fn);
    filname_boundary = strcat(oPath,fn);
    imwrite(CIB_COB_image,filname_boundary); 
    CIB0(:,sno) = cib;    
    COB0(:,sno) = cob;
end

if snos(2) == 50
    uinp = '2-49,51-99,101-149,151-199,201-249,251-299,301-349,351-399,401-449,451-499';
elseif snos(2) == 25
    uinp = '2-24,26-49,51-74,76-99,101-124,126-149,151-174,176-199,201-224,226-249,251-274,276-299,301-324,326-349,351-374,376-399,401-424,426-449,451-474,476-499';
end
% uinp = '2-99,101-199,201-299,301-399,401-499';
% uinp = '2-49,51-99,101-149,151-199,201-249,251-299,301-349,351-399,401-449,451-499';
% uinp = ['2-24,26-49,51-74,76-99,101-124,126-149,151-174,176-199,' ...
%     '201-224,226-249,251-274,276-299,301-324,326-349,351-374,376-399,401-424,426-449,451-474,476-499'];
[cib_3Dsm,~,~] = chSeg_corr_cib(CIB0,uinp);
[cob_3Dsm,~,~] = chSeg_corr_cob(COB0,uinp);
% cib_3Dsm = smoothdata(CIB0,2,'rloess');
% cob_3Dsm = smoothdata(COB0,2,'rloess');
% cib_3Dsm = smoothdata(smoothdata(cib_3Dsm0,1,'rloess'),2,'rloess');
% cob_3Dsm = smoothdata(smoothdata(cob_3Dsm0,1,'rloess'),2,'rloess');

save(strcat(MatF_NewPath,'Data.mat'),'cib_3Dsm','cob_3Dsm');
