%% PRÁCTICA 4 - Diseño filtros IIR
load('PDS_P4_3A_LE2_G6.mat');

%% Análisis de filtros
%% Módulo y fase
load('Butterworth.mat');
load('Chebyshev_I.mat');
load('Chebyshev_II.mat');
load('Elliptic.mat');

%% a)
[coeficientes_elliptic, frecuencias_elliptic] = freqz(Num_Elliptic, Den_Elliptic, 5000, Fs); % LP - IIR elliptic
[coeficientes_butterworth, frecuencias_butterworth] = freqz(Num_Butterworth, Den_Butterworth, 5000, Fs); % LP - IIR Butterworth
[coeficientes_chebyshev_I, frecuencias_chebyshev_I] = freqz(Num_Chebyshev_I, Den_Chebyshev_I, 5000, Fs); % LP - Chebyshev I
[coeficientes_chebyshev_II, frecuencias_chebyshev_II] = freqz(Num_Chebyshev_II, Den_Chebyshev_II, 5000, Fs); % LP - Chebyshev II

% cambio a decibelios
coeficientes_elliptic_dB = mag2db(abs(coeficientes_elliptic));
coeficientes_butterworth_dB = mag2db(abs(coeficientes_butterworth));
coeficientes_chebyshev_I_dB = mag2db(abs(coeficientes_chebyshev_I));
coeficientes_chebyshev_II_dB =mag2db(abs(coeficientes_chebyshev_II));

figure;
subplot(2,2,1);
plot(frecuencias_elliptic, coeficientes_elliptic_dB);
title('LP - IIR Elliptic');
ylabel('Magnitude (dB)');
xlabel('Frecuencia (Hz)');
grid on;

subplot(2,2,2);
plot(frecuencias_butterworth, coeficientes_butterworth_dB);
title('LP - IIR Butterworth');
ylabel('Magnitude (dB)');
xlabel('Frecuencia (Hz)');
grid on;

subplot(2,2,3);
plot(frecuencias_chebyshev_I, coeficientes_chebyshev_I_dB);
title('LP - IIR Chebyshev I');
ylabel('Magnitude (dB)');
xlabel('Frecuencia (Hz)');
grid on;

subplot(2,2,4);
plot(frecuencias_chebyshev_II, coeficientes_chebyshev_II_dB);
title('LP - IIR Chebyshev II');
ylabel('Magnitude (dB)');
xlabel('Frecuencia (Hz)');
grid on;

figure;
subplot(1,2,1);
hold on;
plot(frecuencias_elliptic, coeficientes_elliptic_dB);
plot(frecuencias_butterworth, coeficientes_butterworth_dB);
plot(frecuencias_chebyshev_I, coeficientes_chebyshev_I_dB);
plot(frecuencias_chebyshev_II, coeficientes_chebyshev_II_dB);
ylabel('Magnitude (dB)');
xlabel('Frecuencia (Hz)');
title('Módulo de la respuesta en frecuencia');
legend('Elliptic', 'Butterworth', 'Chebyshev I', 'Chebyshev II');
grid on;

subplot(1,2,2)
hold on;
plot(frecuencias_elliptic, coeficientes_elliptic_dB);
plot(frecuencias_butterworth, coeficientes_butterworth_dB);
plot(frecuencias_chebyshev_I, coeficientes_chebyshev_I_dB);
plot(frecuencias_chebyshev_II, coeficientes_chebyshev_II_dB);
ylabel('Magnitude (dB)');
xlabel('Frecuencia (Hz)');
title('Zoom banda de paso');
legend('Elliptic', 'Butterworth', 'Chebyshev I', 'Chebyshev II');
grid on;

%% b)
coeficientes_elliptic_fase = unwrap(angle(coeficientes_elliptic));
coeficientes_butterworth_fase = unwrap(angle(coeficientes_butterworth));
coeficientes_chebyshev_I_fase = unwrap(angle(coeficientes_chebyshev_I));
coeficientes_chebyshev_II_fase = unwrap(angle(coeficientes_chebyshev_II));

figure;
subplot(2,2,1);
plot(frecuencias_elliptic, coeficientes_elliptic_fase);
title('LP - IIR Elliptic');
ylabel('Fase (rad)');
xlabel('Frecuencia (Hz)');
grid on;

subplot(2,2,2);
plot(frecuencias_butterworth, coeficientes_butterworth_fase);
title('LP - IIR Butterworth');
ylabel('Fase (rad)');
xlabel('Frecuencia (Hz)');
grid on;

subplot(2,2,3);
plot(frecuencias_chebyshev_I, coeficientes_chebyshev_I_fase);
title('LP - IIR Chebyshev I');
ylabel('Fase (rad)');
xlabel('Frecuencia (Hz)');
grid on;

subplot(2,2,4);
plot(frecuencias_chebyshev_II, coeficientes_chebyshev_II_fase);
title('LP - IIR Chebyshev II');
ylabel('Fase (rad)');
xlabel('Frecuencia (Hz)');
grid on;

