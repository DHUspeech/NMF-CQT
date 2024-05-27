%%%% JDNMF %%%%
outputPath = 'Denoised_female_speech/fft-gft2';
if ~exist(outputPath, 'dir')
    mkdir(outputPath);
end


currentFolder = pwd;
addpath(genpath(currentFolder))
warning off;
clear;close all;home
tic;
pack;
L=1;
alg=2;   % alg=1 is optimized with mse criterion, alg=2 is optimized with KL-divergernce criterion
number_basesS=150;    %  number of bases
number_basesF=150;
number_basesN=50;
fs=24000;
ff=16000;
B=50;
% Len_linear=431;
qz=15;
iter_num=25;          % iteration number for training JDNMF
iter_num2=25;         % iteration number for conversion

%%%%%%%%%%  training
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%-Noise-%%%%%%%%%%%%%
disp('training female...')
waveDir='Female_speech524_training/';
GspeakerData = dir(waveDir);
GspeakerData(1:2) = [];
GspeakerNum=length(GspeakerData);%speakerNum:人数；
Fg1=[];
Fg2=[];
Fg3=[];
Fg1L=[];
for i=1:GspeakerNum
    [tp,f]=audioread(['Female_speech524_training/' GspeakerData(i,1).name]); %TargetWavFile{i} is the wav file.
    tp=tp(:,1);
    y=resample(tp,fs,f);
    [Xcq]=BuildCQTspectrogram(y,fs, B, fs/2, fs/2^10, 16, qz); 
    [absSp2,phaseSp,Spframes,resph]=Buildspectrogram(y,fs);
    [U,angle_gft,absSp3,phse_spectrum,Nframes,resdiuePoint]=fft_gft(y,fs);
    absSp1=abs(Xcq.c);
    Fg1=[Fg1,absSp1];
    Fg2=[Fg2,absSp2];
    Fg3=[Fg3,absSp3];

end
Fg1=multiframes2(Fg1);
rr=size(absSp2,1);
all_r=floor(rr/2)+1;
Fg2=Fg2(1:all_r,:);  
Fg3=Fg3(1:all_r,:);  
Fg2=multiframes2(Fg2);
Fg3=multiframes2(Fg3);
save('Fg3_fftgft.mat','Fg3');
%%%%%%%%%%%%%%%%-NMF-%%%%%%%%%%%%%%%%

MOSs1A=zeros(18,7);MOSf1A=zeros(18,7);
stoiS1A=zeros(18,7);stoiF1A=zeros(18,7);


disp('training male SNMF...') 
%   [Wg1,Hg1,Wg2,Hg2,Wg3,Hg3]=sparse_NMF(Sg1,Sg2,Sg3,number_basesS,iter_num,alg); %% 如果要用NMF来更新矩阵就选择NMF这个函数
% %   save Wg1 Hg1 Wg2 Hg2
disp('training female SNMF...')
 [Wfg1,Hfg1,Wfg2,Hfg2,Wfg3,Hfg3]=sparse_NMF(Fg1,Fg2,Fg3,number_basesF,iter_num,alg);
%  save Wfg1 Hfg1 Wfg2 Hfg2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%-Noise-%%%%%%%%%%%%%

waveDir='Female_speech524_test/';
GTspeakerData = dir(waveDir);
GTspeakerData(1:2) = [];
GTspeakerNum=length(GTspeakerData);%speakerNum:人数；

disp('training noise...')
waveDir='Noise/';
NoiseData = dir(waveDir);
NoiseData(1:2) = [];
NoiseNum=length(NoiseData);%speakerNum:人数；
MOSs=[];MOSf=[];stoiS=[];stoiF=[];
for i=1:NoiseNum
    Ss1=[];
    Ss2=[];
    Ss3=[];
    [tp,f]=audioread(['Noise/' NoiseData(i,1).name]); 
     y=resample(tp,fs,f);
    [Xcq]=BuildCQTspectrogram(y,fs, B, fs/2, fs/2^10, 16, qz); 
    [absSp2,phaseSp,Spframes,resph]=Buildspectrogram(y,fs);
%     abs3=gft(y,X);
%     absSp3=abs(abs3);
    [U,angle_gft,absSp3,phse_spectrum,Nframes,resdiuePoint]=fft_gft(y,fs);
    absSp1=abs(Xcq.c);
    Ss1=[Ss1,absSp1];
    Ss2=[Ss2,absSp2];
    Ss3=[Ss3,absSp3];
    Ss1=multiframes2(Ss1); % Section III-C in the paper for Contextual Information
    Ss2=Ss2(1:all_r,:); 
    Ss3=Ss3(1:all_r,:);
    Ss2=multiframes2(Ss2);
    Ss3=multiframes2(Ss3);
