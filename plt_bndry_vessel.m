
function plt_bndry_vessel(imgs,vol2,cib1,cob1,opPth,fname)

sz = size(cib1);
% cib1 = round(imresize(cib,[sz(2) sz(3)]));
% cob1 = round(imresize(cob,[sz(2) sz(3)]));

for sno = 1:sz(2)

    strcat('PrintingImgNo = ',int2str(sno),'-----FName---',fname)
    clear img img1 img2;
    img = img3(imresize(squeeze(imgs(:,:,sno)),[768 sz(1)]));
    img1 = img;
    img2 = img;
    vol = squeeze(vol2(:,:,sno));
    for cno = 1:sz(1)
        clear ind_i ind_o;
        if cib1(cno,sno) < 3
            cib1(cno,sno) = 3;
        end
        if cob1(cno,sno) < 4 && cob1(cno,sno)>cib1(cno,sno)
            cob1(cno,sno) = 5;
        end
        ind_i = cib1(cno,sno)-2:cib1(cno,sno)+2;
        ind_o = cob1(cno,sno)-2:cob1(cno,sno)+2;
        img1(ind_i,cno,1) = 255;
        img1(ind_i,cno,2) = 255;
        img1(ind_i,cno,3) = 0;
        img1(ind_o,cno,1) = 255;
        img1(ind_o,cno,2) = 255;
        img1(ind_o,cno,3) = 0;
        clear ind_v;
        ind_v = find(vol(:,cno) > 0)';


        img2(ind_i,cno,1) = 255;
        img2(ind_i,cno,2) = 255;
        img2(ind_i,cno,3) = 0;
        img2(ind_o,cno,1) = 255;
        img2(ind_o,cno,2) = 255;
        img2(ind_o,cno,3) = 0;

        img2(cib1(cno,sno)+ind_v,cno,1) = 255;
        img2(cib1(cno,sno)+ind_v,cno,2) = 0;
        img2(cib1(cno,sno)+ind_v,cno,3) = 0;
    end
    % imwrite(squeeze(img(:,:,:,ii)),[fd1,sprintf('image%04d',ii),'.jpg']);
    imwrite([img img1 img2],[opPth,sprintf('image%04d',sno),'.jpg'])
end


