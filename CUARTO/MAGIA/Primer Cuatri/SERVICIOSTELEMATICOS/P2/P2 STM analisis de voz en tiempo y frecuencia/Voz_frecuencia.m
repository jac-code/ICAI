clear all
close all

load ma1_1;
x=ma1_1(4161:4460);
figure(1)
plot(x)
title('ma1_1')
pause
soundsc(ma1_1, 8000)
pause
soundsc(x, 8000)
pause

% Transformada discreta de Fourier del fragmento de voz

N=1024;
k=-N/2:N/2-1;
X=fftshift(fft(x.*hann(length(x)), N));
figure
plot(k,20*log10(abs(X))),axis([0 fix(N/2) -inf inf])

pause
% calculo del tono del fragmento de voz

x=ma1_1(4161:4460);
N=1024; 
R=5;
HPSx=hpspectrum(x,N,R);
figure(3)
plot(20*log10(abs(HPSx)));


% Aplicación al caso de las vocales

clear all; close all;
load vowels;

%vocal i
x=vowels.i_1(2001:2300);
N=1024;
k=-N/2:N/2-1;
X=fftshift(fft(x.*hann(length(x)), N));
figure(4)
plot(k,20*log10(abs(X))),axis([0 fix(N/2) 0 100])
title('vocal i')
pause

%vocal u
x=vowels.u_1(2001:2300);
N=1024;
k=-N/2:N/2-1;
X=fftshift(fft(x.*hann(length(x)), N));
figure(5)
plot(k,20*log10(abs(X))),axis([0 fix(N/2) 0 100])
title('vocal u')
pause


% Spectrogramas

load timit1;
NFFT=256; Fs=16000; Win=256; Noverlap =128;
figure(6)
specgram(timit1, NFFT, Fs, Win, Noverlap);
pause
soundsc(timit1,16000)

pause 
load gliss;
NFFT=256; Fs=10000; Win=256; Noverlap =128;
figure(7)
specgram(gliss.i_2, NFFT, Fs, Win, Noverlap);
pause
soundsc(gliss.i_2,10000)



