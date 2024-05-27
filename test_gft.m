clc;
clear;
matrix=eye(256,256);
disp('training female...')
waveDir='Female_speech524_training/';
GspeakerData = dir(waveDir);
GspeakerData(1:2) = [];
GspeakerNum=length(GspeakerData);%speakerNum:人数；
fs=24000;
for i=1:GspeakerNum
    [tp,f]=audioread(['Female_speech524_training/' GspeakerData(i,1).name]); %TargetWavFile{i} is the wav file.
    tp=tp(:,1);
    y=resample(tp,fs,f);
    f=gft(y,matrix);
    speech=igft(matrix,f);
    gft_name=strcat('gft_',GspeakerData(i,1).name);
    audiowrite(['Denoised_female_speech/only_gft/'  gft_name],speech,16000);
end