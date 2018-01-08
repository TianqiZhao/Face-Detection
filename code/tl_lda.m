function template = tl_lda(template_images_pos, template_images_neg, lambda)
% input:
%     template_images_pos - a cell array, each one contains [128 x 128] matrix
%     template_images_neg - a cell array, each one contains [128 x 128] matrix
%     lambda - parameter for lda
% output:
%     template - [16 x 16 x 9] matrix 

mean_neg = tl_pos(template_images_neg);
mean_pos = tl_pos(template_images_pos);
mean_diff = mean_pos - mean_neg;

sigma_neg = zeros(size(mean_neg));
template = zeros(size(mean_neg));

ohist = cell(length(template_images_neg), 1);
for j = 1:length(template_images_neg)
    ohist{j} = hog(template_images_neg{j});
end

for i = 1:size(mean_pos,3)
    covar = zeros(size(mean_pos,1),size(mean_pos,2));
    for j = 1:length(template_images_neg)
        tmp = ohist{j}(:,:,i) - mean_neg(:,:,i);
        covar = covar + tmp * tmp';
    end
    sigma_neg(:,:,i) = covar ./ length(template_images_neg) + lambda * eye(size(covar));
    template(:,:,i) = sigma_neg(:,:,i) \ mean_diff(:,:,i);
end

end