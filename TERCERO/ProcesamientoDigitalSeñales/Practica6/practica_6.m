%% a)
[xn, fs] = audioread('PDS_P6_3A_LE2_G8.wav');
%reproducimos
sound(xn, fs);

%% b)
dt = 1/fs;
t= 0:dt:((length(xn)-1)/fs);

figure()
plot(t, xn)
xlim([0 5])
xlabel('tiempo, seg')
ylabel('x[n]')
title('Señal original')

xn_f = (fft(xn, length(xn)))/length(xn);
f_xn = linspace(-fs/2,fs/2,length(xn));
figure();
plot(f_xn/1000, fftshift(abs(xn_f)));
title('Transformada de Fourier de x[n]')
xlabel('frecuencia, kHz')
ylabel('|xn(f)|')

%% d)
load('LowPass.mat');

gn = filter(Num, 1, xn);
t_gn = 0:dt:((length(gn)-1)/fs);

sound(gn, fs);

figure()
plot(t_gn, gn)
xlim([0 5])
xlabel('tiempo, seg')
ylabel('g[n]')
title('Señal filtrada')

% TDF señal filtrada
gf = (fft(gn, length(gn)))/length(gn);
f_g = linspace(-fs/2,fs/2,length(gn));
figure();
plot(f_g/1000,fftshift(abs(gf)));
title('Transformada de Fourier de gn')
xlabel('frecuencia, kHz')
ylabel('|gn(f)|')

% vemos la diferencia superponiendo señales
figure()
plot(t, xn)
hold on
plot(t_gn, gn)
xlim([0 5])
xlabel('tiempo, seg')
ylabel('Amplitud')
title('Señales superpuestas')
legend('Señal original x[n]', 'Señal filtrada g[n]');

% repuesta en frecuencia filtro
[h1, f1] = freqz(Num, length(Num), fs);
db = 20*log(abs(h1));
plot(f1, db);
title('Respuesta en frecuencia del filtro')
xlabel('frecuencia')
ylabel('|filtro(f)|, dB')

%% Implementacion de un filtro FIR utilizando DFT
%% a)
L = 500;
yn = AlgoritmoSolape(xn, Num, L);
sound(yn, fs);

%% Análisis de los resultados
%% a)
% dichos resultados ya han sido analizados en el apartado d) del primer
% bloque

%% b)
t_yn = 0:dt:((length(yn)-1)/fs);

figure()
plot(t_yn, yn)
hold on
plot(t_gn, gn)
xlim([0 5])
xlabel('tiempo, seg')
ylabel('Amplitud')
title('Señales superpuestas')
legend('Señal filtrada con overlap-save y[n]', 'Senal filtrada g[n]');

figure()
plot(t_yn, yn)
xlim([0 5])
xlabel('tiempo, seg')
ylabel('y[n]')
title('Representación temporal de y[n]')

figure()
plot(t_gn, gn)
xlim([0 5])
xlabel('tiempo, seg')
ylabel('g[n]')
title('Representación temporal de g[n]')

% para ver el filtrado mas de cerca
figure()
plot(t_yn, yn, '-o')
hold on
plot(t_gn, gn, '-x')
xlabel('tiempo, seg')
ylabel('Amplitud')
title('Comparación del fitrado')
legend('y[n]','g[n]')

%% c)
% utilizamos la función que programamos en la práctica anterior
ecm = Funcion_ECM(gn, yn);

%% d)
yn_f = (fft(yn, length(yn)))/length(yn);
f_yn = linspace(-fs/2, fs/2, length(yn));

gn_f = (fft(gn, length(gn)))/length(gn);
f_gn = linspace(-fs/2, fs/2, length(gn));

figure()
plot(f_xn/1000, fftshift(abs(xn_f)), '-x');
hold on
plot(f_gn/1000, fftshift(abs(gn_f)), '-o');
hold on
plot(f_yn/1000, fftshift(abs(yn_f)), '-*');
xlim([-10 10])
title('Respuesta en frecuencia de x[n], y[n] & g[n]');
xlabel('frecuencia, kHz')
ylabel('mod')
legend('Señal original x[n]', 'Señal filtrada con filtro FIR g[n]', 'Señal filtrada con overlap-save y[n]');


