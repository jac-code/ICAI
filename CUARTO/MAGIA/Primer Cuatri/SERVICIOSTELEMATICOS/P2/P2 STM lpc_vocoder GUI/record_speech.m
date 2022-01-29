function y=record_speech(fs,nsec)
% fs: sampling frequency
% nsec: number of seconds of recording
%   y: speech samples normalized to 32767
%
        N=fs*nsec;
        ch=1;
        y=wavrecord(N,fs,ch,'double');
        y=y*32767/max(abs(y));
end