function  [Xcq,FreqVec,Ures_FreqVec] = BuildCQT_linear_spectrogram(x, fs, B, fmax, fmin, Len_linear)



%%% CHECK INPUT PARAMETERS
if nargin < 2
    warning('Not enough input arguments.'), return
end

%%% DEFAULT INPUT PARAMETERS
if nargin < 3; B = 96; end
if nargin < 4; fmax = fs/2; end
if nargin < 5; oct = ceil(log2(fmax/20)); fmin = fmax/2^oct; end
if nargin < 6; d = 16; end
if nargin < 7; cf = 19; end
if nargin < 8; ZsdD = 'ZsdD'; end
gamma = 228.7*(2^(1/B)-2^(-1/B));

%%% CQT COMPUTING
Xcq = cqt(x, B, fs, fmin, fmax, 'rasterize', 'full', 'gamma', gamma);

%%%Phase 
theta=zeros(size(Xcq.c));
for n=1:size(Xcq.c,2)    
   theta(:,n)=phase(Xcq.c(:,n));
end

Xcq.theta=theta;
% %%% POWER SPECTRUM
absCQT = abs(Xcq.c);
TimeVec = (1:size(absCQT,2))*Xcq.xlen/size(absCQT,2)/fs;
FreqVec = fmin*(2.^((0:size(absCQT,1)-1)/B));

%%% RESAMPLING
[Ures_absCQT, Ures_FreqVec] = resample(absCQT,...
    FreqVec,(Len_linear-1)/(FreqVec(end)-FreqVec(1)),1,1,'spline');

Xcq.c=Ures_absCQT;
end


