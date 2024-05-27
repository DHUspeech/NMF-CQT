clc;
currentFolder = pwd;
addpath(genpath(currentFolder))
warning off;
clear;close all;home
tic;
pack;
waveDir='Male_speech524_test/';
GTspeakerData = dir(waveDir);
GTspeakerData(1:2) = [];
GTspeakerNum=length(GTspeakerData);%speakerNum:人数；
tt=1;
fs=16000;
waveDir_noise='Noise/';
NoiseData = dir(waveDir_noise);
NoiseData(1:2) = [];
NoiseNum=length(NoiseData);%speakerNum:人数；
i=1;
snr=[-5,0,5,10];
for tt=1:GTspeakerNum
    [y0,f]=audioread([waveDir GTspeakerData(tt,1).name]);
    y0=y0(:,1);
    y1=resample(y0,fs,f);
    for i=1:NoiseNum
        for ss=1:6
        y=add_noisem(y1,['Noise/' NoiseData(i,1).name],snr(:,ss),fs);
        audiowrite(['noisy/',NoiseData(i,1).name,'_',num2str(snr(:,s)),'_',GTspeakerData(tt,1).name],y,16000);
        end
    end
end