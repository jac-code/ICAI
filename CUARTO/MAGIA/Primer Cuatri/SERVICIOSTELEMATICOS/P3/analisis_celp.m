clc;clear;close all

load digits;
x=digits.three1;
m=2756; N=200; n=m-N+1:m; M=14;
[ar, xi, kappa, ehat]=lpcana(x(n), M);
c=0.8; ac=lpcweight(ar, c);

NFFT=1024;
k=1:NFFT/2;
Theta = 1./fft(ar, NFFT);
W=fft(ar, NFFT)./fft(ac, NFFT);

figure
plot(k, 20*log10(abs([Theta(k) W(k)])));
axis([0 NFFT/2 -inf inf]);

figure
zplane(ar', ac'); % Coeficientes obtenidos del analisis LP y los obtenidos con pesado perceptual

clear all
close all
% generación del codebook gaussiano
randn('state', 0);
cb=randn(40, 1024);  % 40 veces 1024

%Fase de análisis con CELP


load digits;
x=digits.three1;
m=2756; N=200; n=m-N+1:m; M=12;
L=40; c=0.8;Pidx=[16 160];
bbuf=0; ebuf=zeros(N,1); Zf=[]; Zw=[];
 
[kappa, k, theta0, P, b, ebuf, Zf, Zw]=celpana(x(n), L, M, c, cb, Pidx,...
    bbuf, ebuf, Zf, Zw);

[xhat, ebuf, Zi]= celpsyn(cb, kappa, k, theta0, P, b, ebuf, []);
figure
plot([xhat x(n)])

%Análisis completo con CELP

clear all
close all
% generación del codebook gaussiano
randn('state', 0);
cb=randn(40, 1024);  % 40 veces 1024

load ma1_1;
x=ma1_1;
N=160; M=10; L=40; c=0.8;Pidx=[16 160];

[xhat, e, k, theta0, P, b]=celp(x, N, L, M, c, cb, Pidx);

figure
plot([x xhat ])
axis([10800 11000 -0.5 0.5])

soundsc(xhat, 8000)

figure; plot(e)
figure; plot(k(:))
figure; plot(theta0(:))
figure; plot(P(:))
figure; plot(b(:))

% Caso 16000 bps
load ma1_1;
x=ma1_1;
N=160; M=10; L=40; c=0.8;Pidx=[16 160];
randn('state', 0);
cb=randn(L, 1024);  % 40 veces 1024

[xhat, e, k, theta0, P, b]=celp16k(x, N, L, M, c, cb, Pidx);

figure
plot([x xhat ])
axis([10800 11000 -0.5 0.5])

soundsc(xhat, 8000)

%Caso 9600 bps
load ma1_1;
x=ma1_1;
N=160; M=10; L=40; c=0.8;Pidx=[16 160];
randn('state', 0);
cb=randn(L, 1024);  % 40 veces 1024

[xhat, e, k, theta0, P, b]=celp9600(x, N, L, M, c, cb, Pidx);

figure
plot([x xhat ])
axis([10800 11000 -0.5 0.5])

soundsc(xhat, 8000)
