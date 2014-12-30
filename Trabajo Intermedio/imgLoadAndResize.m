function [img] = imgLoadAndResize(path, bounds, img)    
    if nargin < 3
        [~,~,ext] = fileparts(path);
        if strcmp(ext(2:end), 'png')
            img = imread(path, ext(2:end),'BackgroundColor',[1,1,1]);
        else
            img = imread(path, ext(2:end));
        end
    end
    if nargin >= 2
        max_width = bounds(1);
        max_height = bounds(2);
        scale = 1;
        if size(img,1) > max_width
            scale = max_width/size(img,1);
        end
        if size(img,2) > max_height
            nscale = max_height/size(img,2);
            if nscale < scale
                scale = nscale;
            end
        end

        if scale < 1
            img = imresize(img, scale);
        end
    end
end