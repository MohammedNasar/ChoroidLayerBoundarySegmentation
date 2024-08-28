function [RGB, stats2] =  get_quad_Circle_stats_CVI(map,y_fov, x_fov,OpticDiscSide,lx,ly)


% y_fov = y_fovea;
% x_fov = x_fovea;

ref_OpticDiscSide = 'Left';

% if size(map,1) == 500
%     xx = 750
%     yy = 750
% elseif size(map,1) == 1024
    xx = 1500
    yy = 1500
% end


I_quad_temp = uint8(zeros(xx,yy));
I_quad = insertShape(I_quad_temp,'Line',[1 1 xx yy; xx 1 1 yy],'LineWidth',7,'Color','white');
I_quad2=I_quad(:,:,1)==255;
% [xx, yy] = size(I_quad2);
I_quad3=zeros(xx,yy,3);
I_quad4=insertShape(I_quad3,'FilledCircle',[xx/2 yy/2 1024/12],'Color',[1 1 1],'Opacity',1);
I_quad5=I_quad4(:,:,1)>0;
I_quad6=I_quad2;
idx=I_quad5==1;
I_quad6(idx)=0;
I_quad7=zeros(xx,yy,3);
I_quad7=insertShape(I_quad7,'Circle',[xx/2 yy/2 1024/12+1],'Color',[1 1 1],'LineWidth',5);
idx2=I_quad7(:,:,1)>0;
I_quad6(idx2)=255;

% mask_temp = I_quad6(round((sx/2)-(lx/2)):round((sx/2)+(lx/2)-1),round((sy/2)-(ly/2)):round((sy/2)+(ly/2)-1));
% r1 = round(y_fov-(lx/2));
% r2 = round(y_fov+(lx/2)-1);
% c1 = round(x_fov-(ly/2));
% c2 = round(x_fov+(ly/2)-1);
% % 
% if r1 > 0 && r2 < xx && c1 > 0 && c2 < yy
%     mask_temp = I_quad6(round(y_fov-(lx/2)):round(y_fov+(lx/2)-1),round(x_fov-(ly/2)):round(x_fov+(ly/2)-1));
% elseif r1 <= 0 && r2 < xx && c1 > 0 && c2 < yy
%     mask_temp = I_quad6(1:lx,round(x_fov-(ly/2)):round(x_fov+(ly/2)-1));
% elseif r1 > 0 && r2 > xx && c1 > 0 && c2 < yy
%     mask_temp = I_quad6(xx-lx+1:xx,round(x_fov-(ly/2)):round(x_fov+(ly/2)-1));
% elseif r1 > 0 && r2 < xx && c1 < 0 && c2 < yy
%     mask_temp = I_quad6(round(y_fov-(lx/2)):round(y_fov+(lx/2)-1),1:ly);
% elseif r1 <= 0 && r2 < xx && c1 > 0 && c2 > yy
%     mask_temp = I_quad6(round(y_fov-(lx/2)):round(y_fov+(lx/2)-1),yy-ly+1:yy);
% end

% mask_temp = I_quad6(round((xx/2)-x_fov-lx/2+1):round((xx/2)-x_fov+lx/2),round((yy/2)-y_fov):round((yy/2)+ly-y_fov)-1);
mask_temp = I_quad6(round((xx/2)-x_fov+1):round((xx/2)+lx-x_fov),round((yy/2)-y_fov+1):round((yy/2)+ly-y_fov));
% mask_temp = I_quad6(round((xx/2)-(lx/2)):round((xx/2)+(lx/2)-1),round((yy/2)-(ly/2)):round((yy/2)+(ly/2)-1));
I_mask_squares = zeros(size(mask_temp));
% I_mask_squares(lx/2-12:lx/2+13,1:25) = 1;
% I_mask_squares(1:25,ly/2-12:ly/2+13) = 1;
% I_mask_squares(end-25:end,ly/2-12:ly/2+13) = 1;
% I_mask_squares(lx/2-12:lx/2+13,end-25:end) = 1;
I_mask_squares(lx/2-25:lx/2+25,1:50) = 1;
I_mask_squares(1:50,ly/2-25:ly/2+25) = 1;
I_mask_squares(end-50:end,ly/2-25:ly/2+25) = 1;
I_mask_squares(lx/2-25:lx/2+25,end-50:end) = 1;

I1 = mask_temp==1;
I6= imcomplement(I1);
cc2 = bwconncomp(I6);
numPixels2 = cellfun(@numel,cc2.PixelIdxList);
bb2 = (zeros(size(I1)));
num3=numPixels2>1000;
AZ3=find(num3==1);
for idxx3=1:length(AZ3)
    idx3=AZ3(idxx3);
    bb2(cc2.PixelIdxList{idx3}) = 1;
