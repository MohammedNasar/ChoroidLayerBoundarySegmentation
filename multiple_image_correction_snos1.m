function [cib_3Dsm, cob_3Dsm, oPath] = multiple_image_correction_snos1(snos,mFd,imgs,CIB00,COB00)
oPath = strcat(mFd,'\Analysis\Corrections\ManCorrection\',date,'\Mul\Segmentations\');
MatF_NewPath = strcat(mFd,'\Analysis\Corrections\ManCorrection\',date,'\Mul\MatFile\');
mkdir(oPath);
mkdir(MatF_NewPath);
sy = size(imgs,2);
sx = size(imgs,3);
CIB0 = nan(sy,sx);
COB0 = nan(sy,sx);
if snos(1) > 1
    CIB0(:,1:snos(1)-1) = CIB00(:,1:snos(1)-1);
    COB0(:,1:snos(1)-1) = COB00(:,1:snos(1)-1);
end
if snos(end) < sx
    CIB0(:,snos(end)+1:sx) = CIB00(:,snos(end)+1:sx);
    COB0(:,snos(end)+1:sx) = COB00(:,snos(end)+1:sx);
end
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

rangc = [];
if ~(snos(1)==1)
    rangc = 1:snos(1)-1;
end
for i = 1:length(snos)
    rangc = [rangc snos(i)];
end
if ~(snos(end)==sx)
    rangc = [rangc snos(end)+1:sx];
end
% cib_3Dsm1 = cib_3Dsm;
% cob_3Dsm1 = cob_3Dsm;

for mn2 = 1:sy
    cib_3Dsm(mn2,:) = interp1(rangc,CIB0(mn2,rangc),1:sx,'linear','extrap');
    cob_3Dsm(mn2,:) = interp1(rangc,COB0(mn2,rangc),1:sx,'linear','extrap');
end

% 
% cib_3Dsm = smoothdata(CIB0,2,'rloess');
% cob_3Dsm = smoothdata(COB0,2,'rloess');
% cib_3Dsm = smoothdata(smoothdata(cib_3Dsm0,1,'rloess'),2,'rloess');
% cob_3Dsm = smoothdata(smoothdata(cob_3Dsm0,1,'rloess'),2,'rloess');

save(strcat(MatF_NewPath,'Data.mat'),'cib_3Dsm','cob_3Dsm');

