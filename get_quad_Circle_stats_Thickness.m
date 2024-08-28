function [RGB, stats2] =  get_quad_Circle_stats_Thickness(map,cviMap,y_fov, x_fov,OpticDiscSide,lx,ly)


ref_OpticDiscSide='Left';
% 
% if size(map,1) == 500
%     xx = 750;
%     yy = 750;
% elseif size(map,1) == 1024
    xx = 1500;
    yy = 1500;
% end

I_quad_temp =uint8(zeros(xx,yy));
I_quad = insertShape(I_quad_temp,'Line',[1 1 xx yy; xx 1 1 yy],'LineWidth',7,'Color','white');
I_quad2=I_quad(:,:,1)==255;
I_quad3=zeros(size(I_quad2,1),size(I_quad2,2),3);
I_quad4=insertShape(I_quad3,'FilledCircle',[xx/2 yy/2 1024/12],'Color',[1 1 1],'Opacity',1);
I_quad5=I_quad4(:,:,1)>0;
I_quad6=I_quad2;
idx=I_quad5==1;
I_quad6(idx)=0;
I_quad7=zeros(size(I_quad2,1),size(I_quad2,2),3);
I_quad7=insertShape(I_quad7,'Circle',[xx/2 yy/2 1024/12+1],'Color',[1 1 1],'LineWidth',5);
idx2=I_quad7(:,:,1)>0;
I_quad6(idx2)=255;

mask_temp=I_quad6(round(size(I_quad2,1)/2-x_fov):round(size(I_quad2,1)/2+lx-x_fov-1),round(size(I_quad2,2)/2-y_fov):round(size(I_quad2,2)/2+ly-y_fov)-1);
I_mask_squares = zeros(size(map));
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

map1 = map(512-lx/2+1:512+lx/2,512-ly/2+1:512+ly/2);
cviMap1 = cviMap(512-lx/2+1:512+lx/2,512-ly/2+1:512+ly/2);
I1_gray = map1*3000/1536;
position=[];
%stats2=[];

ap=3; bp=12; cp=12;
av=1536; bv=500; cv=500;
sc1=1; sc2=1; sc3=1;

