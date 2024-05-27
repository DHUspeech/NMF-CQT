function [snr_fs,snr_fc,snr_fl,snr_fcl1,snr_fcl2,snr_fcl3,snr_fcl4]=NSNR(y1,y4,y5,y6,y7,y8,y9,y10,fs,Lf)
    [snr_fs]=computeSNR(y1,y4,fs,Lf);
    [snr_fc]=computeSNR(y1,y5,fs,Lf);
    [snr_fl]=computeSNR(y1,y6,fs,Lf);
    [snr_fcl1]=computeSNR(y1,y7,fs,Lf);
    [snr_fcl2]=computeSNR(y1,y8,fs,Lf);
    [snr_fcl3]=computeSNR(y1,y9,fs,Lf);
    [snr_fcl4]=computeSNR(y1,y10,fs,Lf);