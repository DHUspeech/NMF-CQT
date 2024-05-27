clear;
f=16000;
[y1,fs]=audioread('3000_15664_000021_000000.wav');
[y4,fs]=audioread('3000_15664_000021_000000.wav');
[y5,fs]=audioread('3000_15664_000021_000000.wav');
  y1=resample(y1,fs,f);
  y4=resample(y4,fs,f);
  y5=resample(y5,fs,f);
  
  
  moff=pesq(y1, y4, f);
  a=moff;
  mocq=pesq(y1, y5, f);
  b=mocq;