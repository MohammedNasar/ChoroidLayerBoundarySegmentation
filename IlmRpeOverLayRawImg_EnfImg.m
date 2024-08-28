
function [bnd1, bnd2, rLayer, bndOvPath] = IlmRpeOverLayRawImg_EnfImg(orgPath,ilm_rpe_analysis_Path,fname)
[bnd1, bnd2] = mask2bndrys_imgs(orgPath,ilm_rpe_analysis_Path,fname);
% bnd1 = round(bnd1);
% bnd2 = round(bnd2);
ssz = round(max(max(bnd2-bnd1)));
rLayer = zeros([size(bnd2,1),ssz,size(bnd2,2)]);
offset = 2;
bndOvPath = strcat(ilm_rpe_analysis_Path,'ILM_RPE/');
mkdir(bndOvPath);
orgLst = dir(strcat(orgPath,'*.jpg'));
imgs = imRDImgs(orgPath);
for sno = 1:size(bnd1,1)
    strcat('writing_image_no = ',int2str(sno),'---outof---',int2str(size(bnd1,1)),'--fname---',fname)

    % writing_image = i
    clear img;
     img = img3(squeeze(imgs(:,:,sno)));
     for j = 1:size(bnd1,2)
        if bnd1(sno,j) <= 2
            bnd1(sno,j) = 3;
        end
        if ~isempty(bnd1(sno,j)) && ~isempty(bnd2(sno,j)) && bnd2(sno,j) > bnd1(sno,j)
            img(bnd1(sno,j)-offset:bnd1(sno,j)+offset,j,1) = 255;
            img(bnd1(sno,j)-offset:bnd1(sno,j)+offset,j,2) = 255;
            img(bnd1(sno,j)-offset:bnd1(sno,j)+offset,j,3) = 0;

            img(bnd2(sno,j)-offset:bnd2(sno,j)+offset,j,1) = 255;
            img(bnd2(sno,j)-offset:bnd2(sno,j)+offset,j,2) = 255;
            img(bnd2(sno,j)-offset:bnd2(sno,j)+offset,j,3) = 0;
        end
        rLayer(sno,1:bnd2(sno,j)-bnd1(sno,j)+1,j) = img(bnd1(sno,j):bnd2(sno,j),j,1);
    end
    imwrite(img,strcat(bndOvPath,orgLst(sno).name));
end

