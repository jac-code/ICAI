%% PRÁCTICA 1 - Muestreo y Cuantificación
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Jaime Arana Cardelús
% Guillermo Fernández Pérez
% 3ºA - GITT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Muestreo
%% a)
load ('PDS_P1_3A_LE2_G6.mat');
Ts = t(4)-t(3); % 6.25 micro seg.
fs = (1/Ts);    % 160 kHz

%% b)
Xf = fft(x, length(x)) / length(x);
Xf = fftshift(Xf);

n = length(t);
fn = linspace((-fs/2), (fs/2), n);

figure;
plot(fn, abs(Xf));
xlabel('frecuencia (Hz)');
ylabel('|Xf|');
title('TDF x(t)');
grid on;

BW_x = 23500;
fs_nyquist = 2 * BW_x;

%% c)
fs_g = 1.5 * fs_nyquist; 
fs_h = (2/3) * fs_nyquist;

ts_g = 1/fs_g;
ts_h = 1/fs_h;

vector_g = t(1):ts_g:t(end);
vector_h = t(1):ts_h:t(end);

g_t = interp1(t, x, vector_g, 'spline');
h_t = interp1(t, x, vector_h, 'spline');

%% d)
Gf = fft(g_t, length(g_t))/(length(g_t));
Hf = fft(h_t, length(h_t))/(length(h_t));

Gf = fftshift(Gf);
Hf = fftshift(Hf);

vector_fg = linspace((-fs_g/2), (fs_g/2), length(g_t));
vector_hf = linspace((-fs_h/2), (fs_h/2), length(h_t));

figure;
hold on
plot(fn, abs(Xf), 'b')
plot(vector_fg, abs(Gf), 'g')
plot(vector_hf, abs(Hf), 'r');
xlabel('Frecuencia (Hz)');
ylabel('|Módulos|');
title('Transformadas de Fourier');
legend('TDF x(t): Señal original', 'TDF g(t)', 'TDF h(t)')
grid on;

%% e)
figure;
hold on;
plot(t, x, 'b')
plot(vector_g, g_t , 'g')
plot(vector_h, h_t, 'r');
xlabel('Tiempo (seg)');
ylabel('Amplitud (V)');
title('Representacion temporal de las tres señales');
legend('x(t)', 'g(t)', 'h(t)');
grid on;

%% Cuantificación Uniforme
% apartados a) - e) se contestan en el informe
%% f) 
% 3 bits parte entera | 0 decimal
q1 = quantizer('fixed', 'round', 'saturate', [4, 0]);
y1=num2bin(q1,k);
ks30=bin2num(q1,y1);

% 1 bit parte entera | 2 decimal
q2 = quantizer('fixed', 'round', 'saturate', [4, 2]);
y2=num2bin(q2, k);
ks12=bin2num(q2, y2);

% 3 bits parte entera | 2 decimal
q = quantizer('fixed', 'round', 'saturate', [6, 2]);
y3=num2bin(q,k);
ks32=bin2num(q,y3);

% 5 bits parte entera | 0 decimal
q = quantizer('fixed', 'round', 'saturate', [6, 0]);
y4=num2bin(q,k);
ks50=bin2num(q,y4);

%% g)

figure;
hold on
plot(t_k, k, 'b-*');
plot(t_k, ks30, 'r-o');
plot(t_k, ks12, 'y');
plot(t_k, ks32, 'black');
plot(t_k, ks50, 'green');
legend('Original', '3 ENT - 0 DEC','1 ENT - 2 DEC','3 ENT - 2 DEC', '5 ENT - 0 DEC');
xlabel('Tiempo(s)');
ylabel('Amplitud(V)');
title('Cuantificación comparativa en el tiempo');
axis([0 0.001 -4 7]);
grid on;

Kf = fft(k, length(k)) / length(k); 
Kf = fftshift(Kf); 

Ks30f = fft(ks30, length(k)) / length(k); 
Ks30f = fftshift(Ks30f);

Ks12f = fft(ks12, length(k)) / length(k);
Ks12f = fftshift(Ks12f);

frecuencia_k = 1 / t_k(2); 
vector_f = linspace(-frecuencia_k/2, frecuencia_k/2, length(k)); 

figure;
hold on;
plot(vector_f, abs(Kf), 'b-*');
plot(vector_f, abs(Ks30f), 'r');
plot(vector_f, abs(Ks12f), 'g');
grid on;
xlabel('Frecuencia(Hz)');
ylabel('Amplitud(V)');
title('Cuantificación comparativa en frecuencia');
legend('Kf', 'Ks30f', 'Ks12f');
grid on;

%% h)
ECMs30 = 1/length(k)*sum(abs(k-ks30).^2);
ECMs12 = 1/length(k)*sum(abs(k-ks12).^2);
ECMs32 = 1/length(k)*sum(abs(k-ks32).^2);
ECMs50 = 1/length(k)*sum(abs(k-ks50).^2);

%% Señal de audio
%% a)
[y, f]= audioread('PDS_P1_3A_LE2_G6.wav');
t = 1/f;
t_y = linspace(0, length(y)*t, length(y));

figure;
plot(t_y, y);
ylabel('Amplitud(V)');
xlabel('Tiempo [seg]');
ylim([-1 1]);
grid on;
title('Señal de audio original');

pos = find(abs(y) > 0.01);
y_final = y(pos(1):1:pos(end));
t_y_final = linspace(0, length(y)*t_y, length(y));

%%
q = quantizer('fixed', 'round', 'saturate', [7, 6]);
sa_y = num2bin(q, y_final);
qu = bin2num(q, sa_y);

%% Cuantificación no uniforme 
% para el apartado a) se han creado las dos funciones
%% b)
vec_valores = linspace(-1,1,100); % este es el vactor de valores
A = 87.6;

res_c = Bloque_Compresor(vec_valores, A);
res_e = Bloque_Expansion(vec_valores, A);

figure;
plot(vec_valores, res_c);
title('Bloque compresor');
xlabel('Valores de entrada (-1:1)');
ylabel('Fa(x)');
grid on;

figure()
plot(vec_valores, res_e);
title('Bloque expansor');
ylabel('Fa^-1(x)');
xlabel('Valores de entrada (-1:1)');
grid on;

%% c)
y_c = Bloque_Compresor(y,A);
q_b = num2bin(q, y_c);
q_d = bin2num(q, q_b);

qnu = Bloque_Expansion(q_d, A);
qnu = transpose(qnu);

%% Análisis de la cuantificación
%% a)
sound(sa_x,f_aud);
sound(qu,f_aud);
sound(qnu,f_aud);

%% b)
figure;
plot(tiempo_sa_x,sa_x, 'b');
hold on;
plot(tiempo_y,qu, 'r *');
hold on;
plot(tiempo_y,qnu, 'g o');
grid on;
ylabel('Amplitud[V]');
xlabel('Tiempo[seg]');
ylim([-0.4 0.4]);
xlim([2.12 2.18]);
title('Comparación temporal');
legend('Original', 'Cuant-Uniforme', 'Cuant-No-Uniforme');

%% c)
ECMqu = 1/length(y)*sum(abs(y-qu).^2);
ECMqnu = 1/length(y)*sum(abs(y-qnu).^2);