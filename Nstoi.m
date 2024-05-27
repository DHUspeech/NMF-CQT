function [d1,d2,d3]=Nstoi(y1,y4,y5,y6,fs)
         d1=stoi(y1, y4, fs);
         d2=stoi(y1, y5, fs);
         len1=length(y1);
         len6=length(y6);
         if(len1>len6)
             y1=y1(1:len6,1);
         else
             y6=y6(1:len1,1);
         end
         
         d3=stoi(y1,y6,fs);
%          d3=stoi(y1, y6, fs);
%          d4=stoi(y1, y7, fs);
%          d5=stoi(y1, y8, fs);
%          d6=stoi(y1, y9, fs);
%          d7=stoi(y1, y10, fs);