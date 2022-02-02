%% PRÁCTICA 4

% Procesamiento digital de la señal
% Fecha: 20/03/2021
% Grupo: Javier Álvarez Martínez y Álvaro Prado Moreno

%% EJERCICIO 1: Diseño filtros IIR

load('PDS_P4_3A_LE1_G2.mat');

%% EJERCICIO 2: Análisis de filtros
%% EJERCICIO 2.1: Módulo y fase
load('COEFICIENTES_FILTROS.mat');

%% apartado a)

% Tras haber diseñado los filtros con el Filter Designer obtenemos un
% vector h con los coefiecientes de la respuesta en frecuencia y su correspondiente vector de
% frecuencias 

[h_ell, f_ell] = freqz(Num_elliptic, Den_elliptic, 5000, Fs); %Paso bajo IIR elliptic
[h_butt, f_butt] = freqz(Num_butterworth, Den_butterworth, 5000, Fs); %Paso bajo IIR butterworth
[h_chebyT1, f_chebyT1] = freqz(Num_chebyT1, Den_chebyT1, 5000, Fs); %Filtro chebyshev tipo 2
[h_chebyT2, f_chebyT2] = freqz(Num_chebT2, Den_chebT2, 5000, Fs); %Filtro chebyshev tipo 1

%cambiamos las unidades a dB
H_ell_dB = mag2db(abs(h_ell));
H_butt_dB = mag2db(abs(h_butt));
H_chebyT1_dB = mag2db(abs(h_chebyT1));
H_chebyT2_dB =mag2db(abs(h_chebyT2));

figure;

subplot(2,2,1);
plot(f_ell, H_ell_dB);
title('IIR Elliptic');
ylabel('Magnitude (dB)');
xlabel('Frecuencia (Hz)');
grid on;

subplot(2,2,2);
plot(f_butt, H_butt_dB);
title('IIR Butterworth');
ylabel('Magnitude (dB)');
xlabel('Frecuencia (Hz)');
grid on;

subplot(2,2,3);
plot(f_chebyT1, H_chebyT1_dB);
title('IIR Chebyshev _ type 1');
ylabel('Magnitude (dB)');
xlabel('Frecuencia (Hz)');
grid on;

subplot(2,2,4);
plot(f_chebyT2, H_chebyT2_dB);
title('IIR Chebyshev _ type 2');
ylabel('Magnitude (dB)');
xlabel('Frecuencia (Hz)');
grid on;


%Se representan todos juntos para apreciar diferencias

%Representacion completa
figure;
subplot(1,2,1);
hold on;

plot(f_ell, H_ell_dB);
plot(f_butt, H_butt_dB);
plot(f_chebyT1, H_chebyT1_dB);
plot(f_chebyT2, H_chebyT2_dB);
ylabel('Magnitude (dB)');
xlabel('Frecuencia (Hz)');
title('Módulo de la respuesta en frecuencia');
legend('Elliptic', 'Butterworth', 'Chebyshev 1', 'Chebyshev 2');
grid on;

%Representacion mas ajustada en el eje X
subplot(1,2,2)

hold on;
plot(f_ell, H_ell_dB);
plot(f_butt, H_butt_dB);
plot(f_chebyT1, H_chebyT1_dB);
plot(f_chebyT2, H_chebyT2_dB);
ylabel('Magnitude (dB)');
xlabel('Frecuencia (Hz)');
title('Zoom banda de transicion');
legend('Elliptic', 'Butterworth', 'Chebyshev 1', 'Chebyshev 2');
axis([0 15000 -200 10]);
grid on;

%% apartado b)

%vemos que la fase en la banda atenuada no nos interesa porque las
%frecuencias estan del todo eliminiadas debido a la gran atenuacion
% ver si debemos mirar la pendiente de la fase

%Obtenemos las fases de los filtros y eliminamos posibles discontinuidades
%con el uso unwrap

H_ell_angle = unwrap(angle(h_ell));
H_butt_angle = unwrap(angle(h_butt));
H_chebyT1_angle = unwrap(angle(h_chebyT1));
H_chebyT2_angle = unwrap(angle(h_chebyT2));


figure;
subplot(2,2,1);
plot(f_ell, H_ell_angle);
title('IIR Elliptic');
ylabel('Phase (radianes)');
xlabel('Frecuencia (Hz)');
grid on;

