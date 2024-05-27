function  [Wg1,Hg1,Wg2,Hg2,Wg1L,Hg1L]=NMFL(Sg1,Sg2, Sg1L,number_bases,iter_num,alg)
if alg==1
    [Wg1,Hg1]=nmfmse( Sg1, number_bases,iter_num ,0);
elseif alg==2
    [Wg1,Hg1]=nmfdiv( Sg1, number_bases,iter_num ,0);
end
if alg==1
    [Wg2,Hg2]=nmfmse( Sg2, number_bases,iter_num ,0);
elseif alg==2
    [Wg2,Hg2]=nmfdiv( Sg2, number_bases,iter_num ,0);
end
if alg==1
    [Wg1L,Hg1L]=nmfmse( Sg1L, number_bases,iter_num ,0);
elseif alg==2
    [Wg1L,Hg1L]=nmfdiv( Sg1L, number_bases,iter_num ,0);
end