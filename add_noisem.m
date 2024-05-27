function [Y,NOISE] = add_noisem(X,filepath_name,SNR,fs)
% add_noisem add determinated noise to a signal.
% X is signal, and its sample frequency is fs;
% filepath_name is NOISE's path and name, and the SNR is signal to noise ratio in dB.
[wavin,fs1]=audioread(filepath_name);
wavin1=wavin;
if fs1~=fs
    wavin1=resample(wavin,fs,fs1);
end

nx=size(X,1);
nin=size(wavin,1);
if nin<nx
    nx=nin;
end
NOISE=wavin1(1:nx);
NOISE=NOISE-mean(NOISE);
signal_power = 1/nx*sum(X.*X);
noise_variance = signal_power / ( 10^(SNR/10) );
NOISE=sqrt(noise_variance)/std(NOISE)*NOISE;
Y=X+NOISE;