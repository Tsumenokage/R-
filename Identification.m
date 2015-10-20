close all;
clear all;
load('incrustation.mat')

Video=VideoReader('vid_in.mp4');
numFrames = get(Video,'NumberOfFrames');
frame = 1;

for i=frame:numFrame
   CurrentPic=read(Video,i);
    
    
end