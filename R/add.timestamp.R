add.timestamp<-function(local.time.zone){
  #Function used to timestamp video files. Command is a wrapper for ffmpeg and assumes Intellidar style filenames
  
  #Load Required Packages
  if("stringr" %in% rownames(installed.packages()) == FALSE) {install.packages("stringr")}
  require(stringr)
  
  #Define some variables
  working.directory<-file.path(path.expand("~"),"Intellidar_Video_Timestamp")
  
  #Set Working Directory to Video Location
  setwd(file.path(working.directory,"Videos"))
  filelist<-list.files(pattern="\\.avi$")
  
  #Show some progress
  pb<- txtProgressBar(min=0,max=length(filelist),style=3)
  setTxtProgressBar(pb,0)  
  
  #Begin Loop
  for(i in 1:length(filelist)){
    #Process filename. Determine the extension and extract the start time.
    new.filename<-gsub(pattern = " ",replacement = "_",x = filelist[i])
    file.rename(from = filelist[i],to = new.filename)
    file.extension<-str_sub(new.filename,-4,-1)
    video.1<-gsub(pattern = file.extension,replacement = "",x = new.filename)
    camera<-str_sub(video.1,-20,-1)
    video.2<-gsub(pattern = camera,replacement = "",x = video.1)
    start.time<-as.POSIXct(x = video.2,format = "%Y-%m-%d_%H-%M-%S",tz="UTC")
    start.time.local<-format(start.time,tz=local.time.zone)
    output.filename<-file.path(working.directory,"Timestamped",paste0(as.character(start.time,format="%Y%m%d_%H%M%S"),"_UTC",camera,"timestamp.mp4"))
    
    #Construct ffmpeg command and pass to system
    ffmpeg.command<-paste0("ffmpeg -i ",new.filename, " -vf \"drawtext=x=8:y=50:box=1:fontcolor=white:boxcolor=black: \\ expansion=strftime:basetime=$(date +%s -d'",as.character(start.time.local),"')000000: \\ text=''\\\r' %Y-%m-%d %H\\\\:%M\\\\:%S ","(",local.time.zone,")", "'\\\r'\" ", output.filename)
    system(ffmpeg.command)
    setTxtProgressBar(pb,i)
  }
}

