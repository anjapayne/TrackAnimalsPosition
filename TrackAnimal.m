function pos = TrackAnimal(video, shiftIndex)
% Script to calculate the animal's position from the video. This script
% also shifts the video using the output from KitchenSync so that it is
% aligned to the electrophysiology data. 
% Written September 4, 2017
% Last modified by Anja Payne

tic

% Shift the video data using index obtained from KitchenSync so that it
% matches the ephys data
newIndex = shiftVideo(shiftIndex);
newIndex = newIndex(1:333:end); 

% Read in video and calculate the total number of frames to iterate over
v = VideoReader(video);
num_frames = floor(v.FrameRate*v.Duration)
count_frames = length(newIndex(newIndex>0))

% For each frame, find the brightest pixel (should be the LED attached to
% headstage) and save the x and y position. 
skip_by = 1; 
x_pos = NaN(1, floor(count_frames/skip_by)); 
y_pos = NaN(1, floor(count_frames/skip_by)); 

for i = 1:skip_by:num_frames;
    i
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
    
    % Update the display window with the progress every 500 frames
    if rem(i, 500) == 0;
       disp(['Calculating position for frame ', num2str(i), ' of ' num2str(num_frames)]); 
    end
    
	% Find the maximum
    [max_y, max_x] = find(frame_red == 255);
    
    % Choose the middle value
    index_row    = max_x(ceil(length(max_x)/2)); 
    index_column = max_y(ceil(length(max_y)/2));
    
    x_pos(i) = index_row;
    y_pos(i) = index_column;
     
    %{
    figure(1);
    hold on;
    imagesc(frame);
    scatter(index_row, index_column, 'xr');
    %}
end

toc

pos = [x_pos; 
       y_pos];

filename = video(1:end-4); 
filename = [filename '.mat'];
save(filename, 'pos'); 
