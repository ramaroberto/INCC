function [imgs_sub, imgs_sec, imgs_ids] = getImgsPaths(base_dir)
    dirs = dir(base_dir);
    imgs_sub = cell(size(dirs,1)-2, 1);
    imgs_sec = cell(size(dirs,1)-2, 3);
    imgs_ids = cell(size(dirs,1)-2, 1);

    for i=3:size(dirs,1)
        dir_name = dirs(i).name;
        imgs_ids{i-2} = dir_name;
        files = dir(strcat('imgs\',dir_name));
        c = 1;
        for j=3:size(files,1)
            file_name = files(j).name;
            if strcmp(file_name(1), 's') && strcmp(file_name(2), '.')
                imgs_sub{i-2} = strcat('imgs\',dir_name,'\',file_name);
            else
                imgs_sec{i-2,c} = strcat('imgs\',dir_name,'\',file_name);
                c = c + 1;
            end
        end
    end
end