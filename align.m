
function [W,H]=align(Wg,Hg,Ws,Hs)
a=size(Hg,2);
b=size(Hs,2);
if a>b
    Hg=Hg(:,1:b);
else
    Hs=Hs(:,1:a);
end
W=[Wg Ws]; 
H=[Hg;Hs];