%% PRÁCTICA 2 - Cambio de frecuencia de muestreo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Jaime Arana Cardelús
% Guillermo Fernández Pérez
% 3ºA - GITT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Diezmado por un factor entero
%% a)
[x_n,fs_xn]= audioread('PDS_P2_3A_LE2_G6.wav');
sound(x_n, fs_xn);
disp(fs_xn);

%% b)
T_xn = 1/fs_xn;
vector_tiempo_xn = linspace(0, length(x_n)*T_xn, length(x_n));

figure;
plot(vector_tiempo_xn,x_n);
ylabel('Amplitud [V/V]');
xlabel('Tiempo [seg]');
title('Representación de x(t)');
grid on;

%% c)
posicion_menor = find(abs(x_n)>0.01);
y_n = x_n(posicion_menor(1):1:posicion_menor(end));
vector_tiempo_yn = linspace(0, length(y_n)*T_xn, length(y_n));

figure;
plot(vector_tiempo_yn, y_n);
ylabel('Amplitud [V/V]');
xlabel('Tiempo [seg]');
title('Representación de y(t)');
grid on;

%% d)
M = 2;
[g_n, vector_tiempos_gn] = Diezmador(y_n, vector_tiempo_yn, M);

%% f)
fs_gn = fs_xn/M;

%% g)
figure;
plot(vector_tiempo_yn,y_n, 'black *');
hold on;
plot(vector_tiempos_gn,g_n, 'r o');
ylabel('Amplitud [V/V]');
xlabel('Tiempo [seg]');
title('Comparación señales y(t) | g_n(t)');
legend('y(t)','g_n(t) - Diezmada');
grid on;

%% h)
% SIN NORMALIZAR
Yf = fft(y_n, length(y_n));
Yf = fftshift(abs(Yf));
vector_frec_Yf = linspace(-fs_xn/2, fs_xn/2, length(Yf)); 

G_f = fft(g_n, length(g_n));
G_f = fftshift(abs(G_f));
vector_frec_Gf = linspace(-fs_gn/2, fs_gn/2, length(G_f));

figure;
subplot(2,1,1);
plot(vector_frec_Yf, Yf);
ylabel('|Yf(f)|');
xlabel('Frecuencia [Hz]');
axis([-4000 4000 0 inf]);
title('Espectro de y(t)');
grid on;

subplot(2,1,2);
plot(vector_frec_Gf, G_f);
ylabel('|Gf(f)|');
xlabel('Frecuencia [Hz]');
axis([-4000 4000 0 inf]);
title('Espectro de g(t)');
grid on;

% NORMALIZADO
Y_f_norm = (fft(y_n, length(y_n)))/length(y_n);
Y_f_norm = fftshift(abs(Y_f_norm));
vector_frec_Yf_norm = linspace(-fs_xn/2, fs_xn/2, length(Y_f_norm)); 

G_f_norm = (fft(g_n, length(g_n)))/length(g_n);
G_f_norm = fftshift(abs(G_f_norm));
vector_frec_Gf_norm = linspace(-fs_gn/2, fs_gn/2, length(G_f_norm));

figure;
subplot(2,1,1);
plot(vector_frec_Yf_norm, Y_f_norm);
ylabel('|Yf(f)|');
xlabel('Frecuencia [Hz]');
axis([-4000 4000 0 inf]);
title('Espectro de y(t) - Normalizada');
grid on;

subplot(2,1,2);
plot(vector_frec_Gf_norm, G_f_norm);
ylabel('|Gf(f)|');
xlabel('Frecuencia [Hz]');
axis([-4000 4000 0 inf]);
title('Espectro de g(t) - Normalizada');
grid on;

%% Interpolación por un factor entero
%% b)
L = 2;
[h_n, vector_tiempos_hn] = Interpolador(y_n, vector_tiempo_yn, L);

disp(length(h_n));
disp(length(y_n));
y_n(1:6)
h_n(1:6)

%% c)
fs_hn = L * fs_xn;

%% d)
fc = (1/L) * fs_xn;
k_n = Filtro(h_n, fs_hn, L, fc);

%% g)
figure;
plot(vector_tiempo_yn, y_n, 'black o');
hold on;
plot(vector_tiempos_hn, h_n, 'r *');
ylabel('Amplitud [V/V]');
xlabel('Tiempo [seg]');
title('Comparación señales y(t) y h(t)');
legend('y(t) - Original', 'h(t) - Interpolada');
grid on;

limite_inferior = zeros(1,9);
limite_superior = k_n(10:1:end);
k_n = [limite_inferior limite_superior];

