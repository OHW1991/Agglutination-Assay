function [img, imgLogical, L, nEvents] = ImageProfiling(path_file, name, threshold)
    % This function reads an image, creates a binary logical image based on a threshold,
    % labels the connected components in the binary image, and counts the number of labeled regions.
    % Inputs:
    %   path_file - Directory path where the image is located
    %   name - Filename of the image to be read
    %   threshold - Intensity threshold for binarization
    % Outputs:
    %   img - The original image read from file
    %   imgLogical - Binary logical image created based on the threshold
    %   L - Labeled image where connected components are assigned unique labels
    %   nEvents - Number of labeled regions in the binary image
    
    % Read the image from file
    img = imread(strcat(path_file, name));
    
    % Create a binary logical image by applying the threshold
    imgLogical = logical(img > threshold);
    
    % Label connected components in the binary image
    % The 8-connectivity is used to label connected regions
    [L, nEvents] = bwlabeln(imgLogical, 8);
    
end % function
