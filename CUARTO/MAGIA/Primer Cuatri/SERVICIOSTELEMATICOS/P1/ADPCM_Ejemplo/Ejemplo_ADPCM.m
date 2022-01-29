
% Ejemplo de codigo ADPCM

clc;clear;close all

[Y,Fs] = audioread('Voz.wav'); % Se lle una voz

[n, m] =size (Y);


 y = adpcm_encoder(Y);
YY = adpcm_decoder(y);

t=1:n;

figure (1)
plot(t, YY, t, Y)
title("Ejemplo ADPCM")
legend('decodificada','original')


figure(2)
plot(Y, YY, '*')
title("Se�al original frente a decodificada")

% Se�al original
sound(Y,Fs);

% Se�al decodificada
sound(YY,Fs);