end
lb = bwlabel(bb2);
num_id = unique(lb(:));

% sx = size(map,1)
% sy = size(map,2)
% lx
% ly
% % % % if x_fovea-(lx/2) > 0 && y_fovea-(ly/2) > 0 &&  x_fovea+(lx/2)-1 < sx &&  y_fovea+(ly/2)-1 < sy
% % % %     I1_gray = map(x_fovea-(lx/2):x_fovea+(lx/2)-1,y_fovea-(ly/2):y_fovea+(ly/2)-1);%*3000/1536;
% % % % % elseif round((sx/2)-x_fovea) > 0 && round((sy/2)-y_fovea) < 0
% % % % %     if 
% % % % %     I1_gray = map(round((sx/2)-x_fovea):round((sx/2)+lx-x_fovea-1),1:ly);%*3000/1536;
% % % % %     elseif round((sx/2)-x_fovea) < 0 && round((sy/2)-y_fovea) > 0
% % % % %     I1_gray = map(1:lx,round((sy/2)-y_fovea):round((sy/2)+ly-y_fovea)-1);%*3000/1536;
% % % % end
I1_gray = map(512-lx/2+1:512+lx/2,512-ly/2+1:512+ly/2);


    % I1_gray = map(512-lx/2+1:512+lx/2,512-ly/2+1:512+ly/2);
% if r1 > 0 && r2 < xx && c1 > 0 && c2 < yy
%     I1_gray = map(round(y_fov-(lx/2)):round(y_fov+(lx/2)-1),round(x_fov-(ly/2)):round(x_fov+(ly/2)-1));
% elseif r1 <= 0 && r2 < xx && c1 > 0 && c2 < yy
%     I1_gray = map(1:lx,round(x_fov-(ly/2)):round(x_fov+(ly/2)-1));
% elseif r1 > 0 && r2 > xx && c1 > 0 && c2 < yy
%     I1_gray = map(xx-lx+1:xx,round(x_fov-(ly/2)):round(x_fov+(ly/2)-1));
% elseif r1 > 0 && r2 < xx && c1 < 0 && c2 < yy
%     I1_gray = map(round(y_fov-(lx/2)):round(y_fov+(lx/2)-1),1:ly);
% elseif r1 <= 0 && r2 < xx && c1 > 0 && c2 > yy
%     I1_gray = map(round(y_fov-(lx/2)):round(y_fov+(lx/2)-1),yy-ly+1:yy);
% end


% if round((sx/2)-y_fovea) > 0 && round((sy/2)-x_fovea) > 0
%     I1_gray = map(round((sx/2)-y_fovea):round((sx/2)+lx-y_fovea-1),round((sy/2)-x_fovea):round((sy/2)+ly-x_fovea)-1);%*3000/1536;
% elseif round((sx/2)-y_fovea) > 0 && round((sy/2)-x_fovea) < 0
%     if 
%     I1_gray = map(round((sx/2)-y_fovea):round((sx/2)+lx-y_fovea-1),1:ly);%*3000/1536;
% elseif round((sx/2)-y_fovea) < 0 && round((sy/2)-x_fovea) > 0
%     I1_gray = map(1:lx,round((sy/2)-x_fovea):round((sy/2)+ly-x_fovea)-1);%*3000/1536;
% end

position=[];
%stats2=[];

% ap=3; bp=12; cp=12;
% av=1536; bv=500; cv=500;
% sc1=1; sc2=1; sc3=1;
  
for i= 1:length(num_id)-1
    temp = (zeros(size(I1)));
    ind = find(lb==i);
    temp(ind) = I6(ind);  
    temp_cc_position=temp.*I_mask_squares;
    cc_temp_cc_position=bwconncomp(temp_cc_position);
    stats_cc_temp_cc_position = regionprops(cc_temp_cc_position,'centroid','Area');
    quadrant_position_temp = cat(1, stats_cc_temp_cc_position.Centroid);

%     hmap(temp,nd);
% %     temp(ind) = I1_gray(ind);  
    cc4=bwconncomp(temp);
    stats = regionprops(cc4,'centroid','Area');
    centroids = cat(1, stats.Centroid);