for i= 1:length(num_id)-1
    i
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
    clear temp2 temp22;
    temp2(:)=I1_gray(ind);
    temp22(:)=I1_gray(ind).*cviMap1(ind);
    Means=mean(double(temp2));
    STDs=std(double(temp2));
    Maxs=max(double(temp2));
    Mins=min(double(temp2));  
    vesEst = sum(double(temp22))*(((ap*sc1)/av)*(bp*sc2)/(bv)*((cp*sc3)/cv));
    volEst = sum(double(temp2))*(((ap*sc1)/av)*(bp*sc2)/(bv)*((cp*sc3)/cv));
   i
 
    quadrant_position_temp
   
    
    if strcmp(OpticDiscSide,ref_OpticDiscSide)==1 
        if ~isempty(quadrant_position_temp)
            if abs(round(quadrant_position_temp(2))-round(lx/2)) <=1  &&  abs(round(quadrant_position_temp(1))-25) <= 1
                11
                ETDRS_Sectors_new='Nasal';
                stats2(1,:)= [{ETDRS_Sectors_new}, {Means}, {STDs}, {Mins},{Maxs},{vesEst},{volEst}];
                Means1(1)=Means;
                STDs1(1)=STDs;
                Maxs1(1)=Maxs;
                Mins1(1)=Mins;
                position(1,:)= centroids;
            elseif abs(round(quadrant_position_temp(2))-25) <=1 &&  abs(round(quadrant_position_temp(1)) - round(ly/2))<=1
                22
                ETDRS_Sectors_new='Superior';
                stats2(2,:)= [{ETDRS_Sectors_new}, {Means}, {STDs}, {Mins},{Maxs},{vesEst},{volEst}];
                Means1(2)=Means;
                STDs1(2)=STDs;
                Maxs1(2)=Maxs;
                Mins1(2)=Mins;
                position(2,:)= centroids;
            elseif abs(round(quadrant_position_temp(2))-round(lx/2))<=1 &&  abs(round(quadrant_position_temp(1)) - (ly-25))<=1
                33
                ETDRS_Sectors_new='Temporal';
                stats2(3,:)= [{ETDRS_Sectors_new}, {Means}, {STDs}, {Mins},{Maxs},{vesEst},{volEst}];
                Means1(3)=Means;
                STDs1(3)=STDs;
                Maxs1(3)=Maxs;
                Mins1(3)=Mins;
                position(3,:)= centroids;
            elseif abs(round(quadrant_position_temp(2)) - (lx-25))<=1 &&  abs(round(quadrant_position_temp(1)) - round(ly/2))<=1
                44
                ETDRS_Sectors_new='Inferior';
                stats2(4,:)= [{ETDRS_Sectors_new}, {Means}, {STDs}, {Mins},{Maxs},{vesEst},{volEst}];
                Means1(4)=Means;
                STDs1(4)=STDs;
                Maxs1(4)=Maxs;
                Mins1(4)=Mins;
                position(4,:)= centroids;
            end
        else
            55
            ETDRS_Sectors_new='Central';
            stats2(5,:)= [{ETDRS_Sectors_new}, {Means}, {STDs}, {Mins},{Maxs},{vesEst},{volEst}];
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
                stats2(3,:)= [{ETDRS_Sectors_new}, {Means}, {STDs}, {Mins},{Maxs},{vesEst},{volEst}];
                Means1(3)=Means;
                STDs1(3)=STDs;
                Maxs1(3)=Maxs;
                Mins1(3)=Mins;
                position(3,:)= centroids;
            elseif abs(round(quadrant_position_temp(2)) - 25)<=1 &&  abs(round(quadrant_position_temp(1)) - round(ly/2))<=1
                22
                ETDRS_Sectors_new ='Superior';
                stats2(2,:) = [{ETDRS_Sectors_new}, {Means}, {STDs}, {Mins},{Maxs},{vesEst},{volEst}];
                Means1(2)=Means;
                STDs1(2)=STDs;
                Maxs1(2)=Maxs;
                Mins1(2)=Mins;
                position(2,:)= centroids;
            elseif abs(round(quadrant_position_temp(2)) - round(lx/2))<=1 &&  abs(round(quadrant_position_temp(1)) - (ly-25))<=1
                33
                ETDRS_Sectors_new ='Nasal';
                stats2(1,:)= [{ETDRS_Sectors_new}, {Means}, {STDs}, {Mins},{Maxs},{vesEst},{volEst}];
                Means1(1)=Means;
                STDs1(1)=STDs;
                Maxs1(1)=Maxs;
                Mins1(1)=Mins;
                position(1,:)= centroids;
            elseif abs(round(quadrant_position_temp(2)) - (lx-25))<=1 &&  abs(round(quadrant_position_temp(1)) - round(ly/2))<=1
                44
                ETDRS_Sectors_new ='Inferior';
                stats2(4,:)= [{ETDRS_Sectors_new}, {Means}, {STDs}, {Mins},{Maxs},{vesEst},{volEst}];
                Means1(4)=Means;
                STDs1(4)=STDs;
                Maxs1(4)=Maxs;
                Mins1(4)=Mins;
                position(4,:)= centroids;
            end
        else
            55
            ETDRS_Sectors_new ='Central';
            stats2(5,:) = [{ETDRS_Sectors_new}, {Means}, {STDs}, {Mins},{Maxs},{vesEst},{volEst}];
            Means1(5)=Means;
            STDs1(5)=STDs;
            Maxs1(5)=Maxs;
            Mins1(5)=Mins;
            position(5,:)= centroids;
        end
    end
    clear temp2
end


for ii = 1:length(num_id)-1
    ii
    temp22 = ['Avg:' num2str(Means1(ii),'%0.3f')];
    text_str1{ii} = temp22;
end
c_img_org2 = uint8(255*(mat2gray(map1)));

cmap = flipud(hot(255));
c_img1 = ind2rgb(c_img_org2, cmap);
indx = find(mask_temp==1);
c_img21 = c_img1(:,:,1);
c_img22 = c_img1(:,:,2);
c_img23 = c_img1(:,:,3);
c_img21(indx) = 0;
c_img22(indx) = 0;
c_img23(indx) = 0;
c_img3(:,:,1) = c_img21;
c_img3(:,:,2) = c_img22;
c_img3(:,:,3) = c_img23;


RGB = insertText(c_img3,position,text_str1,'FontSize',20,'Font','Arial','TextColor','yellow','BoxColor','black','AnchorPoint','CenterBottom');




