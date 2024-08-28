function prnt_cib_cob_overlay_org(imgs,cib,cob,opPath,mlst)

for i = 1:size(imgs,3)
    printing_images = i
%     img0 = imread(strcat(orgPath,mlst(i).name));
    img0 = squeeze(imgs(:,:,i));
    img = img3(img0);
    for j = 1:size(img,2)
        if cib(j,i) < 2
            cib(j,i) = 2;
        end
        if cob(j,i) < cib(j,i)
            cob(j,i) = cib(j,i)+2;
        end
        indi = cib(j,i)-1:cib(j,i)+1;
        indo = cob(j,i)-1:cob(j,i)+1;
        img(indi,j,1) = 255;
        img(indi,j,2) = 255;
        img(indi,j,3) = 0;
        img(indo,j,1) = 255;
        img(indo,j,2) = 255;
        img(indo,j,3) = 0;
    end    
    imwrite(img,strcat(opPath,mlst(i).name));
end

