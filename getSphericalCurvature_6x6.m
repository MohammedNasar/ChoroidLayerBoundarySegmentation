% ChTopo_Oneshot
function getSphericalCurvature_6x6(x_fovea, y_fovea,cib_3Dsm, cob_3Dsm, OutputFP_Nm, OpticDiscSide)

system('taskkill /F /IM EXCEL.EXE');

cib = flipud(cib_3Dsm');
cob = flipud(cob_3Dsm');
% cib = imresize(flipud(cib_3Dsm'),[1024 1024],"bilinear");
% cob = imresize(flipud(cob_3Dsm'),[1024 1024],"bilinear");

CIB3D_Fill_Mod = cib(:,2:end-1);
COB3D_Fill_Mod = cob(:,2:end-1);
CIB3D_org = CIB3D_Fill_Mod;
COB3D_org = COB3D_Fill_Mod;

%% %%%%
% X=zeros(size(CIB3D_org));
% Y=zeros(size(CIB3D_org));
% for i=1:size(CIB3D_org,1)
%     X(i,:)=i*12/1024;
% end
% for j=1:size(CIB3D_org,2)
%     Y(:,j)=j*12/1024;
% end

Zcib_org = CIB3D_org*3/1536;
Zcob_org = COB3D_org*3/1536;

% Zcib_mod = CIB3D_Mod*3/1536;
% Zcob_mod = COB3D_Mod*3/1536;

%% ********Showing Sphere on surface figure ********************




%%  **********Grid Based Sphere Fit************

filname_sph_cib_org_stats = strcat(OutputFP_Nm,'sph_cib_org_quad_stats.xlsx');
filname_sph_cob_org_stats = strcat(OutputFP_Nm,'sph_cob_org_quad_stats.xlsx');
% filname_sph_cib_mod_stats = strcat(OutputFP_Nm,'sph_cib_mod_quad_stats.xlsx');
% filname_sph_cob_mod_stats = strcat(OutputFP_Nm,'sph_cob_mod_quad_stats.xlsx');


[RGB_sph_cib_org, stats2_sph_cib_org] =  get_quad_Circle_stats_SphericalCurvature_6x6(Zcib_org,x_fovea, y_fovea,filname_sph_cib_org_stats,OpticDiscSide);
[RGB_sph_cob_org, stats2_sph_cob_org] =  get_quad_Circle_stats_SphericalCurvature_6x6(Zcob_org,x_fovea, y_fovea,filname_sph_cob_org_stats,OpticDiscSide);


system('taskkill /F /IM EXCEL.EXE');
% winopen(OutputFP_Nm1)

end