figure 
hold on;
plot(frecuencias_elliptic, coeficientes_elliptic_fase);
plot(frecuencias_butterworth, coeficientes_butterworth_fase);
plot(frecuencias_chebyshev_I, coeficientes_chebyshev_I_fase);
plot(frecuencias_chebyshev_II, coeficientes_chebyshev_II_fase);
title('Fase de los IIR');
ylabel('Fase (rad)');
xlabel('Frecuencia (Hz)');
legend('Elliptic', 'Butterworth', 'Chebyshev I', 'Chebyshev II');
grid on;

%% Polos y ceros
%% a)
figure;
subplot(2,2,1);
zplane(Num_Elliptic, Den_Elliptic);
title('LP - IIR Elliptic');
ylabel('Img');
xlabel('Real');
grid on;

subplot(2,2,2);
zplane(Num_Butterworth, Den_Butterworth);
title('LP - IIR Butterworth');
ylabel('Img');
xlabel('Real');
grid on;

subplot(2,2,3);
zplane(Num_Chebyshev_I, Den_Chebyshev_I);
title('LP - IIR Chebyshev I');
ylabel('Img');
xlabel('Real');
grid on;

subplot(2,2,4);
zplane(Num_Chebyshev_II, Den_Chebyshev_II);
title('LP - IIR Chebyshev II');
ylabel('Img');
xlabel('Real');
grid on;

% solo para Elliptic
figure;
zplane(Num_Elliptic, Den_Elliptic);
title('Polos y ceros IIR Elliptic');
ylabel('Img');
xlabel('Real');
grid on;

figure;
plot(frecuencias_elliptic, coeficientes_elliptic_dB);
title('Maximos en el modulo del IIR Elliptic');
ylabel('Magnitude (dB)');
xlabel('Frecuencia (Hz)');
axis([0 6000 -0.5 0.5]);
grid on;

figure;
plot(frecuencias_elliptic, coeficientes_elliptic_dB);
title('Minimos en el modulo del IIR Elliptic');
ylabel('Magnitude (dB)');
xlabel('Frecuencia (Hz)');
axis([10000 27500 -200 0.5]);
grid on;

%% Estabilidad
%% a)
raices_elliptic_a = 0.95 * (roots(Den_Elliptic));

%% b)
den_elliptic_a = poly(raices_elliptic_a);

%% c)
raices_elliptic_b = 1.05*(roots(Den_Elliptic));

%% d)
den_elliptic_b = poly(raices_elliptic_b);

%% f)
[coeficientes_a,frecuencias_a] = freqz(Num_Elliptic,den_elliptic_a,5000, Fs);
frecuencias_a_dB = mag2db(abs(coeficientes_a));

[coeficientes_b,frecuencias_b] = freqz(Num_Elliptic,den_elliptic_b,5000, Fs);
coeficientes_b_dB = mag2db(abs(coeficientes_b));

figure;
plot(frecuencias_elliptic, coeficientes_elliptic_dB,'r');
hold on;
plot(frecuencias_a, frecuencias_a_dB, 'g');
hold on;
plot(frecuencias_b, coeficientes_b_dB,'black');
legend('IIR Elliptic original','Polos multiplicados por 0.95','Polos multiplicados por 1.05')
ylabel('Magnitude (dB)');
xlabel('Frecuencia (Hz)');
title('Módulo de la respuesta en frecuencia')
grid on;

%% g)
figure;
subplot(1,3,1);
zplane(Num_Elliptic, den_elliptic_a);
axis([-1.1 1.1 -1.1 1.1]);
title('Polos multiplicados por 0.95');
ylabel('Img');
xlabel('Real');
grid on;
subplot(1,3,2);
zplane(Num_Elliptic, Den_Elliptic);
axis([-1.1 1.1 -1.1 1.1]);
title('Polos originales');
ylabel('Img');
xlabel('Real');
grid on;
subplot(1,3,3);
zplane(Num_Elliptic, den_elliptic_b);
axis([-1.1 1.1 -1.1 1.1]);
title('Polos multiplicados por 1.05');
ylabel('Img');
xlabel('Real');
grid on;

%% e), h)
[coeficientes_original,tiempo_original]= impz(Num_Elliptic, Den_Elliptic);
[coeficientes_095,tiempo_095]= impz(Num_Elliptic, den_elliptic_a);
[coeficientes_105,tiempo_105]= impz(Num_Elliptic, den_elliptic_b);

figure;
subplot(3,1,1);
plot(tiempo_original,coeficientes_original);
title('Respuesta al impulso IIR Elliptic');
ylabel('Magnitud');
xlabel('Muestras [n]');
grid on;

subplot(3,1,2);
plot(tiempo_095,coeficientes_095);
title('Respuesta al impulso Polos multiplicados por 0.95');
ylabel('Magnitud ');
xlabel('Muestras [n]');
grid on;

subplot(3,1,3);
plot(tiempo_105,coeficientes_105);
title('Respuesta al impulso Polos multiplicados por 1.05');
ylabel('Magnitud ');
xlabel('Muestras [n]');
grid on;