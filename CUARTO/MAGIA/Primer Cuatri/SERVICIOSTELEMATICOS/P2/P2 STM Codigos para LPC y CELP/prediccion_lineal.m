
clear all 
close all

% correlacion cruzada de una se�al senoidal
figure(1)
x=sin(2*pi*0.01*(0:499)');  % frecuencia 0.01
%[r, eta] = xcorr(x, 60, 'unbiased');
[r, eta] = xcorr(x, 60, 'coeff');
figure(1)
stem(eta,r);

pause

% autocorrelacion de una se�al senoidal
figure(2)
x=sin(2*pi*0.01*(0:499)');  % frecuencia 0.01
[ACF,lags,bounds] = autocorr(x,150);
figure(2)
autocorr(x,100)

pause

% correlacion cruzada de una se�al ruido aleatorio

w=randn(500,1);  % ruido aleatorio
[r, eta] = xcorr(w, 100, 'unbiased');
figure (3)
plot(eta,r);
title('ruido blanco');

pause

% autocorrelacion de una se�al ruido aleatorio

w=randn(500,1);  % ruido aleatorio
[ACF2,lags2,bounds2] = autocorr(w, 100);
figure (4)
autocorr(w,100)
title('ruido blanco');

pause

% correlacion cruzada del n�mero 3
clear all
close all

load digits;
x=digits.three1;
m=2756; % ventana con voz
N=256;
n=m-N+1:m;
%[r, eta] = xcorr(x(n), 250, 'unbiased');
[r, eta] = xcorr(x(n), 250, 'coeff');
figure (5)
plot(eta,r);
title('correlaci�n cruzada numero tres');

pause

% autocorrelacion del n�mero 3

m=2756; % ventana con voz
N=256;
n=m-N+1:m;
[ACF3,lags3,bounds3]= autocorr(x(n), 250);
figure(6)
autocorr(x(n), 250)
title('autocorrelaci�n numero tres');

pause

soundsc(digits.three1, 10000);

pause

% correlaci�n cruzada de ventana sin voz
m=500; % ventana sin voz
N=256;
n=m-N+1:m;
[r, eta] = xcorr(x(n), 250, 'unbiased');
figure(7)
plot(eta,r);
title('autorrelaci�n sin voz');
pause

% autocorrelaci�n de ventana sin voz
m=500; % ventana sin voz
N=256;
n=m-N+1:m;
[ACF4,lags4,bounds4]= autocorr(x(n), 250);
figure(8)
autocorr(x(n),250);
title('autorrelaci�n sin voz');
pause


%Encontrar el predictor de orden 14 para el fonema  'tres' 
x=digits.three1;
m=2756;
N=256;
n=m-N+1:m;
M=14;
[r, eta]=xcorr(x(n), M, 'biased');
Rx=toeplitz(r(M+1:2*M));
rx=r(M+2:2*M+1);
a=Rx\rx;

% Comprobaci�n en Frecuencia del modelo obtenido

NFFT=1024;
k=1:NFFT/2;
X=fft(x(n).*hann(N), NFFT);
Theta = 1./fft([1; -a], NFFT); % coeficientes representados en a
figure(5)
plot(k, 20*log10(abs([353*Theta(k) X(k)])));
axis([0 NFFT/2 -inf inf]);

d=1-rx'*a/r(M+1);

pause

% Calculo de los coeficientes con el m�todo de Levinson-Durbin

[aLD, xi, kappa]=durbin(r(M+1:2*M+1), M);
a, aLD, norm(a-aLD)

plot(xi); %Energia no creciente a medida que crece el orden
pause

% Predicci�n LP de una se�al de voz

clear all 
close all

load timit1;
x=timit1;
M=14;
N=256;
[ar, xi, e, m]=lpcauto(x, M, hann(N), N/2);
plot([x e x-e])
pause
soundsc(x, 16000)
pause
soundsc(e, 16000) % residuos
pause
soundsc(x-e, 16000) % prediccion 

% Espectro LPC de "your dark s..."
 
figure
plot(x(m(71):m(147)))
pause
 
%figure(3)
%lpcplot(ar(:,71:147), 512, 16000, m(71:147));
%pause
 
figure(4)
lpcplot(ar(:,82), 512, 16000, 0);  % u en your 
pause
 
figure(5)
lpcplot(ar(:,110), 512, 16000, 0);  % a en dark 
pause
 
figure(6)
lpcplot(ar(:,134), 512, 16000, 0);  % s en suit
pause


pause

%[rehat, eta]=xcorr(rehat, 250, �biased�);
%figure
%plot(eta, rehat)

N=256; th=0.18; minlag =100; maxlag =200; fs=16000;
P=lpcpitch(e, m, N, th, minlag, maxlag);
figure(7)
plot(1:length(x), x*40+40, m, fs./P);

pause
G=lpcgain(xi(M+1, :), P);
figure(8)
plot(1:length(x), (x-1)./4, m, G);

pause
 
xhat = lpcsyn(ar, P, G, m);
soundsc(xhat, 16000);

