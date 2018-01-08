function template = tl_pos(template_images_pos)
% input:
%     template_images_pos - a cell array, each one contains [128 x 128] matrix
% output:
%     template - [16 x 16 x 9] matrix

tem_size = length(template_images_pos);
ohist = zeros(16,16,9,tem_size);
for i = 1 :tem_size
    ohist(:,:,:,i) = hog(template_images_pos{i});
end
template = mean(ohist,4);
end