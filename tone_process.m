function [outputsig] = tone_process(N,lowfreq,sig_1,fs_)
%TONE_PROCESS 此处显示有关此函数的摘要
%   此处显示详细说明
t=0:length(sig_1)-1;
d1=log10(200/165.4+1)/0.06;%[200,7000]第一个带通的中心频率
d2=log10(7000/165.4+1)/0.06;
dmid=zeros(1,N-1);
fmid=zeros(1,N+1);
fmid(1)=200;fmid(end)=7000;
for i=1:N-1
    dmid(i)=((N-i)*d1+i*d2)/N;
    fmid(i+1)=165.4*(10.^(0.06*dmid(i))-1);
end
%带通滤波器设置成为2*N的数组
sig=cell(1,N);
[b_low,a_low] = butter(4,lowfreq/(fs_/2));%低通滤波器，都设为50dB
sig_total=cell(1,N);
fmidcarry=zeros(1,N);
sig_eve=cell(1,N);
for i=1:N
    [bandpass1,bandpass2] = butter(4,[fmid(i) fmid(i+1)]/(fs_/2));
    % band-pass filter,bandpass第一行是b,第二行是a
    sig{i} = filter(bandpass1,bandpass2,sig_1);
    Xabs = abs(sig{i});
    sig_total{i}=filter(b_low,a_low,Xabs);%四个低通滤波操作
    %两个带宽的低通滤波，并进行调制
    fmidcarry(i)=(fmid(i)+fmid(i+1))/2;
end

eve_total=zeros(1,length(t));
for i=1:N
    box=cell2mat(sig_total(i));
    sig_eve=sin(2*pi*fmidcarry(i)*t).*box;
    eve_total=eve_total+sig_eve;
end

eve_total=eve_total*norm(sig_1)/norm(eve_total);
outputsig = eve_total;
end

