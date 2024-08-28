
function  scImg = ShadowRemoval(img)
    rawImg = (double(img)/255).^4;  % transforming gray-scale image into original raw scale as initially captured in OCT machine.
    scImg0 = rawImg./(flipud(cumtrapz(flipud(rawImg)))); % Girard's method for removing shadows in the deep layers
    scImg = uint8(255*(scImg0).^(1/4));   %  transforming raw format image back to gray-scale for visualization
end
