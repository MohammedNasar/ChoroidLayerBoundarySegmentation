function [RGB, stats2] =  get_quad_Circle_stats_Thickness_6x6(ThicknessMap,x_fovea, y_fovea,filname_ETDRS_stats,OpticDiscSide)

% ETDRS_Sectors{1}='Central';
% ETDRS_Sectors{2}='Inner Superior';
% ETDRS_Sectors{3}='Inner Temporal';
% ETDRS_Sectors{4}='Inner Nasal';
% ETDRS_Sectors{5}='Inner Inferior';
% ETDRS_Sectors{6}='Outer Superior';
% ETDRS_Sectors{7}='Outer Temporal';
% ETDRS_Sectors{8}='Outer Nasal';
% ETDRS_Sectors{9}='Outer Inferior';


ref_OpticDiscSide='Left';

[lx, ly] = size(ThicknessMap);

I_quad_temp =uint8(zeros(750,750));
I_quad = insertShape(I_quad_temp,'Line',[1 1 750 750; 750 1 1 750],'LineWidth',7,'Color','white');
I_quad2=I_quad(:,:,1)==255;
I_quad3=zeros(size(I_quad2,1),size(I_quad2,2),3);
I_quad4=insertShape(I_quad3,'FilledCircle',[375 375 (1.5*1024)/12],'Color',[1 1 1],'Opacity',1);
I_quad5=I_quad4(:,:,1)>0;
I_quad6=I_quad2;
idx=I_quad5==1;
I_quad6(idx)=0;
I_quad7=zeros(size(I_quad2,1),size(I_quad2,2),3);
I_quad7=insertShape(I_quad7,'Circle',[375 375 (1.5*1024)/12+1],'Color',[1 1 1],'LineWidth',5);
idx2=I_quad7(:,:,1)>0;
I_quad6(idx2)=255;


% grid_size = 1024;
% mask_temp = uint8(255*ones(size(c_img_org)));
mask_temp=I_quad6(round(size(I_quad2,1)/2-y_fovea):round(size(I_quad2,1)/2+lx-y_fovea-1),round(size(I_quad2,2)/2-x_fovea):round(size(I_quad2,2)/2+ly-x_fovea)-1);
% grid_cropped_resize3 = imresize(grid_cropped,[grid_size grid_size]);
% grid_cropped_resize2 = zeros(size(c_img_org));
% grid_cropped_resize2(round(lx/2)-round(grid_size/2)+1:round(lx/2)+round(grid_size/2),round(ly/2)-round(grid_size/2)+1:round(ly/2)+round(grid_size/2)) = grid_cropped_1025;
I_mask_squares = zeros(size(ThicknessMap));
I_mask_squares(lx/2-25:lx/2+25,1:50) = 1;
I_mask_squares(1:50,ly/2-25:ly/2+25) = 1;
I_mask_squares(end-50:end,ly/2-25:ly/2+25) = 1;
I_mask_squares(lx/2-25:lx/2+25,end-50:end) = 1;


I1 = mask_temp==1;
% cc = bwconncomp(I1);
% bb = zeros(size(I1));
% numPixels = cellfun(@numel,cc.PixelIdxList);
% [biggest,idx] = max(numPixels);
% bb(cc.PixelIdxList{idx}) = 1;
% I2 = imfill(bb,'holes');
% cc2 = bwconncomp(I2);
% bb2 = (zeros(size(I1)));
% numPixels2 = cellfun(@numel,cc2.PixelIdxList);
% [biggest2,idx2] = max(numPixels2);
% bb2(cc2.PixelIdxList{idx2}) = 1;
% se = strel('disk',1);
% I3 = imclose(imopen(imfill(bb2,'holes'),se),se);
% % figure;imshow(I3)
% I4 = imcomplement(I3);
% idx = find(bb==1);
% I5 = I4;
% I5(idx) = 1;
% figure;imshow(I5);
% se2 = strel('disk',1);
% I6 = imopen(imcomplement(I5),se2);
% I
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

I1_gray = ThicknessMap*3000/1536;
position=[];
%stats2=[];
  
