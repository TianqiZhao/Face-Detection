
function [x,y,score] = detect(I,template,ndet)
%
% return top ndet detections found by applying template to the given image.
%   x,y should contain the coordinates of the detections in the image
%   score should contain the scores of the detections
%

% Initialization and parameter definition

% Size of each image block
BlockSize = 8;

% Calculate the histogram of gradient orientation feature map
ohist = hog(I);

% Number of feature types (orientation bins)
NumOfFeatureTypes = size(ohist, 3);

% Size of the feature map
[MapRows,MapCols,~] = size(ohist);

% Overlap threshold (distance of blocks to be considered non-overlapping)
OverlapRows = round(size(template,1) / 2 * BlockSize * sqrt(2));
OverlapCols = round(size(template,2) / 2 * BlockSize * sqrt(2));

% Perform cross-correlation of the template with the feature map

% Allocate space for the initial response map (heat map)
heatmap = zeros(MapRows, MapCols);

% MATLAB does not support cross correlation output of the same size as one
% of the inputs, therefore it is easier to use conv2 function with one of
% the inputs (the smaller) rotated for 180 degrees instead of xcorr2

% Rotate the template for 180 degrees: 
template_rot = rot90(template, 2);

% Calculate and sum the responses (perform cross-correlation)
for i = 1 : NumOfFeatureTypes
    heatmap = heatmap + conv2(ohist(:, :, i), template_rot(:, :, i), 'same');
end

% Find the highest correlation points in the maps; i.e. find the 
% coordinates and score of the detections in the image

% Initialize the coordinates and score of the detections
% It is possible that the number of detections is less than intended, so it
% is not appropriate to pre-allocate the space for these output variables.
score = [];
x = [];
y = [];

% Sort responses in descending order
[~, heatmapSortedInds] = sort(heatmap(:), 'descend');

% Find the coordinates and score of the detections in the image
for i = 1 : length(heatmapSortedInds)

    % Calculate the row and col of the index in the image coordinates
    [blkrow, blkcol] = ind2sub(size(heatmap), heatmapSortedInds(i));
    imgrow = BlockSize * blkrow - BlockSize / 2;
    imgcol = BlockSize * blkcol - BlockSize / 2;

    % Add current detection if there is no spatial overlap with the 
    % previous detections (the detections must be at least a bounding box
    % apart)
    if nnz(abs(x - imgcol) < OverlapCols & abs(y - imgrow) < OverlapRows) == 0
        score = [score; heatmap(blkrow, blkcol)];
        x = [x; imgcol];
        y = [y; imgrow];

        % Check to see if we reached the desired number of detections
        if length(x) == ndet
            break;
        end
    end
    
end
