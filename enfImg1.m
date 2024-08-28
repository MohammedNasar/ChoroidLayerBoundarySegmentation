function enf_img = enfImg1(cib,imgs)
imgs1=[];
ofset=600;
n=round(min(min(cib)))-1+ofset;
for i=1:size(cib,2)
%      i
%     mimg=crop_scans{i};
% %     mimg=squeeze(cropImgs(:,:,i));
%     for j=1:size(mimg,2)
%         img(:,j,i)=mimg(round(cib(j,i))-n+1:round(cib(j,i)),j);
%     end
    i
%     mimg=crop_scans{i};
%     mimg=squeeze(imgs(:,:,i));

    mimg=squeeze(imgs(:,:,i));
    mimg_temp=zeros(size(mimg,1)+ofset,size(mimg,2));
    mimg_temp(ofset+1:end,:)=mimg;
    for j=1:size(mimg_temp,2)
        try
        if cib(j,i) <=0
            cib(j,i) =1;
        end
        imgs1(:,j,i)=mimg_temp(round(cib(j,i))+1:round(cib(j,i))+ofset,j);
        catch ME
            fprintf('No %d: %s/n',i);
            continue;
        end
    end
end
n
div=1;

enf_img = uint8(squeeze(mean(imgs1(end-round(40/div):end-round(20/div),:,:),1)));