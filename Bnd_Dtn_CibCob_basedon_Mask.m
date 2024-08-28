function [cib,cob] = Bnd_Dtn_CibCob_basedon_Mask(mask)
sy = size(mask,2);
clear i;
indx_i = [];
indx_o = [];
cib0 = nan(1,sy);
cob0 = nan(1,sy);
for i = 1:sy
    clear indx;
    indx = find(mask(:,i)==255);
    if  ~isempty(indx)
       cib0(i) = indx(1);
       indx_i = [indx_i i];
       cob0(i) = indx(end);
       indx_o = [indx_o i];
    end
end

cib = bnd_int_sm(sy,indx_i,cib0);
cob = bnd_int_sm(sy,indx_o,cob0);
%     y2 = 1:sy;
% % % % % clear xt_i yt_i xt1_i x2_i bnd;
% % % % % yt_i = min(indx_i):max(indx_i);
% % % % % xt_i = interp1(indx_i,cib0(indx_i),yt_i,'linear');
% % % % % xt1_i = round(smooth(yt_i,xt_i,.1,'rloess'));
% % % % % 
% % % % % % if min(indx_i) ~= 1 || max(indx_i) ~=sy
% % % % % x2_i = zeros(sy,1,'double');
% % % % % x2_i(1:min(indx_i)-1) = xt1_i(1);
% % % % % x2_i(yt_i) = xt1_i;
% % % % % x2_i(max(indx_i)+1:end) = xt1_i(end);
% % % % % cib = x2_i;
% else
%     cib = xt1_i;
% end


% % clear xt_o yt_o xt1_o x2_o bnd;
% % yt_o = min(indx_o):max(indx_o);
% % xt_o = interp1(indx_o,cob0(indx_o),yt_o,'linear');
% % xt1_o = round(smooth(yt_o,xt_o,.1,'rloess'));
% % 
% % % if min(indx_o) ~= 1 || max(indx_o) ~=sy
% % x2_o = zeros(sy,1,'double');
% % x2_o(1:min(indx_o)-1) = xt1_o(1);
% % x2_o(yt_o) = xt1_o;
% % x2_o(max(indx_o)+1:end) = xt1_o(end);
% % cob = x2_o;
% else
%     cob = xt1_o;
% end


