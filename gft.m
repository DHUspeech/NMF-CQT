function f=gft(y,X)
% 读入语音数据
n = 256; % 帧长数据
inc = 128; % 帧移数据
%     wav_path=filepath+wav_data(i,1).name;
%     wav_name=strrep(wav_data(i,1).name,'_noisy.wav','.wav');
[z,~]=enframe(y,0.5-0.5*cos(2*pi*(1:n)'/(n+1)),inc); % Hanning window
f=X*z'; %gft transformation
end










