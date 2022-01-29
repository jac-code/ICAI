
xyloObj = VideoReader('gol.mp4');
%xyloObj = VideoReader('Gol_Decima.avi');
info = get(xyloObj)


nFrames = xyloObj.NumberOfFrames;
vidHeight = xyloObj.Height;
vidWidth = xyloObj.Width;

vidHeight=floor(vidHeight/16)*16;
vidWidth=floor(vidWidth/16)*16;

% Preallocate movie structure.
mov(1:nFrames) = ...
    struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),...
           'colormap', []);

% Read one frame at a time.
for k = 1 : nFrames
    % mov(k).cdata = read(xyloObj, k);
    X = read(xyloObj, k);
    mov(k).cdata = X(1:vidHeight, 1:vidWidth, :);
end

% Play back the movie once at the video's frame rate.
movie(mov, 1, xyloObj.FrameRate);

save('gol_mp4.mat', 'mov_mp4');