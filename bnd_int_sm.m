
function  bnd = bnd_int_sm(sy,indx,bnd0)
Yt2 = min(indx):max(indx);
Xt2 = interp1(indx,bnd0(indx),Yt2,'linear');
% Xt22 = Xt2;
Xt22 = round(smooth(Yt2,Xt2,.2,'rloess'));
bnd = zeros(sy,1,'double');
bnd(1:min(indx)-1) = Xt22(1);
bnd(Yt2) = Xt22;
bnd(max(indx)+1:end) = Xt22(end);  