subplot(2,2,2);
plot(f_butt, H_butt_angle);
title('IIR Butterworth');
ylabel('Phase (radianes)');
xlabel('Frecuencia (Hz)');
grid on;

subplot(2,2,3);
plot(f_chebyT1, H_chebyT1_angle);
title('IIR Chebyshev _ type 1');
ylabel('Phase (radianes)');
xlabel('Frecuencia (Hz)');
grid on;

subplot(2,2,4);
plot(f_chebyT2, H_chebyT2_angle);
title('IIR Chebyshev _ type 2');
ylabel('Phase (radianes)');
xlabel('Frecuencia (Hz)');
grid on;


%Representamos las fases en la misma grafica para observar diferencias


figure 
hold on;
plot(f_ell, H_ell_angle);
plot(f_butt, H_butt_angle);
plot(f_chebyT1, H_chebyT1_angle);
plot(f_chebyT2, H_chebyT2_angle);
title('Fase de los IIR');
ylabel('Phase (radianes)');
xlabel('Frecuencia (Hz)');
legend('Elliptic', 'Butterworth', 'Chebyshev 1', 'Chebyshev 2');
axis([0 10000 -15 0]);
grid on;


%% EJERCICIO 2.2: Polos y ceros

%% apartado a)

% filtro elliptic

figure;
subplot(2,2,1);
zplane(Num_elliptic, Den_elliptic);
title('IIR Elliptic');
ylabel('Eje imaginario');
xlabel('Eje real');
grid on;


% filtro butterworth

subplot(2,2,2);
zplane(Num_butterworth, Den_butterworth);
title('IIR Butterworth');
ylabel('Eje imaginario');
xlabel('Eje real');
grid on;


% filtro chebyshev type 1


subplot(2,2,3);
zplane(Num_chebyT1, Den_chebyT1);
title('IIR Chebyshev _ type 1');
ylabel('Eje imaginario');
xlabel('Eje real');
grid on;



% filtro chebyshev type 2

subplot(2,2,4);
zplane(Num_chebT2, Den_chebT2);
title('IIR Chebyshev _ type 2');
ylabel('Eje imaginario');
xlabel('Eje real');
grid on;


% Representamos en una figura a parte únicamente el filtro IIR elliptic
% para poder respoder a las preguntas del informe y la respuesta en
% frecuencia del primer apartado para ver los máximos y mínimos

figure;
zplane(Num_elliptic, Den_elliptic);
title('Polos y ceros IIR Elliptic');
ylabel('Eje imaginario');
xlabel('Eje real');
grid on;


figure;

plot(f_ell, H_ell_dB);
title('Maximos en el modulo del IIR Elliptic');
ylabel('Magnitude (dB)');
xlabel('Frecuencia (Hz)');
axis([0 6000 -0.5 0.5]);
grid on;


figure;
plot(f_ell, H_ell_dB);
title('Minimos en el modulo del IIR Elliptic');
ylabel('Magnitude (dB)');
xlabel('Frecuencia (Hz)');
axis([10000 27500 -200 0.5]);
grid on;

%% EJERCICIO 2.3: Estabilidad

%% apartado a)

%Obtenemos polos del denominador y multiplicamos por factor 0.95
p_elliptic_a = 0.95*(roots(Den_elliptic));
%% apartado b)

%Construimos un polinomio a partir de los polos modificados
denominador_elliptic_a = poly(p_elliptic_a)
%% apartado c)

polos_elliptic_b = 1.05*(roots(Den_elliptic));
%% apartado d)

denominador_elliptic_b = poly(polos_elliptic_b);

%% apartado f)

%Con la funcion freqz obtenemos la nueva respuesta en frecuencias con la
%modificacion en los polos

[h_a,f_a] = freqz(Num_elliptic,denominador_elliptic_a,5000, Fs);

%Pasamos a dB
h_a_dB = mag2db(abs(h_a));

[h_b,f_b] = freqz(Num_elliptic,denominador_elliptic_b,5000, Fs);

h_b_dB = mag2db(abs(h_b));


