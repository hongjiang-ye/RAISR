function croped_filtered_img = cropInvalidPixels(filtered_img, window)
%CROPINVALIDPIXELS crop the invalid pixels of the filtered image
    
    crop_height = floor(size(window, 1) / 2);
    crop_width = floor(size(window, 2) / 2);
    
    [height, width] = size(filtered_img);
    croped_filtered_img = filtered_img(crop_height + 1 : height - crop_height, ...
                            crop_width + 1 : width  - crop_width);

end

