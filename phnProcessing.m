
function vol = phnProcessing(imgs,img_rsz,adp_bsz,phn_bsz,cib,cob,fname)
d1 = round(max(max(cob-cib)));
sz = size(imgs);
for  sno = 1:sz(3)
    % strcat('Reading input B-scans = ',int2str(sno),'----VolNo---',int2str(volno),'-----FName---',fname);
    strcat('Phn_Proc_ImgNo = ',int2str(sno),'-----FName---',fname)
    % processingImgNo = sno
    clear img preprocImg imgPhn;
    img = squeeze(imgs(:,:,sno));
    preprocImg = adapthisteq(medfilt2(ShadowRemoval(imresize(img,img_rsz)),adp_bsz));
    imgPhn = imcomplement(phansalkar(preprocImg,phn_bsz));
    vol(:,:,sno) = getChVesSeg(imgPhn,cib(:,sno),cob(:,sno),d1);
end
    