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

for i = 500:500%550 %:skip_by:num_frames;
    % Only track the position for frames that occur after the
    % electrophysiology acquisition starts. 
    if newIndex(i) < 0;
        continue;
    end
    
    frame = read(v,i);
	frame_red = frame(:,:,1);
	
    % If none of the pixels are 255 then the LED was most likely obscured,
    % skip these frames
    if max(max(frame_red)) < 255; 
        continue;
    end
       
	% Find the maximum
    brightest_pixels = find(frame_red == 255)
    % Choose the middle value
    maximum = brightest_pixels(ceil(length(brightest_pixels)/2)) 
    
    % Find the corresponding x and y coordinates for the brightest pixel
    [m, n] = size(frame_red); 
    index_row    = floor(maximum/m);
    test_index = m*n - maximum;
    index_column = floor(test_index/n); 

    figure(1);
    hold on;
    imagesc(frame);
    scatter(index_row, index_column, 'xr');
end


toc

pos = [x_pos; 
       y_pos];

filename = video(1:end-4); 
filename = [filename '.mat'];
save(filename, 'pos'); 