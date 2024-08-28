function [Boundary, OutImage2]  = RefineOneBoundary3(Xt0, Yt0,image)

Yt = 1:size(image,2);%min(Yt1):max(Yt1);
% Yt1 = 1:1024;%min(Yt1):max(Yt1);
Xt = interp1(Yt0,Xt0,Yt,'linear','extrap');
% Xt1 = interp1(Yt0,Xt0,Yt1,'linear','extrap');
% Y2 = 1:size(image,2);
% X2 = zeros(length(Y2),1,'double');
% X2(1:min(Yt1)) = Xt2(1);
% X2(min(Yt1):max(Yt1)) = Xt2;
% X2(max(Yt1):length(X2)) = Xt2(end);
% Xt=X2;%round(smooth(Y2,X2,.001,'rlowess'));
% Xt=round(smooth(Xt0,.1,'rloess'))';
% Xt(end)=Xt(end-1);
% Yt = 1:size(image,2);
% Ih3=zeros(size(I_crop2),'uint8');
% Ih3 = I_crop2;
% L_hat_WSR2=imresize(L_hat_WSR,size(image));
% Ih3(:,:,1)=L_hat_WSR2;%(:,2:end-2);
% Ih3(:,:,2)=L_hat_WSR2;
% Ih3(:,:,3)=L_hat_WSR2;
if size(image,3) == 1
    Ih2(:,:,1)=image;%(:,2:end-2);
    Ih2(:,:,2)=image;
    Ih2(:,:,3)=image;
else
    Ih2 = image;
end

for i=2:length(Xt)-1
%     OFF = as(i);
    X_coord = round(Xt(i)-2):round(Xt(i)+2);
%     Ih3(X_coord,round(Yt(i)),1)=255;
%     Ih3(X_coord,round(Yt(i)),2)=255;
%     Ih3(X_coord,round(Yt(i)),3)=0;
    Ih2(X_coord,round(Yt(i)),1)=255;
    Ih2(X_coord,round(Yt(i)),2)=255;
    Ih2(X_coord,round(Yt(i)),3)=0;
end
% OutImage1 = Ih3;
OutImage2 = Ih2;
Boundary = round(Xt');
