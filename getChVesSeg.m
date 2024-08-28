
function chStrip = getChVesSeg(phn_img,cib1,cob1,d1)
chStrip = zeros([d1,length(cib1)]);
for indx = 1:size(phn_img,2)
    clear ind_i ind_o;
    ind_i = cib1(indx);
    ind_o = cob1(indx);   
    if ind_i < 1
        ind_i = 2;
    end
    if ind_o < 2
        ind_o = 3;
    end
    chStrip(1:ind_o-ind_i,indx) = phn_img(ind_i+1:ind_o,indx);
end




