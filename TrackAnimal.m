function position = trackAnimal(video)
%, shiftedIndex)
% Script to calculate the animal's position from the video. This script
% also shifts the video using the output from KitchenSync so that it is
% aligned to the electrophysiology data. 
% Written September 1, 2017
% Last modified by Anja Payne

tic
% Read in video and calculate the total number of frames to iterate over
v = VideoReader(video);
num_frames = floor(v.FrameRate*v.Duration);

% For each frame, find the brightest pixel (should be the LED attached to
% headstage) and save the x and y position. 
skip_by = 1; 
x_pos = NaN(1, floor(num_frames/skip_by)); 
y_pos = NaN(1, floor(num_frames/skip_by)); 
time  = NaN(1, floor(num_frames/skip_by));
i = 1;
%{
for n = 1:skip_by:num_frames;
	frame = read(v,i);
	frame_red = frame(:,:,1);
	[m, n] = size(frame_red); 
    
	% Find the maximum
 	[max_1, index] = max(frame_red); 
	[max_2, index_col] = max(max_1); 
	index_row = index(index_col); 
        
	if max_2 < 200; 
        x_pos(i) = NaN; 
        y_pos(i) = NaN;
    elseif max_2 >= 200; 
        x_pos(i) = index_col;
        y_pos(i) = index_row; 
    end
       
    i = i + 1; 
end

% Interpolate results
% x2interp = linspace(1, length(x_pos), num_frames);
% interpx = interp1(1:length(x_pos), x_pos, x2interp);
% interpy = interp1(1:length(y_pos), y_pos, x2interp);

toc

pos = [x_pos; 
       y_pos];
%}
filename = erase(video, '.mp4'); 
filename = [video '.mat']
   
%save([video '.mat'], 'pos'); 