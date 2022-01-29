%% PRACTICA 2. SERVICIOS TELEMATICOS MULTIMEDIA

% Guillermo Aldrey Pastor

% Fecha de Entrega: 30/10/2020

% En este archivo "Practica2.m" se procede a la resolucion de la practica.
% Se comentara brevemente los pasos a seguir, ya que la explicacion de cada
% apartado se explica en detalle en el pdf que se adjunta junto con este archivo. 

%% PARTE A. ANALISIS BASICO DE VOZ

clc;clear;close all

% a) Grabar una vocal y una consonante en sendos ficheros WAV. Representarlos 
% e identificar sus frecuencias. Representar la energía de ambas señales usando 
% espectrogramas.

[v,Fs_vocal] = audioread('vocal.wav');
[c,Fs_consonante] = audioread('consonante.wav');

% Representamos ambos fragmentos en el tiempo

figure(1)
title('Representacion de la vocal')
plot(v)
xlabel('Tiempo, s');
ylabel('Amplitud, V');
axis ([0 length(v) -1 1]);
soundsc(v,Fs_vocal)

figure(2)
title('Representacion de la consonante')
plot(c)
xlabel('Tiempo, s');
ylabel('Amplitud, V');
axis ([0 length(c) -1 1]);
soundsc(c,Fs_consonante)

% Ahora obtenemos las transformadas discretas de fourier de nuestros
% dos fragmentos de voz, usando la FFT(Fast Fourier Transform).
% Representamos ambos espectros

N=1024;
k=-N/2:N/2-1;

Xv=fftshift(fft(v.*hann(length(v)), N));
figure(3)
plot(k,20*log10(abs(Xv))),axis([0 fix(N/2) 0 100])
title('Espectro de mi vocal')
xlabel('Frecuencia, Hz');
ylabel('Amplitud, V');
xlim([-400 400]);
ylim([-150 0]);

Xc=fftshift(fft(c.*hann(length(c)), N));
figure(4)
plot(k,20*log10(abs(Xc))),axis([0 fix(N/2) 0 100])
title('Espectro de mi consonante')
xlabel('Frecuencia, Hz');
ylabel('Amplitud, V');
xlim([-400 400]);
ylim([-150 0]);

% Ahora obtenemos los espectogramas. Recordemos que un espectograma mide la
% amplitud del sonido frente al tiempo y la frecuencia

NFFT=256;
Win=256; 
Noverlap =128;

figure(5)
specgram(v, NFFT, Fs_vocal, Win, Noverlap);


figure(6)
specgram(c, NFFT, Fs_consonante, Win, Noverlap);



% b) Grabar una frase corta en un fichero WAV y hacer un análisis de la misma 
% tanto en el dominio temporal como en el de la frecuencia con un espectrograma.

[fc,Fs_frase] = audioread('frasecorta.wav');
sound(fc, Fs_frase);

% Primero analizamos la frase en el tiempo
figure(7)
title('Representacion de la frase corta en el tiempo')
plot(fc)
xlabel('Tiempo, s');
ylabel('Amplitud, V');
axis ([0 length(fc) -1 1]);


% Ahora vamos a analizar la frase en frecuencia
Xfc=fftshift(fft(fc.*hann(length(fc)), N));
figure(8)
plot(k,20*log10(abs(Xfc))),axis([0 fix(N/2) 0 100])
title('Espectro de mi frase corta')
xlabel('Frecuencia, Hz');
ylabel('Amplitud, V');
xlim([-550 550]);
ylim([-145 -40]);


% Por ultimo obtenemos el espectograma
figure(9)
specgram(fc, NFFT, Fs_frase, Win, Noverlap);


%% PARTE B. DISENO DE UN VOCODER LP

clc;clear;close all

[v,Fs_vocal] = audioread('vocal.wav');
[c,Fs_consonante] = audioread('consonante.wav');
[fc,Fs_frase] = audioread('frasecorta.wav');

% a) Representar la autocorrelación de la vocal y de la consonante usadas 
% antes, así como de la frase y compararlas.

% comenzamos con la vocal
[r_v, eta_v] = xcorr(v, 250, 'coeff');
figure (10)
plot(eta_v,r_v);
title('correlación cruzada vocal e');

figure(11)
autocorr(v, 250)
title('autocorrelación vocal e');

[r_v1, eta_v1] = xcorr(v, 250, 'unbiased');
figure(12)
plot(eta_v1,r_v1);
title('autorrelación sin voz');

figure(13)
autocorr(v,250);
title('autorrelación sin voz');

%ahora con la consonante
[r_c, eta_c] = xcorr(c, 250, 'coeff');
figure (10)
plot(eta_c,r_c);
title('correlación cruzada consonante g');

figure(11)
autocorr(c, 250)
title('autocorrelación consonante g');

[r_c1, eta_c1] = xcorr(c, 250, 'unbiased');
figure(12)
plot(eta_c1,r_c1);
title('autorrelación sin voz');

figure(13)
autocorr(c,250);
title('autorrelación sin voz');

%ahora la frase

[r_fc, eta_fc] = xcorr(fc, 250, 'coeff');
figure (10)
plot(eta_fc,r_fc);
title('correlación cruzada frase corta');

figure(11)
autocorr(fc, 250)
title('autocorrelación frase corta');


% b) Calcular los parámetros del predictor lineal LP que emule una palabra
% de la frase usada

%Primero tomo una sola palabra de la frase usada. Utilizo la palabra
%"futbol"

[p,Fs_palabra] = audioread('futbol.wav');
sound(p,Fs_palabra);

M=14;
[r_p, eta_p]=xcorr(p, M, 'biased');
Rx=toeplitz(r_p(M+1:2*M));
rx=r_p(M+2:2*M+1);
a=Rx\rx;

% para ver el valor de mis coeficientes pincho en el workspace en Rx

% compruebo en frecuencia

NFFT = 1024;
k = 1:NFFT/2;

X=fftshift(fft(p.*hann(length(p)), NFFT));
Theta = 1./fft([1; -a], NFFT); % coeficientes representados en a
figure(14)
plot(k, 20*log10(abs([353*Theta(k) X(k)])));
axis([0 NFFT/2 -inf inf]);
title('Espectro de mi palabra')
xlabel('Frecuencia, Hz');
ylabel('Amplitud, V');

d=1-rx'*a/r_p(M+1);


% c) Hacer la etapa de análisis con LP para la señal de voz de la frase completa. 
% Describir sus características.

clear all 
close all

[fc,Fs_frase] = audioread('frasecorta.wav');

M=14;
N=256;
[ar, xi, e, m]=lpcauto(fc, M, hann(N), N/2);

figure(15)
plot(fc, 'r')
title('Analisis original vs error')
hold on
plot(e, 'g')
plot(fc-e, 'd')
hold off

soundsc(fc, Fs_frase)
soundsc(e, Fs_frase)
soundsc(fc-e, Fs_frase)

%pitch
N=256; th=0.18; minlag =100; maxlag =200; fs=48000;
P=lpcpitch(e, m, N, th, minlag, maxlag);
figure(16)
plot(1:length(fc), fc*40+40, m, fs./P);

%ganancia
G=lpcgain(xi(M+1, :), P);
figure(17)
plot(1:length(fc), (fc-1)./4, m, G);

% d) Realizar la etapa de síntesis. Describir sus características

xhat = lpcsyn(ar, P, G, m);
soundsc(xhat, Fs_frase);

% e) Comparar la señal original que entró al análisis con la que resultó de 
% la síntesis. Representar el error 

