writerObj = VideoWriter('../data/frames/video.avi');
writerObj.FrameRate=25;
open(writerObj);
for K = 1:227
  K
  filename = sprintf('../data/frames/frame_%d.png', K);
  thisimage = imread(filename);
  writeVideo(writerObj, thisimage);
end
close(writerObj);