%     figure;imshow(temp);
    temp2(:) = I1_gray(ind);
    Means=mean(double(temp2));
    STDs=std(double(temp2));
    Maxs=max(double(temp2));
    Mins=min(double(temp2));  
    

    
    % volest = sum(double(temp2))*(((ap*sc1)/av)*(bp*sc2)/(bv)*((cp*sc3)/cv));
    % vesVol = sum(double(temp2))*(((ap*sc1)/av)*(bp*sc2)/(bv)*((cp*sc3)/cv));


   i
 
    quadrant_position_temp
   
    
    if strcmp(OpticDiscSide,ref_OpticDiscSide)==1 
        if ~isempty(quadrant_position_temp)
            if abs(round(quadrant_position_temp(2))-round(lx/2)) <=1  &&  abs(round(quadrant_position_temp(1))-25) <= 1
                11
                ETDRS_Sectors_new='Nasal';
                stats2(1,:)= [{ETDRS_Sectors_new}, {Means}, {STDs}, {Mins},{Maxs}];
                Means1(1)=Means;
                STDs1(1)=STDs;
                Maxs1(1)=Maxs;
                Mins1(1)=Mins;
                position(1,:)= centroids;
            elseif abs(round(quadrant_position_temp(2))-25) <=1 &&  abs(round(quadrant_position_temp(1)) - round(ly/2))<=1
                22
                ETDRS_Sectors_new='Superior';
                stats2(2,:)= [{ETDRS_Sectors_new}, {Means}, {STDs}, {Mins},{Maxs}];
                Means1(2)=Means;
                STDs1(2)=STDs;
                Maxs1(2)=Maxs;
                Mins1(2)=Mins;
                position(2,:)= centroids;
            elseif abs(round(quadrant_position_temp(2))-round(lx/2))<=1 &&  abs(round(quadrant_position_temp(1)) - (ly-25))<=1
                33
                ETDRS_Sectors_new='Temporal';
                stats2(3,:)= [{ETDRS_Sectors_new}, {Means}, {STDs}, {Mins},{Maxs}];
                Means1(3)=Means;
                STDs1(3)=STDs;
                Maxs1(3)=Maxs;
                Mins1(3)=Mins;
                position(3,:)= centroids;
            elseif abs(round(quadrant_position_temp(2)) - (lx-25))<=1 &&  abs(round(quadrant_position_temp(1)) - round(ly/2))<=1
                44
                ETDRS_Sectors_new='Inferior';
                stats2(4,:)= [{ETDRS_Sectors_new}, {Means}, {STDs}, {Mins},{Maxs}];
                Means1(4)=Means;
                STDs1(4)=STDs;
                Maxs1(4)=Maxs;
                Mins1(4)=Mins;
                position(4,:)= centroids;
            end
        else
            55
            ETDRS_Sectors_new='Central';
            stats2(5,:)= [{ETDRS_Sectors_new}, {Means}, {STDs}, {Mins},{Maxs}];
            Means1(5)=Means;
            STDs1(5)=STDs;
            Maxs1(5)=Maxs;
            Mins1(5)=Mins;
            position(5,:)= centroids;
        end
    else         
        if ~isempty(quadrant_position_temp)
            if abs(round(quadrant_position_temp(2)) - round(lx/2))<=1 &&  abs(round(quadrant_position_temp(1)) - 25)<=1
                11
                ETDRS_Sectors_new ='Temporal';
                stats2(3,:)= [{ETDRS_Sectors_new}, {Means}, {STDs}, {Mins},{Maxs}];
                Means1(3)=Means;
                STDs1(3)=STDs;
                Maxs1(3)=Maxs;
                Mins1(3)=Mins;
                position(3,:)= centroids;
            elseif abs(round(quadrant_position_temp(2)) - 25)<=1 &&  abs(round(quadrant_position_temp(1)) - round(ly/2))<=1
                22
                ETDRS_Sectors_new ='Superior';
                stats2(2,:) = [{ETDRS_Sectors_new}, {Means}, {STDs}, {Mins},{Maxs}];
                Means1(2)=Means;
                STDs1(2)=STDs;
                Maxs1(2)=Maxs;
                Mins1(2)=Mins;
                position(2,:)= centroids;
            elseif abs(round(quadrant_position_temp(2)) - round(lx/2))<=1 &&  abs(round(quadrant_position_temp(1)) - (ly-25))<=1
                33
                ETDRS_Sectors_new ='Nasal';
                stats2(1,:)= [{ETDRS_Sectors_new}, {Means}, {STDs}, {Mins},{Maxs}];
                Means1(1)=Means;
                STDs1(1)=STDs;
                Maxs1(1)=Maxs;
                Mins1(1)=Mins;
                position(1,:)= centroids;
            elseif abs(round(quadrant_position_temp(2)) - (lx-25))<=1 &&  abs(round(quadrant_position_temp(1)) - round(ly/2))<=1
                44
                ETDRS_Sectors_new ='Inferior';
                stats2(4,:)= [{ETDRS_Sectors_new}, {Means}, {STDs}, {Mins},{Maxs}];
                Means1(4)=Means;
                STDs1(4)=STDs;
                Maxs1(4)=Maxs;
                Mins1(4)=Mins;
                position(4,:)= centroids;
            end
        else
            55
            ETDRS_Sectors_new ='Central';
            stats2(5,:) = [{ETDRS_Sectors_new}, {Means}, {STDs}, {Mins},{Maxs}];
            Means1(5)=Means;
            STDs1(5)=STDs;
            Maxs1(5)=Maxs;
            Mins1(5)=Mins;
            position(5,:)= centroids;
        end
    end
    clear temp2
