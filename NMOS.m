function [a,b]=NMOS(y1,y4,y5,fs)
% Tw = 32; % analysis frame duration (ms) 
% Ts = Tw/8; % analysis frame shift (ms)
% lambda = 3.74; % scale of compensation 
  moff=pesq(y1, y4, fs);
  a=moff;
  mocq=pesq(y1, y5, fs);
  b=mocq;
% [ res1 ]=pesq_mex( y1, y4, fs, 'narrowband');
% a= res1;
% [ res2 ]=pesq_mex( y1, y5, fs, 'narrowband');
% b=res2;
%     mosf=test_psc(y1,y4,fs);
%     a=mosf.noisy;
%     mosc=test_psc(y1,y5,fs);
%     b=mosc.noisy;
%     mosf=test_psc(y1,y6,fs);
%     c=mosf.noisy;
%     mosc=test_psc(y1,y7,fs);
%     d=mosc.noisy;
%     mosc=test_psc(y1,y8,fs);
%     e=mosc.noisy;
%     mosc=test_psc(y1,y9,fs);
%     f=mosc.noisy;
%     mosc=test_psc(y1,y10,fs);
%     g=mosc.noisy;