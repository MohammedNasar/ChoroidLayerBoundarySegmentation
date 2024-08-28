function YY = concomp(Y0)
CC1 = bwconncomp(Y0); % Y is the 3D array
YY = zeros(size(Y0));
numPixels = cellfun(@numel,CC1.PixelIdxList);
[~,idx] = max(numPixels);
% for ind = 1:length(idx)
   YY(CC1.PixelIdxList{idx}) = 1;
% end