%     position = [position; centroids];
%     stats2 = [stats2;i,Means(i),STDs(i),Mins(i),Maxs(i)];
%     stats2 = [stats2;{ETDRS_Sectors_new}, {Means(i)}, {STDs(i)}, {Mins(i)},{Maxs(i)}];
end

for ii = 1:length(num_id)-1
    ii
    temp22 = ['Avg:' num2str(Means1(ii),'%0.3f')];
    % temp33 = ['SD:' num2str(STDs1(ii),'%0.3f')];
    % temp44 = ['Min:' num2str(Mins1(ii),'%0.3f')];
    % temp55 = ['Max:' num2str(Maxs1(ii),'%0.3f')];
    % len_temp22 = length(temp22);
    % len_temp33 = length(temp33);
    % len_temp44 = length(temp44);
    % len_temp55 = length(temp55);
    % text_str_temp = [{temp22};{temp33};{temp44};{temp55}];
    text_str1{ii} = temp22;
    % text_str2{ii} = temp33;
    % text_str3{ii} = temp44;
    % text_str4{ii} = temp55;
%     if len_temp22 > len_temp33;
%         text_str{ii} = [temp22; sprintf('%s   ',temp33)];
%     else
%         text_str{ii} = [sprintf('%s  ',temp22);temp33];
%     end
end
% out = [out;{i},{Means(i)},{STDs(i)}];
% c_img_org2=uint8(zeros(size(c_img_org)));
c_img_org2 = uint8(255*(mat2gray(I1_gray)));
% for i=1:size(c_img_org,1)
%     for j=1:size(c_img_org,2)
%         c_img_org2(i,j)= 255*(c_img_org(i,j)-min(min(c_img_org)))/(max(max(c_img_org))-min(min(c_img_org)));        
%     end
% end

cmap = flipud(hot(255));
c_img1 = ind2rgb(c_img_org2, cmap);
indx = find(mask_temp==1);
c_img21 = c_img1(:,:,1);
c_img22 = c_img1(:,:,2);
c_img23 = c_img1(:,:,3);
c_img21(indx) = 0;
c_img22(indx) = 0;
c_img23(indx) = 0;
clear c_img3;
c_img3(:,:,1) = c_img21;
c_img3(:,:,2) = c_img22;
c_img3(:,:,3) = c_img23;

clear RGB;
RGB = insertText(c_img3,position,text_str1,'FontSize',20,'Font','Arial','TextColor','yellow','BoxColor','black','AnchorPoint','CenterBottom');
% fgsh(RGB)
% RGB = insertText(RGB,position,text_str2,'FontSize',10,'Font','Arial','TextColor','yellow','BoxColor','black','AnchorPoint','CenterCenter');
% RGB = insertText(RGB,position,text_str3,'FontSize',10,'Font','Arial','TextColor','yellow','BoxColor','black','AnchorPoint','CenterCenter');
% RGB = insertText(RGB,position,text_str4,'FontSize',30,'Font','Arial','TextColor','yellow','BoxColor','black','AnchorPoint','CenterTop');
%close(filname_ETDRS_stats)
% filname_ETDRS_stats = strcat(output_folder,'/',filename(1:end-4),'_ETDRS_Curvature_stats','.xlsx');
% actxserver('Excel.Application');
% !taskkill -f -im EXCEL.exe
% xlswrite(filname_ETDRS_stats,{'Region','Mean (Avg) um','Standard deviation (SD) um','Mininum um','Maximum um'},1,'A1');
% xlswrite(filname_ETDRS_stats,stats2,1,'A2'); 

%Zcib figure
% imshow(RGB)