figure;
plot(vector_tiempos_hn, h_n, 'black o');
hold on;
plot(vector_tiempos_hn, k_n, 'r *');
ylabel('Amplitud [V/V]');
xlabel('Tiempo [seg]');
title('Comparación entre h(t) y k(t)');
legend('h(t) - Interpolada','k(t) - Filtrada');
grid on;

%% h)
Yf = fft(y_n, length(y_n));
Yf = fftshift(abs(Yf));
vector_frec_Yf = linspace(-fs_xn/2, fs_xn/2, length(Yf));

Hf = fft(h_n, length(h_n));
Hf = fftshift(abs(Hf));
vector_frec_Hf = linspace(-fs_gn/2, fs_gn/2, length(Hf));

Kf = fft(k_n, length(k_n));
Kf = fftshift(abs(Kf));
vector_frec_Kf = linspace(-fs_gn/2, fs_gn/2, length(Kf));

% SIN NORMALIZAR
figure;
subplot(3,1,1);
plot(vector_frec_Yf, Yf);
ylabel('|Yf(f)|');
xlabel('Frecuencia[Hz]');
axis([-4000 4000 0 inf]);
title('Espectro y[n]');
grid on;

subplot(3,1,2);
plot(vector_frec_Hf, Hf);
ylabel('|Hf(f)|');
xlabel('Frecuencia[Hz]');
axis([-4000 4000 0 inf]);
title('Espectro de h[n]');
grid on;

subplot(3,1,3);
plot(vector_frec_Kf, Kf);
ylabel('|Kf(f)|');
xlabel('Frecuencia[Hz]');
axis([-4000 4000 0 inf]);
title('Espectro de k[n]');
grid on;

%% Cambio de frecuencia de muestreo por un factor racional
%% b)
L = 4;
[h_n,tiempos_h_n] = Interpolador(y_n,vector_tiempo_yn,L);

%% c)
fs_gn = fs_xn * L;

%% d)
fc_filtro_hn= (1/(2*L))*fs_gn;
k_n = Filtro(h_n, fs_gn, L, fc_filtro_hn);

% quitar el retraso
limite_inferior = zeros(1,18);
limite_superior = k_n(19:1:end);
k_n = [limite_inferior limite_superior];

vector_tiempo_kn = linspace(0, length(k_n)*(1/fs_gn), length(k_n));

%% f)
M = 3;
[g_n,vector_tiempos_gn] = Diezmador(k_n,vector_tiempo_kn,M);

%% g) 
figure;
plot(vector_tiempo_yn,y_n, 'b *');
hold on;
plot(vector_tiempo_kn,k_n,'black +');
hold on;
plot(vector_tiempos_gn,g_n, 'r o');
grid on;
legend('y(t) - Original','k(t) - Filtrada', 'g(t) - Diezmada');
xlabel('Tiempo (seg)');
axis([0.0325 0.03256 0 0.05]);
ylabel('Amplitud(V)');
title('Representacion temporal del cambio de fs por factor racional')

%% h)
Hf = fft(h_n, length(h_n));             
Hf= fftshift(abs(Hf));                                
frecuencias_H_N= linspace(-fs_gn/2, fs_gn/2, length(Hf));

Kf = fft(k_n, length(k_n)); 
Kf = fftshift(abs(Kf));
vector_frec_Kf= linspace(-fs_gn/2, fs_gn/2, length(Kf));

frec_muestreo_gn = 1/(vector_tiempos_gn(2)-vector_tiempos_gn(1));
G_f= fft(g_n, length(g_n));
G_f= fftshift(abs(G_f));
vector_frec_Gf= linspace(-frec_muestreo_gn/2, frec_muestreo_gn/2, length(G_f));

figure;
subplot(4,1,1);
plot(vector_frec_Yf, Yf);
ylabel('|Yf(f)|');
xlabel('Frecuencia[Hz]');
axis([-4000 4000 0 inf]);
title('Espectro de señal y[n] - ORIGINAL');
grid on;

subplot(4,1,2);
plot(frecuencias_H_N, Hf);
ylabel('|Hf(f)|');
xlabel('Frecuencia[Hz]');
axis([-4000 4000 0 inf]);
title('Espectro de h[n] - INTERPOLADA');
grid on;

subplot(4,1,3)
plot(vector_frec_Kf, Kf);
ylabel('|Kf(f)|');
xlabel('Frecuencia[Hz]');
axis([-4000 4000 0 inf]);
title('Espectro de k[n] - FILTRADA');
grid on;

subplot(4,1,4)
plot(vector_frec_Gf, G_f);
ylabel('|G_f(f)|');
xlabel('Frecuencia[Hz]');
axis([-4000 4000 0 inf]);
title('Espectro de gn[n] - DIEZMADA' );
grid on;