% warning off;
% clear;close all;home
% tic;
% fs=8000;
% Lf=4000;
% [y0,f]=audioread('S0176.wav');
%      y1=resample(y0,fs,f);
%      [y0,f]=audioread('D3.wav');
%      y2=resample(y0,fs,f);
%      [y0,f]=audioread('D4.wav');
%      y3=resample(y0,fs,f);
%     [snr_Lfs,snr_ts,snr_fs,mses]=computetSNR(y1,y2,fs,Lf);
%     [snr_Lfc,snr_tc,snr_fc,msec]=computetSNR(y1,y3,fs,Lf);
function [snr_f]=computeSNR(y1,y2,fs,Lf)
[X,freq1]=centeredFFT(y1,fs);
[Y,freq2]=centeredFFT(y2,fs);
A1=find(freq1<Lf); A2=find(freq1>-Lf); 
a1=A1(end); a2=A2(1);
% x=freq1(:,a2:a1);
XL=X(a2:a1,:);
B1=find(freq2<Lf); B2=find(freq2>-Lf);
b1=B1(end); b2=B2(1);
% y=freq2(:,b2:b1);
YL=Y(b2:b1,:);
SL=YL-XL;
S=Y-X;
N=length(XL);
E1=norm(XL).^2/N; E2=norm(SL).^2/N;
E3=norm(X).^2/N;  E4=norm(S).^2/N;
% snr_Lf=10*log10(E1/E2);
snr_f=10*log10(E3/E4);
% [snr_t,mse] = calSNR(y1,y2) ;
%remember to take the abs of YfreqDomain to get the magnitude!
end
function [X,freq]=centeredFFT(x,Fs)
%this is a custom function that helps in plotting the two-sided spectrum
%x is the signal that is to be transformed
%Fs is the sampling rate
N=length(x);
%this part of the code generates that frequency axis
if mod(N,2)==0
k=-N/2:N/2-1; % N even
else
k=-(N-1)/2:(N-1)/2; % N odd
end
T=N/Fs;
freq=k/T; %the frequency axis
%takes the fft of the signal, and adjusts the amplitude accordingly
X=fft(x)/N; % normalize the data
X=fftshift(X); %shifts the fft data so that it is centered
end

     