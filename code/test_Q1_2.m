im = imread('../data/test1.jpg');
im = im2double(im);
im = rgb2gray(im);

ohist = hog(im);
V = hogdraw(ohist);
figure;
imagesc(V);