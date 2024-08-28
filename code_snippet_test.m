



x_fov = 250;
y_fov = 250;
% macularTy = macularTy;   
cib = round(cib_3Dsm);
cob = round(cob_3Dsm);
% fn = 'P841585837_Angio_(12mmx12mm)_6-2-2023_8-49-56_OD_sn0212_cube_z';
OpticDiscSide = OD_Ty_Fname(fn);
% mainFolder = 'E:\Razeen\Data\zzzBkp\Mcgorry\P841585837_Angio_(12mmx12mm)_6-2-2023_8-49-56_OD_sn0212_cube_z';
OutputFP = strcat(mainFolder,'\CVIAnalysis_',date);
mkdir(OutputFP);
% OutputFP_Nm = strcat(OutputFP,'\',fn,"_")
% imshow(enfImg);
% [x_fov, y_fov] = getpts;
% load
% if strcmp(macularTy,'6x6')
%     x_fovea = x_fov;
%     y_fovea = y_fov;
%     getAllStats_6x6(x_fovea, y_fovea, cib_3Dsm, cob_3Dsm,OutputFP_Nm, OpticDiscSide)
% % % % % % elseif strcmp(macularTy,'12x12')
% % % % % %     x_fovea = round(x_fov*(1024/500));
% % % % % %     y_fovea = round(y_fov*(1024/500));
% % % % % % %     getAllStats_12x12(x_fovea, y_fovea, cib_3Dsm, cob_3Dsm,OutputFP_Nm, OpticDiscSide);
% % % % % % end
macularTy = '12x12';
if strcmp(macularTy,'6x6')
    x_fovea = x_fov;
    y_fovea = y_fov;
%     getAllStats_6x6(x_fovea, y_fovea, cib_3Dsm, cob_3Dsm,OutputFP_Nm, OpticDiscSide)
elseif strcmp(macularTy,'12x12')
    x_fovea = round(x_fov*(1024/500));
    y_fovea = round(y_fov*(1024/500));
%     getAllStats_12x12(x_fovea, y_fovea, cib_3Dsm, cob_3Dsm,OutputFP_Nm, OpticDiscSide);
end



imgs = imRDImgs(strcat(mainFolder,'\Org\'));

cviMap0 = zeros(fliplr(size(cib)));
for BSNo = 1:1:size(cib,2)
    BSNo = BSNo
    clear img;
    img = squeeze(imgs(:,:,BSNo));
    maskImg = zeros(size(img));
    for  BSColIndx = 1:size(maskImg,2)
        if cib(BSColIndx,BSNo) <= 0 || isnan(cib(BSColIndx,BSNo))
            if BSColIndx > 1
                cib(BSColIndx,BSNo) = cib(BSColIndx-1,BSNo);
            else
                cib(BSColIndx,BSNo) = 3;
            end
        end
        if cob(BSColIndx,BSNo) <= 0 || isnan(cob(BSColIndx,BSNo))
            if BSColIndx > 1
                cob(BSColIndx,BSNo) = cob(BSColIndx-1,BSNo);
            else
                cob(BSColIndx,BSNo) = 3;
            end
        end
        indxi = cib(BSColIndx,BSNo);
        indxo = cob(BSColIndx,BSNo);
        maskImg(indxi:indxo,BSColIndx) = 1;
    end
    % fgsh([img3(a3) a33],1)
    clear indxi indxo;
    preproc_img = adapthisteq(medfilt2(ShadowRemoval(img),[2 2]));
    I_Phn1 = (phansalkar(preproc_img,[100 100]));
    I_Phn2 = (phansalkar(preproc_img,[20 20]));
    idx2 = I_Phn2==0;
    I_Phn1(idx2)=0;
    I_Phn3 = imcomplement(I_Phn1);
    I_Phn = I_Phn3.*maskImg;
    % idx3 = find(I_Phn==1);
    % 
    % vol = 0;
    % ves_vol = 0;
    for  BSColIndx = 1:size(I_Phn,2)
        clear indx;
        indx = I_Phn(:,BSColIndx) > 0;
        cviMap0(BSNo,BSColIndx) = sum(indx)/cob(BSColIndx,BSNo);
        % vol = vol+cob(i,mn1);
        % ves_vol = ves_vol+sum(indx);
    end
    % % % % % vol1(mn1) = vol;
    % % % % % ves_vol1(mn1) = ves_vol;
    % % % % % clear vol ves_vol;
end
cviMap = imresize(cviMap0,[1024 1024]);
clear cviMap_Full cviMap_Stats_cib_Full;
[cviMap_Full, cviMap_Stats_cib_Full] =  get_quad_Circle_stats_CVI(cviMap,x_fovea, y_fovea,OpticDiscSide,1024,1024);

clear ThMap_Full ThMap_Stats_cib_Full;
    
[ThMap_Full, ThMap_Stats_cib_Full] =  get_quad_Circle_stats_Thickness(imresize(cob,[1024 1024]),cviMap,x_fovea, y_fovea,OD_Type,1024,1024);


XL = [cviMap_Stats_cib_Full ThMap_Stats_cib_Full(:,2:end)];


 opXLFP = strcat(OutputFP,'\Data\XLSheets\');
if ~exist(opXLFP,'dir')
    mkdir(opXLFP);
end
writecell(XL,strcat(opXLFP,fn,'.xlsx'));
opMatFP = strcat(OutputFP,'\Data\MatFiles\');
if ~exist(opMatFP,'dir')
    mkdir(opMatFP);
end
opCVI_Maps_FP1 = strcat(OutputFP,'\Data\CviMaps_GRY\');
if ~exist(opCVI_Maps_FP1,'dir')
    mkdir(opCVI_Maps_FP1);
end
opCVI_Maps_FP2 = strcat(OutputFP,'\Data\CviMaps_RGB\');
if ~exist(opCVI_Maps_FP2,'dir')
    mkdir(opCVI_Maps_FP2);
end
opThMaps_FP = strcat(OutputFP,'\Data\ThMaps\');
if ~exist(opThMaps_FP,'dir')
    mkdir(opThMaps_FP);
end

imwrite(cviMap,strcat(opCVI_Maps_FP1,fn,'_CviGryMap.jpg'));
imwrite(cviMap_Full,strcat(opCVI_Maps_FP2,fn,'_CviRgbMap.jpg'));
imwrite(ThMap_Full,strcat(opThMaps_FP,fn,'_ThMap.jpg'));
% figure;imshow(ThMap_Full);title(fn,'Interpreter','none','FontSize',14);
save(strcat(opMatFP,fn,'.mat'));
