function select_patches()

template_images_pos = cell(0,0);
template_images_neg = cell(0,0);
template_pos_size = zeros(0,0);
template_neg_size = zeros(0,0);

listing = dir('../data/people/train/');

for i = 1 : length(listing)
    if listing(i).bytes == 0 || isequaln(listing(i).name, '.DS_Store') 
        continue;
    else
        im = imread(strcat('../data/people/train/', listing(i).name));
        im = im2double(im);
        im = rgb2gray(im);
        imshow(im);
        for k = 1 : 3
            rect = getrect();
            left = round(rect(1));
            top = round(rect(2));
            width = round(rect(3));
            height = round(rect(4));
            template_pos_size(end+1,:) = [width, height];
            template_images_pos(end+1,1) = cell(1,1);
            template_images_pos{length(template_images_pos)} = im(top:top+height-1, left:left+width-1);
        end
        
    end
end
pos_mean_width = round(mean(template_pos_size(:,1)) / 8) * 8;
pos_mean_height = round(mean(template_pos_size(:,2)) / 8) * 8;
for j = 1 : length(template_images_pos)
    % template_images_pos{j} = resizem(template_images_pos{j},[pos_mean_height,pos_mean_width]);
    template_images_pos{j} = resizem(template_images_pos{j},[128,128]);
end


for i = 1 : length(listing)
    if listing(i).bytes == 0 || isequaln(listing(i).name, '.DS_Store') 
        continue;
    else
        im = imread(strcat('../data/people/train/', listing(i).name));
        im = im2double(im);
        im = rgb2gray(im);
        imshow(im);
        for k = 1 : 20
            rect = getrect();
            left = round(rect(1));
            top = round(rect(2));
            width = round(rect(3));
            height = round(rect(4));
            template_neg_size(end+1,:) = [width, height];
            template_images_neg(end+1,1) = cell(1,1);
            template_images_neg{length(template_images_neg)} = im(top:top+height-1, left:left+width-1);
        end
        
    end
end
neg_mean_width = round(mean(template_neg_size(:,1)) / 8) * 8;
neg_mean_height = round(mean(template_neg_size(:,2)) / 8) * 8;
for j = 1 : length(template_images_neg)
    % template_images_neg{j} = resizem(template_images_neg{j},[neg_mean_height,neg_mean_width]);
    template_images_neg{j} = resizem(template_images_neg{j},[128,128]);
end


save('template_images_pos.mat','template_images_pos')
save('template_images_neg.mat','template_images_neg')


end