for i= 1:length(num_id)-1
    clear temp ind temp_cc_position cc_temp_cc_position stats_cc_temp_cc_position quadrant_position_temp
    clear cc4 stats centroids temp2 Means STDs Maxs Mins;
    
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
    temp2(:)=I1_gray(ind);
    Means=mean(double(temp2));
    STDs=std(double(temp2));
    Maxs=max(double(temp2));
    Mins=min(double(temp2));  
    
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
% stats2=[{Nasal1};{Temporal1};{Inferior1};{Superior1};{Central1}];
% stats3=[];
% for i=1:length(idx_etdrs)
%     stats3(i,:) =[{ETDRS_Sectors{idx_etdrs(i)}}, {stats2(i,2)} {stats2(i,3)},{stats2(i,4)},{stats2(i,5)}];
% end

% text_str = cell(length(num_id)-1,1);
% conf_val = [85.212 98.76 78.342];
length(num_id)
for ii=1:length(num_id)-1
    ii
    temp22 = ['Avg:' num2str(Means1(ii),'%0.1f')];
    temp33 = ['SD:' num2str(STDs1(ii),'%0.1f')];
    temp44 = ['Min:' num2str(Mins1(ii),'%0.1f')];
    temp55 = ['Max:' num2str(Maxs1(ii),'%0.1f')];
    len_temp22 = length(temp22);
    len_temp33 = length(temp33);
    len_temp44 = length(temp44);
    len_temp55 = length(temp55);
    text_str_temp = [{temp22};{temp33};{temp44};{temp55}];
    text_str1{ii} = temp22;
    text_str2{ii} = temp33;
    text_str3{ii} = temp44;
    text_str4{ii} = temp55;
%     if len_temp22 > len_temp33;
%         text_str{ii} = [temp22; sprintf('%s   ',temp33)];
%     else
%         text_str{ii} = [sprintf('%s  ',temp22);temp33];
%     end
end
% out = [out;{i},{Means(i)},{STDs(i)}];
% c_img_org2=uint8(zeros(size(c_img_org)));
c_img_org2 = uint8(255*(mat2gray(ThicknessMap)));
% for i=1:size(c_img_org,1)
%     for j=1:size(c_img_org,2)
%         c_img_org2(i,j)= 255*(c_img_org(i,j)-min(min(c_img_org)))/(max(max(c_img_org))-min(min(c_img_org)));        
%     end
% end

Map       = (jet(255));
c_img1 = ind2rgb(c_img_org2, Map);
indx = find(mask_temp==1);
c_img21=c_img1(:,:,1);
c_img22=c_img1(:,:,2);
c_img23=c_img1(:,:,3);
c_img21(indx)= 0;
c_img22(indx)= 0;
c_img23(indx)= 0;
c_img3(:,:,1)= c_img21;
c_img3(:,:,2)= c_img22;
c_img3(:,:,3)= c_img23;


RGB = insertText(c_img3,position,text_str1,'FontSize',30,'Font','Arial','TextColor','yellow','BoxColor','black','AnchorPoint','CenterBottom');
% RGB = insertText(RGB,position,text_str2,'FontSize',10,'Font','Arial','TextColor','yellow','BoxColor','black','AnchorPoint','CenterCenter');
% RGB = insertText(RGB,position,text_str3,'FontSize',10,'Font','Arial','TextColor','yellow','BoxColor','black','AnchorPoint','CenterCenter');
% RGB = insertText(RGB,position,text_str4,'FontSize',30,'Font','Arial','TextColor','yellow','BoxColor','black','AnchorPoint','CenterTop');
%close(filname_ETDRS_stats)
% filname_ETDRS_stats = strcat(output_folder,'/',filename(1:end-4),'_ETDRS_Curvature_stats','.xlsx');
% actxserver('Excel.Application');
!taskkill -f -im EXCEL.exe
xlswrite(filname_ETDRS_stats,{'Region','Mean (Avg) um','Standard deviation (SD) um','Mininum um','Maximum um'},1,'A1');
xlswrite(filname_ETDRS_stats,stats2,1,'A2'); 

%Zcib figure
% imshow(RGB)
