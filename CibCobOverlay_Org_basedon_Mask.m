function [cib2, cob2, cib3, cob3] = CibCobOverlay_Org_basedon_Mask(maskPath)
mlst = dir(strcat(maskPath,'*.jpg'));
for i = 1:length(mlst)
    reading_boundary = i
    clear cib0 cob0 mask;
     mask = imread(strcat(maskPath,mlst(i).name));
     try
        [cib0, cob0] = Bnd_Dtn_CibCob_basedon_Mask(mask);
        cib(:,i) = cib0;
        cob(:,i) = cob0;
     catch ME
        fprintf('Failed to process scan no %d: %s\n',i, ME.message);
        continue;
    end
end

cib2 = round(6*imresize(cib,[500 500]));
cob2 = round(6*imresize(cob,[500 500]));

cib3 = round(6*imresize(smoothdata(smoothdata(cib,2,'rloess'),1,'rloess'),[500 500]));
cob3 = round(6*imresize(smoothdata(smoothdata(cob,2,'rloess'),1,'rloess'),[500 500]));



% save
