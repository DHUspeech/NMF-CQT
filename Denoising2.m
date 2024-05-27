function [y4,y5,y6,y7]=Denoising2(y,Wg1,Wg2,Wg3,W1,W2,W3,H1,H2,H3,all_r,fs,B,qz,alg,iter_num2,number_bases,X)
     [Xcq]=BuildCQTspectrogram(y,fs, B, fs/2, fs/2^10, 16, qz);
     [absMix2,phaseMix,Mixframes,resdue]=Buildspectrogram(y,fs);

     absSp1=abs(Xcq.c);
     absMix1= absSp1;
     absMix1=multiframes2(absMix1);%重复帧
     Mix1=size(absMix1,2);
     H1=H1(:,1:Mix1);
     absMix2=absMix2(1:all_r,:);
     absMix2=multiframes2(absMix2);%重复帧
    
     H2=H2(:,1:Mixframes);


%% NMF方法时 更新系数矩阵H （用这个方法时可以把下面的注释取消掉）    
%       if alg==1
%         for iter=1:iter_num2
%             H1= H1.*(W1'*absMix1)./(W1'*W1*H1 + 1e-9);
% %             Hs = Hs.*(Ws'*absMix)./(Ws'*Ws*Hs + 1e-9);
%         end
%        elseif alg==2
%         for iter=1:iter_num2
%               H1 = H1.*(W1'*(absMix1./(W1*H1 + 1e-9)))./(sum(W1)'*ones(1,Mix1));
%               H2 = H2.*(W2'*(absMix2./(W2*H2 + 1e-9)))./(sum(W2)'*ones(1,Mixframes));
%         end
%       end
%% SNMF 更新系数矩阵H 
      H1= DH_sparse_nmf(absMix1,number_bases,iter_num2,W1,H1);
      H2= DH_sparse_nmf(absMix2,number_bases,iter_num2,W2,H2);
%       H3 = DH_sparse_nmf(absMix3,number_bases,iter_num2,W3,H3);
      
    V1=Wg1*H1(1:number_bases,:);
    V1=singleframe2(V1);
    Xcq.c=V1.*exp(1j*Xcq.theta);
     numl=size(Xcq.c,1);
     numr1=size(Xcq.c,2);
    Mean1=zeros(numl,1);
    for cc=1:numl
        Mean1(cc,1)=mean(Xcq.c(cc,:));
    end
    V1m1=ones(size(Xcq.c));
    V1m=bsxfun(@times,V1m1,Mean1);
    Xcq.c=Xcq.c-V1m;
    y5=icqt(Xcq);
    V2=Wg2*H2(1:number_bases,:);
    V2=singleframe2(V2); % Section III-C in the paper for Contextual Information
    V2=[V2(1:all_r,:);V2(end-1:-1:2,:)];
    y4=Convert2Speech(V2,phaseMix,fs,Mixframes,resdue); % 频域转换到时域
    [x41,phaseMix_gft,gft_frames,resph_gft]=Buildspectrogram_gft(y4,fs,X);
    absSp3=x41;
    absMix3=absSp3;
    Mix3=size(absSp3,2);
    H43=H3(:,1:Mix3);
    absMix3=multiframes2(absMix3); 
    H43 = DH_sparse_nmf(absMix3,number_bases,iter_num2,W3,H43);
    V43=Wg3*H43(1:number_bases,:);
    V43=singleframe2(V43);
    y6=Convert2Speech_gft(V43,phaseMix_gft,fs,gft_frames,resph_gft,X);
    y6=real(y6);
    
   
    [x51,phaseMix_gft,gft_frames,resph_gft]=Buildspectrogram_gft(y5,fs,X);
    absSp3=x51;
    absMix3=absSp3;
    Mix3=size(absSp3,2);
    H53=H3(:,1:Mix3);
    absMix3=multiframes2(absMix3);  
    H53 = DH_sparse_nmf(absMix3,number_bases,iter_num2,W3,H53);
    V53=Wg3*H53(1:number_bases,:);
    V53=singleframe2(V53);
    y7=Convert2Speech_gft(V53,phaseMix_gft,fs,gft_frames,resph_gft,X);
    y7=real(y7);
