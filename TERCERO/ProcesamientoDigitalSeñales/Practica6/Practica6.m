%% PRACTICA 6 - DISEÑO FILTRO FIR

%% a)
[xn, fs]= audioread("PDS_P6_3A_LE2_G6.wav");
load("PDS_P6_3A_LE2_G6.mat")

%sound(xn, fs); % pitido de fondo muy molesto

%% b)
Xf = fft(xn, length(xn))/length(xn);
Xf = fftshift(abs(Xf));
vector_frec = linspace(-fs/2,fs/2, length(xn));

figure;
plot(vector_frec, Xf);
xlabel("Frecuencia [Hz]");
ylabel("Amplitud [V/V]");
title("Espectro de xn(t)");
grid on;

%% c) 
load('Filtro.mat');

%% d)
filtro=fft(Num, 500);
filtro=fftshift(filtro);
frec_filtro=linspace(-fs/2, fs/2, length(filtro));

filtro = mag2db(abs(filtro));

figure;
plot(frec_filtro, filtro);
xlabel("Frecuencia [Hz]");
ylabel("Atenuacion [dB]");
axis([0 50000 -100 10]);
title("Filtro Diseñado");
grid on;

gn = filter(Num, 1, xn);
Gf=fftshift(abs(fft(gn, length(gn))/length(gn)));

figure;
plot(vector_frec, Gf);
xlabel("Frecuencia [Hz]");
ylabel("Amplitud");
axis([-10000 10000 0 0.01]);
title("Espectro de gn(t)");
grid on;

%% ALGORITMO OVERLAP-SAVE
yn = AlgoritmoSolape(xn, Num, 500);

%% APARTADO DE ANÁLISIS
gn = filter(Num, 1, xn);
vector_muestras = 1:1:length(gn);

figure;
hold on;
plot(vector_muestras, gn, 'black--o');
plot(vector_muestras, yn);
xlabel("Muestras [n]");
ylabel("Amplitud");

title("Filtrado estándar VS Overlap-save");
legend('Resultado Filter', 'Overlap-save');
grid on;

figure;
subplot(2,1,1)
plot(vector_muestras, gn,'black');
xlabel("Muestras [n]");
ylabel("Amplitud");
title("Filtrado estándar");
grid on;

subplot(2,1,2)
plot(vector_muestras,yn);
xlabel("Muestras [n]");
ylabel("Amplitud");
title("Overlap-save");
grid on;

%% Cálculo del error cuadratico medio
ecm = (1/length(yn))* sum(abs(yn-gn).^2);
disp(ecm);

%% Representación en frecuencia
Yf = fftshift(abs(fft(yn, length(yn))/length(yn)));

figure;
subplot(3,1,1)
plot(vector_frec, Xf, 'black');
xlabel("Frecuencia [Hz]");
ylabel("Amplitud");
title("Espectro original");
axis([-6500 6500 0 0.007]);
grid on;

subplot(3,1,2)
plot(vector_frec, Gf, 'red');
xlabel("Frecuencia [Hz]");
ylabel("Amplitud");
axis([-6500 6500 0 0.007]);
title("Espectro filtrado estándar");
grid on;

subplot(3,1,3)
plot(vector_frec, Yf, 'green');
xlabel("Frecuencia [Hz]");
ylabel("Amplitud");
axis([-6500 6500 0 0.007]);
title("Espectro Overlap-save");
grid on;

figure;
hold on;
plot(vector_frec, Xf,'r');
plot(vector_frec, Gf, 'g');
plot(vector_frec, Yf, 'b');
xlabel("Frecuencias [Hz]");
ylabel("Amplitud");
title("Superposicion de espectros");
axis([-6500 6500 0 0.007]);
legend('Original', 'Señal filtrada', 'Señal con algoritmo Overlap-save');
grid on;

%sound(yn, fs);