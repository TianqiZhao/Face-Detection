function template = tl_pos_neg(template_images_pos, template_images_neg)
% input:
%     template_images_pos - a cell array, each one contains [128 x 128] matrix
%     template_images_neg - a cell array, each one contains [128 x 128] matrix
% output:
%     template - [16 x 16 x 9] matrix 

tem_size = length(template_images_pos);
ohist = zeros(16,16,9,tem_size);
for i = 1 :tem_size
    ohist(:,:,:,i) = hog(template_images_pos{i});
end
template_pos = mean(ohist,4);

tem_size = length(template_images_neg);
ohist = zeros(16,16,9,tem_size);
for i = 1 :tem_size
    ohist(:,:,:,i) = hog(template_images_neg{i});
end
template_neg = mean(ohist,4);

template = template_pos - template_neg;
end