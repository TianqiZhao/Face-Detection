function det_res = multiscale_detect(image, template, ndet)
% input:
%     image - test image.
%     template - [16 x 16x 9] matrix.
%     ndet - the number of return values.
% output:
%      det_res - [ndet x 3] matrix
%                column one is the x coordinate
%                column two is the y coordinate
%                column three is the scale, i.e. 1, 0.7 or 0.49 ..



%     max_dist = size(template,1) / 2 * 8 * sqrt(2);
%     [x,y,sc] = detect(image,template,ndet);
%     det_res = [x,y,ones(length(x),1)];
%     score = sc;
%     
%     scale = 0.7;
%     while true
%         image = imresize(image,scale);
%         if size(image,1) < size(template,1) * 8 || size(image,2) < size(template,2) * 8
%             break;
%         end
%         [x,y,sc] = detect(image,template,ndet);
%         x = x ./ scale;
%         y = y ./ scale;
%         for i = 1 : length(x)
%             det_res(end+1, :) = [x(i), y(i), scale];
%             score(end+1) = sc(i);
%         end
%         
%         scale = scale * 0.7;
%     end
%     
%     [~, ind] = sort(score, 'descend');
%     det_res = det_res(ind, :);
%     tmp = det_res(1,:);
%     for i = 1 : size(det_res,1)
%         if size(tmp,1) == ndet
%             break;
%         end
%         flag = true;
%         for k = 1 : size(tmp,1)
%             if norm([abs(det_res(i,1)-tmp(k,1)), abs(det_res(i,2)-tmp(k,2)) ]) < max_dist
%                 flag = false;
%                 break;
%             end 
%         end
%         if flag
%             tmp(end+1,:) = det_res(i,:);
%         end
%     end
%     det_res = tmp;


%% Initialize the parameters

% Block size and number of feature types
BlockSize = 8;

% Scale factor to rescale image at each layer
ScaleFactor = 0.7;

% Calculate the curent scale (almost 3 times the current scale)
MaxScale = fix(log(3) / log(ScaleFactor));
CurrentScale = ScaleFactor ^ MaxScale;

% Keep the scores
Scores = zeros(ndet, 1);

% Initialize the output
det_res = inf * ones(ndet, 3);

%% Perform the detection at different scales
while true

    % Resize the image for the new level in the pyramid
    image_scaled = imresize(image, CurrentScale);
    
    % Check if the image is larger than the template
    if size(image_scaled, 1) < size(template, 1) * BlockSize || ...
        size(image_scaled, 2) < size(template, 2) * BlockSize
        break;
    end
    
    % Perform the detection at the current scale
    [x, y, score] = detect(image_scaled, template, ndet);
    x = round(x ./ CurrentScale);
    y = round(y ./ CurrentScale);
    
    for i = 1 : length(x)
        % Check for overlaps with previous results
        hasOverlaps = false;
        for j = 1 : ndet
            if abs(x(i) - det_res(j, 1)) * 2 / (size(template, 1) * BlockSize) < ...
              1 / CurrentScale + 1 / det_res(j, 3) &&...
              abs(y(i) - det_res(j, 2)) * 2 / (size(template, 2) * BlockSize) < ...
              1 / CurrentScale + 1 / det_res(j, 3) 
                hasOverlaps = true;
                % Replace the overlapped result if has higher score
                if score(i) > Scores(j)
                    det_res(j, :) = [x(i), y(i), CurrentScale];
                    Scores(j) = score(i);
                end
                break;
            end
        end
        
        % Add the new detection
        if ~hasOverlaps
            % Find the lowest score
            [minScore, minInd] = min(Scores);
            if minScore < score(i)
                det_res(minInd, :) = [x(i), y(i), CurrentScale];
                Scores(minInd) = score(i);
            end
        end
    end
    
    % Update the scale
    CurrentScale = CurrentScale * ScaleFactor;
    
end

%% Sort the results
[Scores, ind] = sort(Scores, 'descend');
det_res = det_res(ind, :);

end
