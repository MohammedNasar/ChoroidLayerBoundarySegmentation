% ChTopo_Oneshot
function getGaussianCurvature_12x12(x_fovea, y_fovea,cib_3Dsm, cob_3Dsm, OutputFP_Nm, OpticDiscSide)

fileNameExcel_Org_Pmax_Curv_CIB=strcat(OutputFP_Nm,'Org_Pmax_Curv_CIB_Stats.xlsx');
fileNameExcel_Org_Pmax_Curv_COB=strcat(OutputFP_Nm,'Org_Pmax_Curv_COB_Stats.xlsx');
fileNameExcel_Org_Pmin_Curv_CIB=strcat(OutputFP_Nm,'Org_Pmin_Curv_CIB_Stats.xlsx');
fileNameExcel_Org_Pmin_Curv_COB=strcat(OutputFP_Nm,'Org_Pmin_Curv_COB_Stats.xlsx');
fileNameExcel_Org_Gaus_Curv_CIB=strcat(OutputFP_Nm,'Org_Gaus_Curv_CIB_Stats.xlsx');
fileNameExcel_Org_Gaus_Curv_COB=strcat(OutputFP_Nm,'Org_Gaus_Curv_COB_Stats.xlsx');
fileNameExcel_Org_Mean_Curv_CIB=strcat(OutputFP_Nm,'Org_Mean_Curv_CIB_Stats.xlsx');
fileNameExcel_Org_Mean_Curv_COB=strcat(OutputFP_Nm,'Org_Mean_Curv_COB_Stats.xlsx');
fileNameExcel_Org_Gaus_Curv_CIB_diff=strcat(OutputFP_Nm,'Org_Gaus_Curv_CIB_diff_Stats.xlsx');
fileNameExcel_Org_Gaus_Curv_COB_diff=strcat(OutputFP_Nm,'Org_Gaus_Curv_COB_diff_Stats.xlsx');
fileNameExcel_Org_Pmax_Curv_CIB_diff=strcat(OutputFP_Nm,'Org_Pmax_Curv_CIB_diff_Stats.xlsx');
fileNameExcel_Org_Pmax_Curv_COB_diff=strcat(OutputFP_Nm,'Org_Pmax_Curv_COB_diff_Stats.xlsx');
fileNameExcel_Org_Pmin_Curv_CIB_diff=strcat(OutputFP_Nm,'Org_Pmin_Curv_CIB_diff_Stats.xlsx');
fileNameExcel_Org_Pmin_Curv_COB_diff=strcat(OutputFP_Nm,'Org_Pmin_Curv_COB_diff_Stats.xlsx');
fileNameExcel_Org_Mean_Curv_CIB_diff=strcat(OutputFP_Nm,'Org_Mean_Curv_CIB_diff_Stats.xlsx');
fileNameExcel_Org_Mean_Curv_COB_diff=strcat(OutputFP_Nm,'Org_Mean_Curv_COB_diff_Stats.xlsx');
fileNameExcel_Curvature_Stats_Org_cib_diff=strcat(OutputFP_Nm,'Curvature_Stats_Org_CIB_diff.xlsx');
fileNameExcel_Curvature_Stats_Org_cob_diff=strcat(OutputFP_Nm,'Curvature_Stats_Org_COB_diff.xlsx');
fileNameExcel_Curvature_Stats_Org_cib=strcat(OutputFP_Nm,'Curvature_Stats_Org_CIB.xlsx');
fileNameExcel_Curvature_Stats_Org_cob=strcat(OutputFP_Nm,'Curvature_Stats_Org_COB.xlsx');

system('taskkill /F /IM EXCEL.EXE');

Excel_OverallCurvBFS_CIB = strcat(OutputFP_Nm,'OverallCurvatureBestFitSphere_CIB_org.xlsx');
Excel_OverallCurvBFS_COB = strcat(OutputFP_Nm,'OverallCurvatureBestFitSphere_COB_org.xlsx');

