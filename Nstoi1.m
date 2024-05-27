function [d1,d2,d3,d4]=Nstoi1(y1,y4,y5,y6,y7,fs)
         d1=stoi(y1, y4, fs);
         d2=stoi(y1, y5, fs);
         len1=length(y1);
         len6=length(y6);
         len7=length(y7);
         if(len1>len6)
             y1=y1(1:len6,1);
         else
             y6=y6(1:len1,1);
         end
         d3=stoi(y1,y6,fs);
          if(len1>len7)
             y1=y1(1:len7,1);
         else
             y7=y7(1:len1,1);
         end
         d4=stoi(y1,y7,fs);