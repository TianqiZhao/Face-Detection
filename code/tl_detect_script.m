function tl_detect_script

load('template_images_pos.mat');
load('template_images_neg.mat');
rgb = imread('../data/people/train/people10.jpg');
Itest = rgb2gray(im2double(rgb));
%Itest = imresize(Itest,2);
ndet = 2;
lambda = 0.01;

% template = tl_pos(template_images_pos);
% [x,y,score] = detect(Itest,template,ndet);
% draw_detection(Itest, ndet, x, y, ones(length(x),1));
% 
% 
% template = tl_pos_neg(template_images_pos, template_images_neg);
% [x,y,score] = detect(Itest,template,ndet);
% draw_detection(Itest, ndet, x, y, ones(length(x),1));

template = tl_lda(template_images_pos, template_images_neg, lambda);
% [x,y,score] = detect(Itest,template,ndet);
% draw_detection(rgb, Itest, ndet, x, y, ones(length(x),1));

det_res = multiscale_detect(Itest, template, ndet);
draw_detection(rgb, Itest, ndet, det_res(:,1), det_res(:,2), det_res(:,3));

end

function draw_detection(rgb, Itest, ndet, x, y, scale)
% please complete this function to show the detection results
    figure;
    imshow(rgb);
    for i = 1 : length(x)
        half_edge = round(64/scale(i));
        edge = half_edge * 2;
        % [(i/ndet) ((ndet-i)/ndet)  0]
        rectangle('Position',[x(i)-half_edge y(i)-half_edge edge edge],'EdgeColor', 'g', 'LineWidth',4,'Curvature',[0.3 0.3]);
    end
end