% % % % % % % % % stats2=[{Nasal1};{Temporal1};{Inferior1};{Superior1};{Central1}];
% % % % % % % % % stats3=[];
% % % % % % % % % for i=1:length(idx_etdrs)
% % % % % % % % %     stats3(i,:) =[{ETDRS_Sectors{idx_etdrs(i)}}, {stats2(i,2)} {stats2(i,3)},{stats2(i,4)},{stats2(i,5)}];
% % % % % % % % % end
% % % % % % % % 
% % % % % % % % % text_str = cell(length(num_id)-1,1);
% % % % % % % % % conf_val = [85.212 98.76 78.342];
% % % % % % % % length(num_id)
% % % % % % % % for ii=1:length(num_id)-1
% % % % % % % %     ii
% % % % % % % %     temp22 = ['Avg:' num2str(Means1(ii),'%0.1f')];
% % % % % % % %     temp33 = ['SD:' num2str(STDs1(ii),'%0.1f')];
% % % % % % % %     temp44 = ['Min:' num2str(Mins1(ii),'%0.1f')];
% % % % % % % %     temp55 = ['Max:' num2str(Maxs1(ii),'%0.1f')];
% % % % % % % %     len_temp22 = length(temp22);
% % % % % % % %     len_temp33 = length(temp33);
% % % % % % % %     len_temp44 = length(temp44);
% % % % % % % %     len_temp55 = length(temp55);
% % % % % % % %     text_str_temp = [{temp22};{temp33};{temp44};{temp55}];
% % % % % % % %     text_str1{ii} = temp22;
% % % % % % % %     text_str2{ii} = temp33;
% % % % % % % %     text_str3{ii} = temp44;
% % % % % % % %     text_str4{ii} = temp55;
% % % % % % % % %     if len_temp22 > len_temp33;
% % % % % % % % %         text_str{ii} = [temp22; sprintf('%s   ',temp33)];
% % % % % % % % %     else
% % % % % % % % %         text_str{ii} = [sprintf('%s  ',temp22);temp33];
% % % % % % % % %     end
% % % % % % % % end
% % % % % % % % % out = [out;{i},{Means(i)},{STDs(i)}];
% % % % % % % % % c_img_org2=uint8(zeros(size(c_img_org)));
% % % % % % % % c_img_org2 = uint8(255*(mat2gray(map)));
% % % % % % % % % for i=1:size(c_img_org,1)
% % % % % % % % %     for j=1:size(c_img_org,2)
% % % % % % % % %         c_img_org2(i,j)= 255*(c_img_org(i,j)-min(min(c_img_org)))/(max(max(c_img_org))-min(min(c_img_org)));        
% % % % % % % % %     end
% % % % % % % % % end
% % % % % % % % 
% % % % % % % % Map       = (jet(255));
% % % % % % % % c_img1 = ind2rgb(c_img_org2, Map);
% % % % % % % % indx = find(mask_temp==1);
% % % % % % % % c_img21=c_img1(:,:,1);
% % % % % % % % c_img22=c_img1(:,:,2);
% % % % % % % % c_img23=c_img1(:,:,3);
% % % % % % % % c_img21(indx)= 0;
% % % % % % % % c_img22(indx)= 0;
% % % % % % % % c_img23(indx)= 0;
% % % % % % % % c_img3(:,:,1)= c_img21;
% % % % % % % % c_img3(:,:,2)= c_img22;
% % % % % % % % c_img3(:,:,3)= c_img23;
% % % % % % % % 
% % % % % % % % 
% % % % % % % % RGB = insertText(c_img3,position,text_str1,'FontSize',30,'Font','Arial','TextColor','yellow','BoxColor','black','AnchorPoint','CenterBottom');
% % % % % % % % % RGB = insertText(RGB,position,text_str2,'FontSize',10,'Font','Arial','TextColor','yellow','BoxColor','black','AnchorPoint','CenterCenter');
% % % % % % % % % RGB = insertText(RGB,position,text_str3,'FontSize',10,'Font','Arial','TextColor','yellow','BoxColor','black','AnchorPoint','CenterCenter');
% % % % % % % % % RGB = insertText(RGB,position,text_str4,'FontSize',30,'Font','Arial','TextColor','yellow','BoxColor','black','AnchorPoint','CenterTop');
% % % % % % % % %close(filname_ETDRS_stats)
% % % % % % % % % filname_ETDRS_stats = strcat(output_folder,'/',filename(1:end-4),'_ETDRS_Curvature_stats','.xlsx');
% % % % % % % % % actxserver('Excel.Application');
% % % % % % % % !taskkill -f -im EXCEL.exe
% % % % % % % % xlswrite(filname_ETDRS_stats,{'Region','Mean (Avg) um','Standard deviation (SD) um','Mininum um','Maximum um'},1,'A1');
% % % % % % % % xlswrite(filname_ETDRS_stats,stats2,1,'A2'); 
% % % % % % % % 
% % % % % % % % %Zcib figure
% % % % % % % % % imshow(RGB)
