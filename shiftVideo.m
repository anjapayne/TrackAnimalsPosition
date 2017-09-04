function video = shiftVideo(shiftedIndex); 
% Script to shift the video frames so that they align with the ephys data
% Written on September 2, 2017
% Last modified by Anja Payne

% Load the index data that was provided by Kitchen Sync
fileList = dir('*index.txt'); 
video = textread(shiftedIndex);

end