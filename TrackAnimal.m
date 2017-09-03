function pos = TrackAnimal(video, shiftIndex)
% Script to calculate the animal's position from the video. This script
% also shifts the video using the output from KitchenSync so that it is
% aligned to the electrophysiology data. 
% Written September 1, 2017
% Last modified by Anja Payne

tic

% Shift the video data using index obtained from KitchenSync so that it
% matches the ephys data
newIndex = shiftVideo(shiftIndex);

% Read in video and calculate the total number of frames to iterate over
v = VideoReader(video);
num_frames = length(newIndex) %floor(v.FrameRate*v.Duration);
count_frames = length(newIndex(newIndex>0))

% For each frame, find the brightest pixel (should be the LED attached to
% headstage) and save the x and y position. 
skip_by = 1000; 
x_pos = NaN(1, floor(count_frames/skip_by)); 
y_pos = NaN(1, floor(count_frames/skip_by)); 
k = 1; 

for i = 1:skip_by:num_frames;
    % Only track the position for frames that occur after the
    % electrophysiology acquisition starts. 
    if newIndex(i) < 0;
        continue;
    end
    
    frame = read(v,i);
	frame_red = frame(:,:,1);
	[m, n] = size(frame_red); 
    
	% Find the maximum
 	[max_1, index] = max(frame_red); 
	[max_2, index_col] = max(max_1); 
	index_row = index(index_col); 
        
	if max_2 < 200; 
        x_pos(k) = NaN; 
        y_pos(k) = NaN;
    elseif max_2 >= 200; 
        x_pos(k) = index_col;
        y_pos(k) = index_row; 
    end
       
    k = k + 1; 
end

% Interpolate results
% x2interp = linspace(1, length(x_pos), num_frames);
% interpx = interp1(1:length(x_pos), x_pos, x2interp);
% interpy = interp1(1:length(y_pos), y_pos, x2interp);

toc

pos = [x_pos; 
       y_pos];

filename = video(1:end-4); 
filename = [filename '.mat'];
%save(filename, 'pos'); 