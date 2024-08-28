function [bnd1,bnd2] = bndry_detection1(mask)
sy = size(mask,2);
indx = [];
clear bnd01 bnd02;
for colIndx = 1:sy
    clear cIndx;
    cIndx = find(mask(:,colIndx) == 1);
    if  ~isempty(cIndx)
       bnd01(colIndx) = cIndx(1);
       bnd02(colIndx) = cIndx(end);
       indx = [indx colIndx];
    end
end
bnd1 = bnd_int_sm(sy,indx,bnd01);
bnd2 = bnd_int_sm(sy,indx,bnd02);


