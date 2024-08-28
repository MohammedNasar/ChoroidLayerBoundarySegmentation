function maskPath1 = CibCob_Agg_10M(maskPath)

modelLst = dir(strcat(maskPath,'*_IP'));
imgLst = dir(strcat(maskPath,modelLst(1).name,'/*.jpg'));
% orgPath = model_lst(1).folder;
img0 = imread(strcat(maskPath,modelLst(1).name,'\',imgLst(1).name));
sz = size(img0,1);
sy = size(img0,2);
maskPath1 = strcat(maskPath,'Mask_Agg_256x256/');
mkdir(maskPath1);

for i = 1:length(imgLst)
    i
    cib_cob_Aggr = zeros(sz,sy);
%     cib_cob_Aggr = zeros(256,256);
    for j = 1:length(modelLst)
        clear img;
%         strcat(op_fd_path,sprintf('/image%04d',j),'.jpg')
        img = imbinarize(imread(strcat(maskPath,modelLst(j).name,'/',imgLst(i).name)));
        cib_cob_Aggr = or(cib_cob_Aggr,img);
    end
     cibAggr1 = concomp(cib_cob_Aggr);
    imwrite(cibAggr1,strcat(maskPath1,imgLst(i).name));
end