%     Ss3_name=strcat('Ss3',NoiseData(i,1).name);
%     Ss3_name=Ss3;
%     mat_name=strcat(num2str(i),'_','Ss3_fftgft.mat');
%     save(mat_name,'Ss3');
%%%%%%%%%%%%%%%%%%%%% NMF %%%%%%%%%%%%%%%%%%%%%%%
disp('training noise SNMF...')
   %%%%%%%%%%%%%%%%%%%%%%male%%%%%%%%%%%%%%%%
   [Ws1,Hs1,Ws2,Hs2,Ws3,Hs3]=NMF(Ss1,Ss2,Ss3,number_basesN,iter_num,alg);
%     Wg2=Wg2(1:all_r*5,:);Ws2=Ws2(1:all_r*5,:); 
%    [W11,H11]=align(Wg1,Hg1,Ws1,Hs1);
%    [W21,H21]=align(Wg2,Hg2,Ws2,Hs2);
%    [W31,H31]=align(Wg3,Hg3,Ws3,Hs3);
   %%%%%%%%%%%%%%%%female%%%%%%%%%%%
   Wfg2=Wfg2(1:all_r*5,:);Ws2=Ws2(1:all_r*5,:); 
   [W12,H12]=align(Wfg1,Hfg1,Ws1,Hs1);
   [W22,H22]=align(Wfg2,Hfg2,Ws2,Hs2);
   [W32,H32]=align(Wfg3,Hfg3,Ws3,Hs3);

% imagesc(flipud(log(Wg)))   % Show the learned joint-dictionary
%%%%%%%%%%%%%%%%%%%%%%%%%%%% Denoise %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ms=zeros(7,2);Mf=zeros(7,2);
% Ts=zeros(7,2);Tf=zeros(7,2);
Ms1=zeros(18,1);
Ts1=zeros(18,1);

% for tt=1:43

Ms=[];
Ts=[];
snr=[-5,0,5,10,15,20];
Mf1=[];
Tf1=[];
for ss=1:6
    COUNT=0;
    Mf=zeros(3,1);
    Tf=zeros(3,1);
    for tt=1:35
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%_male_%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%_Female_%%%%%%%%%%
disp('denoising Female...')
    [y0,f]=audioread(['Female_speech524_test/' GTspeakerData(tt,1).name]);
    y0=y0(:,1);
     y1=resample(y0,fs,f);
     y=add_noisem(y1,['Noise/' NoiseData(i,1).name],snr(:,ss),fs);    
     [y4,y5,y6]=Denoising_fft_gft(y,Wfg1,Wfg2,Wfg3,W12,W22,W32,H12,H22,H32,all_r,fs,B,qz,alg,iter_num2,number_basesF);
     yr1=resample(y0,ff,f);
     yr4=resample(y4,ff,fs);
     yr5=resample(y5,ff,fs);
     yr6=resample(y6,ff,fs);
     noise_hz=NoiseData(i,1).name;
     noise_hz=noise_hz(1:end-4);
     str_ss=num2str(ss);
     fft_name=strcat('fft_',str_ss,noise_hz,'_',GTspeakerData(tt,1).name);
     cqt_name=strcat('cqt_',str_ss,noise_hz,'_',GTspeakerData(tt,1).name);
     gft_name=strcat('gft_',str_ss,noise_hz,'_',GTspeakerData(tt,1).name);
     path=strcat('Denoised_female_speech/','fft-gft2/');
     audiowrite([path GTspeakerData(tt,1).name],y,16000);
     audiowrite([path  fft_name],yr4,16000);
     audiowrite([path  cqt_name],yr5,16000);
     audiowrite([path  gft_name],yr6,16000);
%      [a,b]=NMOS(yr1,yr4,yr5,ff);
      try
        a=pesq(yr1, yr4, ff);
        b=pesq(yr1, yr5, ff);
        c=pesq(yr1,yr6,ff);
% %      Mf(:,ss)=[a,b]';
        VM=[a;b;c];
        COUNT=COUNT+1;
      catch
          continue;
      end
     [d1,d2,d3]=Nstoi(y1,y4,y5,y6,fs);
%      d3=d2-d1;
%      Tf(:,ss)=[d1,d2]';
      VF=[d1;d2;d3];
      Mf=Mf+VM;
      Tf=Tf+VF;
    end
%      Ms1=Ms1+Ms;   
     Mf1=[Mf1;Mf/COUNT];
%      Ts1=Ts1+Ts;   
     Tf1=[Tf1;Tf/COUNT];
end
% %      Msm=Ms1/48;   
%      Mfm=Mf1/43;
% %      Tsm=Ts1/48;   
%      Tfm=Tf1/43;
     
%      MOSs=[MOSs Msm];
     MOSf=[MOSf Mf1];
%      stoiS=[stoiS Tsm];
     stoiF=[stoiF Tf1];
end
% save('mosM.mat','MOSs');
% save('stoM.mat','stoiS');
save('mosF_fft-gft.mat','MOSf');
save('stoF_fft-gft.mat','stoiF');   