cib = imresize(flipud(cib_3Dsm'),[1024 1024],"bilinear");
cob = imresize(flipud(cob_3Dsm'),[1024 1024],"bilinear");

CIB3D_Fill_Mod = cib(:,2:end-1);
COB3D_Fill_Mod = cob(:,2:end-1);
CIB3D_org = CIB3D_Fill_Mod;
COB3D_org = COB3D_Fill_Mod;
X = zeros(size(CIB3D_Fill_Mod));
Y = zeros(size(CIB3D_Fill_Mod));
for i=1:size(CIB3D_Fill_Mod,1)
    X(i,:)=i*12/1024;
end
for j=1:size(CIB3D_Fill_Mod,2)
    Y(:,j)=j*12/1024;
end
Zcib_org = CIB3D_Fill_Mod*3/1536;
Zcob_org = COB3D_Fill_Mod*3/1536;
[Kcib_org,Hcib_org,Pmaxcib_org,Pmincib_org] = surfature(Y,X,Zcib_org);
[Kcob_org,Hcob_org,Pmaxcob_org,Pmincob_org] = surfature(Y,X,Zcob_org);


% Zcib_mod = CIB3D_Fill_Mod2*3/1536;
% Zcob_mod = COB3D_Fill_Mod2*3/1536;
% [Kcib_mod,Hcib_mod,Pmaxcib_mod,Pmincib_mod] = surfature(Y,X,Zcib_mod);
% [Kcob_mod,Hcob_mod,Pmaxcob_mod,Pmincob_mod] = surfature(Y,X,Zcob_mod);


[r_cib,~,~,~] = sphereFit([X(:),Y(:),Zcib_org(:)]);
[r_cob,~,~,~] = sphereFit([X(:),Y(:),Zcob_org(:)]);

% fileNameExcel_OverallCurvatureBestFitSphere_CIB_org = handles.fileNameExcel_OverallCurvatureBestFitSphere_CIB_org;
% fileNameExcel_OverallCurvatureBestFitSphere_COB_org = handles.fileNameExcel_OverallCurvatureBestFitSphere_COB_org;
% r_cib = handles.r_cib;
% r_cob = handles.r_cob;
Global_Curvature_CIB = [r_cib,1/(r_cib^2),1/r_cib,1/r_cib,1/r_cib];
Global_Curvature_COB = [r_cob,1/(r_cob^2),1/r_cob,1/r_cob,1/r_cob];
% Global_Curvature_CIB_mod = [r_cib_mod,1/(r_cib_mod^2),1/r_cib_mod,1/r_cib_mod,1/r_cib_mod];
% Global_Curvature_COB_mod = [r_cob_mod,1/(r_cob_mod^2),1/r_cob_mod,1/r_cob_mod,1/r_cob_mod];

xlswrite(Excel_OverallCurvBFS_CIB,{'radiusofcurvature','Gaussian Curvature','Mean Curvature','PrincipalMin Curvature','PrincipalMax Curvature'},1,'A1');
xlswrite(Excel_OverallCurvBFS_CIB,Global_Curvature_CIB,1,'A1');
xlswrite(Excel_OverallCurvBFS_COB,{'radiusofcurvature','Gaussian Curvature','Mean Curvature','PrincipalMin Curvature','PrincipalMax Curvature'},1,'A1');
xlswrite(Excel_OverallCurvBFS_COB,Global_Curvature_COB,1,'A1');

% fileNameExcel_ThicknessStats=handles.fileNameExcel_ThicknessStats;
% ThicknessMap=handles.ThicknessMap;
% OpticDiscSide = handles.OpticDiscSide;

% x_fovea = handles.foveaX;
% y_fovea = handles.foveaY;
% % x_fovea
% % y_fovea

% OpticX = handles.OpticX;
% OpticY = handles.OpticY;
% 
% SupX = handles.SuperiorX;
% SupY = handles.SuperiorY;
% filname_sph_cib_org_stats = strcat(OutputFP_Nm,'sph_cib_org_quad_stats.xlsx');
Kcib_org_diff = -(Kcib_org-(1/(r_cib^2)));
Pmaxcib_org_diff = -(Pmaxcib_org-(1/r_cib));
Pmincib_org_diff = -(Pmincib_org-(1/r_cib));
Hcib_org_diff = -(Hcib_org-(1/r_cib));
Kcob_org_diff = -(Kcob_org-(1/(r_cob^2)));
Pmaxcob_org_diff = -(Pmaxcob_org-(1/r_cob));
Pmincob_org_diff = -(Pmincob_org-(1/r_cob));
Hcob_org_diff = -(Hcob_org-(1/r_cob));

%Gaussian
[RGB_Kcib_org_diff, stats3_Kcib_org_diff] =  get_quad_Circle_stats_GaussianCurvature(Kcib_org_diff,x_fovea, y_fovea,fileNameExcel_Org_Gaus_Curv_CIB_diff,OpticDiscSide);
filename_RGB_cib_diff = strcat(OutputFP_Nm,'CIB_Gauss_org_diff_Curvaturemap_with_Grid.jpg');
imwrite(RGB_Kcib_org_diff,filename_RGB_cib_diff);



[RGB_Kcob_org_diff, stats3_Kcob_org_diff] =  get_quad_Circle_stats_GaussianCurvature(Kcob_org_diff,x_fovea, y_fovea,fileNameExcel_Org_Gaus_Curv_COB_diff,OpticDiscSide);
filename_RGB_cob_diff = strcat(OutputFP_Nm,'COB_Gauss_org_diff_Curvaturemap_with_Grid.jpg');
imwrite(RGB_Kcob_org_diff,filename_RGB_cob_diff);

%Mean

[RGB_Hcib_org_diff, stats3_Hcib_org_diff] =  get_quad_Circle_stats_GaussianCurvature(Hcib_org_diff,x_fovea, y_fovea,fileNameExcel_Org_Mean_Curv_CIB_diff,OpticDiscSide);
filename_RGB_cib_diff = strcat(OutputFP_Nm,'CIB_Mean_org_diff_Curvaturemap_with_Grid.jpg');
imwrite(RGB_Hcib_org_diff,filename_RGB_cib_diff);

[RGB_Hcob_org_diff, stats3_Hcob_org_diff] =  get_quad_Circle_stats_GaussianCurvature(Hcob_org_diff,x_fovea, y_fovea,fileNameExcel_Org_Mean_Curv_COB_diff,OpticDiscSide);
filename_RGB_cob_diff = strcat(OutputFP_Nm,'COB_Mean_org_diff_Curvaturemap_with_Grid.jpg');
imwrite(RGB_Hcob_org_diff,filename_RGB_cob_diff);



%PrinicpalMin
[RGB_Pmincib_org_diff, stats3_Pmincib_org_diff] =  get_quad_Circle_stats_GaussianCurvature(Pmincib_org_diff,x_fovea, y_fovea,fileNameExcel_Org_Pmin_Curv_CIB_diff,OpticDiscSide);
filename_RGB_cib_diff = strcat(OutputFP_Nm,'CIB_Pmin_org_diff_Curvaturemap_with_Grid.jpg');
imwrite(RGB_Pmincib_org_diff,filename_RGB_cib_diff);

[RGB_Pmincob_org_diff, stats3_Pmincob_org_diff] =  get_quad_Circle_stats_GaussianCurvature(Pmincob_org_diff,x_fovea, y_fovea,fileNameExcel_Org_Pmin_Curv_COB_diff,OpticDiscSide);
filename_RGB_cob_diff = strcat(OutputFP_Nm,'COB_Pmin_org_diff_Curvaturemap_with_Grid.jpg');
imwrite(RGB_Pmincob_org_diff,filename_RGB_cob_diff);

%PrinicipalMax
[RGB_Pmaxcib_org_diff, stats3_Pmaxcib_org_diff] =  get_quad_Circle_stats_GaussianCurvature(Pmaxcib_org_diff,x_fovea, y_fovea,fileNameExcel_Org_Pmax_Curv_CIB_diff,OpticDiscSide);
filename_RGB_cib_diff = strcat(OutputFP_Nm,'CIB_Pmax_org_diff_Curvaturemap_with_Grid.jpg');
imwrite(RGB_Pmaxcib_org_diff,filename_RGB_cib_diff);

[RGB_Pmaxcob_org_diff, stats3_Pmaxcob_org_diff] =  get_quad_Circle_stats_GaussianCurvature(Pmaxcob_org_diff,x_fovea, y_fovea,fileNameExcel_Org_Pmax_Curv_COB_diff,OpticDiscSide);
filename_RGB_cob_diff = strcat(OutputFP_Nm,'COB_Pmax_org_Curvaturemap_with_Grid.jpg');
imwrite(RGB_Pmaxcob_org_diff,filename_RGB_cob_diff);

Org_Stats_Curv_cib_diff = [stats3_Kcib_org_diff stats3_Hcib_org_diff(:,2:end) stats3_Pmincib_org_diff(:,2:end) stats3_Pmaxcib_org_diff(:,2:end)];


xlswrite(fileNameExcel_Curvature_Stats_Org_cib_diff,{'Grid','Gaussian Curvature','Gaussian Curvature','Gaussian Curvature','Gaussian Curvature',...
    'Mean Curvature','Mean Curvature','Mean Curvature','Mean Curvature',...
    'PrincipalMin Curvature','PrincipalMin Curvature','PrincipalMin Curvature','PrincipalMin Curvature',...
    'PrincipalMax Curvature','PrincipalMax Curvature','PrincipalMax Curvature','PrincipalMax Curvature'},1,'A1');
xlswrite(fileNameExcel_Curvature_Stats_Org_cib_diff,{'Region','Mean (Avg)','Standard deviation (SD)','Mininum','Maximum','Mean (Avg)'...
    ,'Standard deviation (SD)','Mininum','Maximum'...
    ,'Mean (Avg)','Standard deviation (SD)','Mininum','Maximum'...
    ,'Mean (Avg)','Standard deviation (SD)','Mininum','Maximum'},1,'A2');
xlswrite(fileNameExcel_Curvature_Stats_Org_cib_diff,Org_Stats_Curv_cib_diff,1,'A3'); 

Org_Stats_Curv_cob_diff = [stats3_Kcob_org_diff stats3_Hcob_org_diff(:,2:end) stats3_Pmincob_org_diff(:,2:end) stats3_Pmaxcob_org_diff(:,2:end)];
xlswrite(fileNameExcel_Curvature_Stats_Org_cob_diff,{'Grid','Gaussian Curvature','Gaussian Curvature','Gaussian Curvature','Gaussian Curvature',...
    'Mean Curvature','Mean Curvature','Mean Curvature','Mean Curvature',...
    'PrincipalMin Curvature','PrincipalMin Curvature','PrincipalMin Curvature','PrincipalMin Curvature',...
    'PrincipalMax Curvature','PrincipalMax Curvature','PrincipalMax Curvature','PrincipalMax Curvature'},1,'A1');
xlswrite(fileNameExcel_Curvature_Stats_Org_cob_diff,{'Region','Mean (Avg)','Standard deviation (SD)','Mininum','Maximum','Mean (Avg)'...
    ,'Standard deviation (SD)','Mininum','Maximum'...
    ,'Mean (Avg)','Standard deviation (SD)','Mininum','Maximum'...
    ,'Mean (Avg)','Standard deviation (SD)','Mininum','Maximum'},1,'A2');
xlswrite(fileNameExcel_Curvature_Stats_Org_cob_diff,Org_Stats_Curv_cob_diff,1,'A3'); 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5


%% Original Surface

%Gaussian
[RGB_Kcib_org, stats3_Kcib_org] =  get_quad_Circle_stats_GaussianCurvature(Kcib_org,x_fovea, y_fovea,fileNameExcel_Org_Gaus_Curv_CIB,OpticDiscSide);
filename_RGB_cib = strcat(OutputFP_Nm,'CIB_Gauss_org_Curvaturemap_with_Grid.jpg');
imwrite(RGB_Kcib_org,filename_RGB_cib);



[RGB_Kcob_org, stats3_Kcob_org] =  get_quad_Circle_stats_GaussianCurvature(Kcob_org,x_fovea, y_fovea,fileNameExcel_Org_Gaus_Curv_COB,OpticDiscSide);
filename_RGB_cob = strcat(OutputFP_Nm,'COB_Gauss_org_Curvaturemap_with_Grid.jpg');
imwrite(RGB_Kcob_org,filename_RGB_cob);

%Mean

[RGB_Hcib_org, stats3_Hcib_org] =  get_quad_Circle_stats_GaussianCurvature(Hcib_org,x_fovea, y_fovea,fileNameExcel_Org_Mean_Curv_CIB,OpticDiscSide);
filename_RGB_cib = strcat(OutputFP_Nm,'CIB_Mean_org_Curvaturemap_with_Grid.jpg');
imwrite(RGB_Hcib_org,filename_RGB_cib);

[RGB_Hcob_org, stats3_Hcob_org] =  get_quad_Circle_stats_GaussianCurvature(Hcob_org,x_fovea, y_fovea,fileNameExcel_Org_Mean_Curv_COB,OpticDiscSide);
filename_RGB_cob = strcat(OutputFP_Nm,'COB_Mean_org_Curvaturemap_with_Grid.jpg');
imwrite(RGB_Hcob_org,filename_RGB_cob);



%PrinicpalMin
[RGB_Pmincib_org, stats3_Pmincib_org] =  get_quad_Circle_stats_GaussianCurvature(Pmincib_org,x_fovea, y_fovea,fileNameExcel_Org_Pmin_Curv_CIB,OpticDiscSide);
filename_RGB_cib = strcat(OutputFP_Nm,'CIB_Pmin_org_Curvaturemap_with_Grid.jpg');
imwrite(RGB_Pmincib_org,filename_RGB_cib);

[RGB_Pmincob_org, stats3_Pmincob_org] =  get_quad_Circle_stats_GaussianCurvature(Pmincob_org,x_fovea, y_fovea,fileNameExcel_Org_Pmin_Curv_COB,OpticDiscSide);
filename_RGB_cob = strcat(OutputFP_Nm,'COB_Pmin_org_Curvaturemap_with_Grid.jpg');
imwrite(RGB_Pmincob_org,filename_RGB_cob);

%PrinicipalMax
[RGB_Pmaxcib_org, stats3_Pmaxcib_org] =  get_quad_Circle_stats_GaussianCurvature(Pmaxcib_org,x_fovea, y_fovea,fileNameExcel_Org_Pmax_Curv_CIB,OpticDiscSide);
filename_RGB_cib = strcat(OutputFP_Nm,'CIB_Pmax_org_Curvaturemap_with_Grid.jpg');
imwrite(RGB_Pmaxcib_org,filename_RGB_cib);

[RGB_Pmaxcob_org, stats3_Pmaxcob_org] =  get_quad_Circle_stats_GaussianCurvature(Pmaxcob_org,x_fovea, y_fovea,fileNameExcel_Org_Pmax_Curv_COB,OpticDiscSide);
filename_RGB_cob = strcat(OutputFP_Nm,'COB_Pmax_org_Curvaturemap_with_Grid.jpg');
imwrite(RGB_Pmaxcob_org,filename_RGB_cob);




Org_Stats_Curv_cib = [stats3_Kcib_org stats3_Hcib_org(:,2:end) stats3_Pmincib_org(:,2:end) stats3_Pmaxcib_org(:,2:end)];


xlswrite(fileNameExcel_Curvature_Stats_Org_cib,{'Grid','Gaussian Curvature','Gaussian Curvature','Gaussian Curvature','Gaussian Curvature',...
    'Mean Curvature','Mean Curvature','Mean Curvature','Mean Curvature',...
    'PrincipalMin Curvature','PrincipalMin Curvature','PrincipalMin Curvature','PrincipalMin Curvature',...
    'PrincipalMax Curvature','PrincipalMax Curvature','PrincipalMax Curvature','PrincipalMax Curvature'},1,'A1');
xlswrite(fileNameExcel_Curvature_Stats_Org_cib,{'Region','Mean (Avg)','Standard deviation (SD)','Mininum','Maximum','Mean (Avg)'...
    ,'Standard deviation (SD)','Mininum','Maximum'...
    ,'Mean (Avg)','Standard deviation (SD)','Mininum','Maximum'...
    ,'Mean (Avg)','Standard deviation (SD)','Mininum','Maximum'},1,'A2');
xlswrite(fileNameExcel_Curvature_Stats_Org_cib,Org_Stats_Curv_cib,1,'A3'); 

Org_Stats_Curv_cob = [stats3_Kcob_org stats3_Hcob_org(:,2:end) stats3_Pmincob_org(:,2:end) stats3_Pmaxcob_org(:,2:end)];
xlswrite(fileNameExcel_Curvature_Stats_Org_cob,{'Grid','Gaussian Curvature','Gaussian Curvature','Gaussian Curvature','Gaussian Curvature',...
    'Mean Curvature','Mean Curvature','Mean Curvature','Mean Curvature',...
    'PrincipalMin Curvature','PrincipalMin Curvature','PrincipalMin Curvature','PrincipalMin Curvature',...
    'PrincipalMax Curvature','PrincipalMax Curvature','PrincipalMax Curvature','PrincipalMax Curvature'},1,'A1');
xlswrite(fileNameExcel_Curvature_Stats_Org_cob,{'Region','Mean (Avg)','Standard deviation (SD)','Mininum','Maximum','Mean (Avg)'...
    ,'Standard deviation (SD)','Mininum','Maximum'...
    ,'Mean (Avg)','Standard deviation (SD)','Mininum','Maximum'...
    ,'Mean (Avg)','Standard deviation (SD)','Mininum','Maximum'},1,'A2');
xlswrite(fileNameExcel_Curvature_Stats_Org_cob,Org_Stats_Curv_cob,1,'A3'); 


% fileNameMAT_Curvature_stats=strcat(OutputFP_Nm,'CurvatureAnalysisWorkSpace.mat')
% save(fileNameMAT_Curvature_stats,'Kcib_org','Pmaxcib_org','Pmincib_org','Hcib_org','Kcob_org','Pmaxcob_org','Pmincob_org',...
%     'Hcob_org','CIB3D_org',...
%     'COB3D_org','r_cib','r_cob','ThicknessMap','OpticDiscSide','x_fovea','y_fovea',...
%     'RGB_Thickness', 'stats3_cib_thicknes',...
%     'RGB_Kcib_org_diff', 'stats3_Kcib_org_diff','RGB_Kcob_org_diff', 'stats3_Kcob_org_diff','RGB_Hcib_org_diff', 'stats3_Hcib_org_diff','RGB_Hcob_org_diff', 'stats3_Hcob_org_diff',...
%     'RGB_Pmincib_org_diff', 'stats3_Pmincib_org_diff','RGB_Pmincob_org_diff', 'stats3_Pmincob_org_diff','RGB_Pmaxcib_org_diff', 'stats3_Pmaxcib_org_diff','RGB_Pmaxcob_org_diff', 'stats3_Pmaxcob_org_diff',...
%     'RGB_sph_cib_org', 'stats2_sph_cib_org','RGB_sph_cob_org', 'stats2_sph_cob_org','RGB_sph_cob_org');
% 


system('taskkill /F /IM EXCEL.EXE');
% winopen(OutputFP_Nm1)

end

