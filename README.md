# add-timestamp
In videos which are named according to their start time, extract the timestamp and use it to construct an embedded timestamp in the video for analysis. Leverages ffmpeg.

R and teh stringr package are used to pull a timestamp out of a video file file name. Then a system command is constructed and passed to the ffmpeg library which encodes a timecode to the video file. The output is an identical video but with the addition of an advancing timecode within the video itself. 
