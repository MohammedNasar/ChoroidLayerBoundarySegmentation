
function imgs = ImagesExtraction(filePath,fileNames,orgPath)
    ptrn = 'image';
    NoF = 500;
    row = 1536;  col = NoF;
    ww = whos('fileNames');
    filTYPE = ww.class;
    if ww.class == 'cell'
        for mn = 1:length(fileNames)
            I = [];
            II = [];
            comp_filename_rawimage1 = strcat(filePath,fileNames{mn});
            fin = fopen(comp_filename_rawimage1,'r');   
            fileNames2 = fileNames{mn};
           
            for i = 1:NoF
                Extracting_Writing_InpImages = i
                I(:,:,i) = fread(fin, [col row],'uint8=>uint8'); %// Red channel
                filenameI = strcat(orgPath,ptrn,num2str(i,'%04.f'),'.jpg');
                II = uint8(rot90(I(:,:,i)',2));
                imgs(:,:,i) = II;
                imwrite(II,filenameI);
            end
            fclose(fin);
        end
    else
        I = [];
        II = [];
        comp_filename_rawimage1 = strcat(filePath,fileNames);
        fin = fopen(comp_filename_rawimage1,'r');    
%         orgPath = strcat(filePath,fileNames(1:end-4),'\Org\');
%         mkdir(orgPath);
        for i=1:NoF   
            Extracting_Writing_InpImages = i
            I(:,:,i) = fread(fin, [col row],'uint8=>uint8'); %// Red channel
            filenameI = strcat(orgPath,ptrn,num2str(i,'%04.f'),'.jpg');
            II = uint8(rot90(I(:,:,i)',2));
            imgs(:,:,i) = II;
            imwrite(II,filenameI);
        end
        fclose(fin);
    end

