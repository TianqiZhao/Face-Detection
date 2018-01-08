function [mag,ori] = mygradient(I)
%
% compute image gradient magnitude and orientation at each pixel
%
    filter = [-1, 0, 1];
    grad_x = imfilter(I, filter, 'replicate', 'same');
    grad_y = imfilter(I, filter', 'replicate', 'same');
    
    mag = sqrt(grad_x.^2 + grad_y.^2);
    ori = atan2(grad_y, grad_x);
    ori = ori + pi * (ori < -pi/2) + (-pi) * (ori > pi/2);

end


