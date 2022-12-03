function [outputArg1] = noise_generate(sig_,fs_)
%NOISE_GENERATE 此处显示有关此函数的摘要
%   此处显示详细说明

[Pxx,w] = periodogram(sig_,[],512,fs_);
b = fir2(3000,w/(fs_/2),sqrt(Pxx/max(Pxx)));
N=length(sig_);
noise=1-2*rand(1,N);
ssn = filter(b,1,noise);
SNR=-5;
ssn_ = ssn/norm(ssn)*norm(sig_)*10^(-SNR/20); 
SNR = 20*log10(norm(sig_)/norm(ssn_));
Y=sig_+ssn_;
Y_ = Y/norm(Y)*norm(sig_);


outputArg1 = Y_;
end

