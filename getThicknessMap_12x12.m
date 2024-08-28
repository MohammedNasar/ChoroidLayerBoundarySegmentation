% ChTopo_Oneshot
function getThicknessMap_12x12(x_fovea, y_fovea,cib_3Dsm, cob_3Dsm, OutputFP_Nm, OpticDiscSide)

system('taskkill /F /IM EXCEL.EXE');

cib = imresize(flipud(cib_3Dsm'),[1024 1024],"bilinear");
cob = imresize(flipud(cob_3Dsm'),[1024 1024],"bilinear");


ThicknessMap = cob(:,2:end-1)-cib(:,2:end-1);
Excel_ThicknessStats = strcat(OutputFP_Nm,'Thickness_Stats.xlsx');
[RGB_Thickness, stats3_cib_thicknes] =  get_quad_Circle_stats_Thickness(ThicknessMap,x_fovea, y_fovea,Excel_ThicknessStats,OpticDiscSide);
filename_RGB_ThicknessMap = strcat(OutputFP_Nm,'Thickness.jpg');
imwrite(RGB_Thickness,filename_RGB_ThicknessMap);
% handles.RGB_Thickness=RGB_Thickness;

system('taskkill /F /IM EXCEL.EXE');
% winopen(OutputFP_Nm1)
end