%Representación del modulo de la respuesta en frecuencia
figure;
plot(f_ell, H_ell_dB,'r');
hold on;
plot(f_a, h_a_dB, 'g');
hold on;
plot(f_b, h_b_dB,'black');
legend('IIR Elliptic original','Polos multiplicados por 0.95','Polos multiplicados por 1.05')
ylabel('Magnitude (dB)');
xlabel('Frecuencia (Hz)');
title('Módulo de la respuesta en frecuencia')
grid on;

%%Creamos una figura con zoom en las partes que nos interesan mas

%Zoom en los maximos
figure;

subplot(2,1,1);
plot(f_ell, H_ell_dB,'r');
hold on;
plot(f_a, h_a_dB, 'g');
hold on;
plot(f_b, h_b_dB,'black');
axis([0 7500 -10 21]);
legend('IIR Elliptic original','Polos multiplicados por 0.95','Polos multiplicados por 1.05')
ylabel('Magnitude (dB)');
xlabel('Frecuencia (Hz)');
title('Máximos de la respuesta en frecuencia')
grid on;

%Zoom en los minimos

subplot(2,1,2);
plot(f_ell, H_ell_dB,'r');
hold on;
plot(f_a, h_a_dB, 'g');
hold on;
plot(f_b, h_b_dB,'black');
axis([10000 27500 -200 -75]);
legend('IIR Elliptic original','Polos multiplicados por 0.95','Polos multiplicados por 1.05')
ylabel('Magnitude (dB)');
xlabel('Frecuencia (Hz)');
title('Mínimos de la respuesta en frecuencia')
grid on;

%Representacion para ver el rizado en la banda de paso
figure;
plot(f_ell, H_ell_dB,'r');
hold on;
plot(f_a, h_a_dB, 'g');
hold on;
plot(f_b, h_b_dB,'black');
axis([0 6000 -3 3]);
legend('IIR Elliptic original','Polos multiplicados por 0.95','Polos multiplicados por 1.05')
ylabel('Magnitude (dB)');
xlabel('Frecuencia (Hz)');
title('Rizado en banda de paso')
grid on;


%% apartado g)

%Representación de los diagramas superpuestos
figure;
hold on;
zplane(Num_elliptic, Den_elliptic);
zplane(Num_elliptic, denominador_elliptic_a);
zplane(Num_elliptic, denominador_elliptic_b);
title('IIR Elliptic');
axis([-1.1 1.1 -1.1 1.1]);
ylabel('Eje imaginario');
xlabel('Eje real');
grid on;

%Representamos los diagramas separados
figure;
subplot(1,3,1);
zplane(Num_elliptic, denominador_elliptic_a);
axis([-1.1 1.1 -1.1 1.1]);
title('Polos multiplicados por 0.95');
ylabel('Eje imaginario');
xlabel('Eje real');
grid on;


subplot(1,3,2);
zplane(Num_elliptic, Den_elliptic);
axis([-1.1 1.1 -1.1 1.1]);
title('Polos originales');
ylabel('Eje imaginario');
xlabel('Eje real');
grid on;

subplot(1,3,3);
zplane(Num_elliptic, denominador_elliptic_b);
axis([-1.1 1.1 -1.1 1.1]);
title('Polos multiplicados por 1.05');
ylabel('Eje imaginario');
xlabel('Eje real');
grid on;
%% apartado e) y h)


%Hallamos con la funcion impz la respuesta al impulso y su correspondiente
%vector de tiempos mediante los coeficientes de num y den

[h1,t1]= impz(Num_elliptic,Den_elliptic);
[h2,t2]= impz(Num_elliptic,denominador_elliptic_a);
[h3,t3]= impz(Num_elliptic,denominador_elliptic_b);

%Representamos en misma figura todas las respuestas al impulso
figure;
subplot(3,1,1);
plot(t1,h1);
title('Respuesta al impulso IIR Elliptic');
ylabel('Magnitud');
xlabel('Muestras [n]');
grid on;

subplot(3,1,2);
plot(t2,h2);
title('Respuesta al impulso Polos multiplicados por 0.95');
ylabel('Magnitud ');
xlabel('Muestras [n]');
grid on;

subplot(3,1,3);
plot(t3,h3);
title('Respuesta al impulso Polos multiplicados por 1.05');
ylabel('Magnitud ');
xlabel('Muestras [n]');
grid on;