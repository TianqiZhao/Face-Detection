function ohist = hog(I)
%
% compute orientation histograms over 8x8 blocks of pixels
% orientations are binned into 9 possible bins
%
% I : grayscale image of dimension HxW
% ohist : orinetation histograms for each block. ohist is of dimension (H/8)x(W/8)x9
% TODO

% normalize the histogram so that sum over orientation bins is 1 for each block
%   NOTE: Don't divide by 0! If there are no edges in a block (ie. this counts sums to 0 for the block) then just leave all the values 0. 
% TODO
    [H, W] = size(I);
    H_num = ceil(H / 8);
    W_num = ceil(W / 8);
    [mag,ori] = mygradient(I);
    thresh = 0.1 * max(mag(:));
    ori_patch = im2col(ori, [8,8], 'distinct');
    mag_patch = im2col(mag, [8,8], 'distinct');
    bins = linspace(-pi/2, pi/2, 10);
    ohist = zeros(size(ori_patch, 2), 9);
    for i = 1 : size(ori_patch, 2)
        for j = 1 : 9
            ohist(i,j) = sum(mag_patch(:,i) >= thresh & ori_patch(:,i) >= bins(j) & ori_patch(:,i) < bins(j+1));
        end
    end
    tmp = repmat(sum(ohist,2),1,9);
    ohist = ohist ./ max(1, max(0, tmp));
    ohist = reshape(ohist, H_num, W_num, 9);
end



