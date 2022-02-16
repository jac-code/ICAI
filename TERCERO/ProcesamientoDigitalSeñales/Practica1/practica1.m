%% PR¡CTICA 1
%% Muestreo
load ('PDS_P1_3A_LE2_G6.mat');

%% a)
Ts = t(4)-t(3); % 6.25 micro seg.
fs = (1/Ts);    % 160 kHz

%% b)
X_f = fft(x, length(x)) / length(x);
X_f = fftshift(X_f);

n = length(t);
fn = linspace((-fs/2), (fs/2), n);

figure;
plot(fn, abs(X_f));
xlabel('frecuencia (Hz)');
ylabel('|X_f|');
title('Transformada de Fourier de x(t)');
grid on;

bw_x = 23500;
fs_nyquist = 2 * bw_x;

%% c)
fs_g = 1.5 * fs_nyquist; 
fs_h = (2/3) * fs_nyquist;

ts_g = 1/fs_g;
ts_h = 1/fs_h;

temp_g = t(1):ts_g:t(end);
temp_h = t(1):ts_h:t(end);

g = interp1(t, x, temp_g, 'spline');
h = interp1(t, x, temp_h, 'spline');

%% d)
G_f = fft(g, length(g))/(length(g));
H_f = fft(h, length(h))/(length(h));

G_f=fftshift(G_f);
H_f=fftshift(H_f);

fn_g=linspace((-fs_g/2), (fs_g/2), length(g));
fn_h=linspace((-fs_h/2), (fs_h/2), length(h));

figure;
hold on
plot(fn, abs(X_f), 'b')
plot(fn_g, abs(G_f), 'g')
plot(fn_h, abs(H_f), 'r');
xlabel('Frecuencia (Hz)');
ylabel('|MÛdulos|');
title('Transformadas de Fourier');
legend('TDF x(t): SeÒal original', 'TDF g(t): fs > fs de Nyquist', 'TDF h(t): fs < fs de Nyquist')
grid on;

%% e)
figure;
hold on;
plot(t, x, 'b')
plot(temp_g, g , 'g')
plot(temp_h, h, 'r');
xlabel('Tiempo (seg)');
ylabel('Amplitud (V)');
title('Representacion temporal de las tres seÒales');
legend('x(t)', 'g(t)', 'h(t)');
grid on;

%% CuantificaciÛn
%% f) 

% 3 bits parte entera y 0 decimal
q1 = quantizer('fixed', 'round', 'saturate', [4, 0]);
y1=num2bin(q1,k);
ks30=bin2num(q1,y1);

% 1 bit parte entera 2 decimal
q2 = quantizer('fixed', 'round', 'saturate', [4, 2]);
y2=num2bin(q2, k);
ks12=bin2num(q2, y2);


% 3 bits parte entera 2 decimal
q = quantizer('fixed', 'round', 'saturate', [6, 2]);
y3=num2bin(q,k);
ks32=bin2num(q,y3);


% 5 bits parte entera 0 decimal
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
title('CuantificaciÛn comparativa en el tiempo');
axis([0 0.001 -4 7]);
grid on;

%% g)
K_f= fft(k, length(k)) / length(k); 
K_f=fftshift(K_f); 

Ks30_f= fft(ks30, length(k)) / length(k); 
Ks30_f=fftshift(Ks30_f);

Ks12_f = fft(ks12, length(k)) / length(k);
Ks12_f = fftshift(Ks12_f);

f_k = 1/t_k(2); 
vector_f= linspace(-f_k/2, f_k/2, length(k)); 

figure;
hold on;
plot(vector_f, abs(K_f), 'b-*');
plot(vector_f, abs(Ks30_f), 'r');
plot(vector_f, abs(Ks12_f), 'g');
grid on;
xlabel('Frecuencia(Hz)');
ylabel('Amplitud(V)');
title('CuantificaciÛn comparativa en frecuencia');
legend('K_f', 'Ks30_f', 'Ks12_f');
grid on;

%% Apartado h)
ecm_s30 = 1/length(k)*sum(abs(k-ks30).^2);
ecm_s12 = 1/length(k)*sum(abs(k-ks12).^2);
ecm_s32 = 1/length(k)*sum(abs(k-ks32).^2);
ecm_s50 = 1/length(k)*sum(abs(k-ks50).^2);

%% EJERCICIO 3 
%% a)
[y, f]= audioread('PDS_P1_3A_LE2_G6.wav'); %Cargamos el archivo de audio
t = 1/f;
t_y = linspace(0, length(y)*t, length(y));

figure;%Representamos la se√±al original de audio
plot(t_y, y);
ylabel('Amplitud(V)');
xlabel('Tiempo [seg]');
ylim([-1 1]);
grid on;
title('SeÒal de audio original');

pos = find(abs(y) > 0.01); % Nos quedamos con los indices de los valores que cumplen ser mayores de 0,01V 
y_final = y(pos(1):1:pos(end)); %Extraemos los valores mediante los indices
t_y_final = linspace(0, length(y)*t_y, length(y));

%% CuantificaciÛn uniforme de la seÒal de audio

q = quantizer('fixed', 'round', 'saturate', [7, 6]); %escala de cuantificaci√≥n de 7 bits totales de los cuales 6 son para parte decimal y uno para bit de signo
sa_y = num2bin(q, y_final);  % Obtengo equivalencia en binario aplicando escala
qu = bin2num(q, sa_y); %Recupero se√±al digital de la equivalencia binaria


%% CuantificaciÛn no uniforme 
%% b)
valores = linspace(-1,1,100); % este es el vactor de valores
A = 87.6;

respuesta_compresor = Compresor(valores,A);
respuesta_expansor = Expansion(valores,A);

figure;
plot(valores,respuesta_compresor);
title('Bloque compresor');
xlabel('Valores de entrada (-1:1)');
ylabel('Fa(x)');
grid on;

figure()
plot(valores,respuesta_expansor);
title('Bloque expansor');
ylabel('Fa^-1(x)');
xlabel('Valores de entrada (-1:1)');
grid on;

%% c)
y_compresor = Compresor(y,A);%Primero comprimimos la se√±al original
q_binario = num2bin(q,y_compresor);%Realizamos cuantificaci√≥n usando la escala creada en el apartado de cuantificaci√≥n uniforme
q_decimal = bin2num(q,q_binario);%Pasamos los niveles de amplitud cuantificados en binario a decimal
qnu = Expansion(q_decimal,A);%Expandimos la se√±al
qnu = transpose(qnu);%Ponemos como vector columna los valores de salida°

%% An·lisis de la cuantificaciÛn
%% a)
sound(sa_x,f_aud); %Archivo de voz original
pause(6);
sound(qu,f_aud); %Archivo de voz tras la cuantificaci√≥n uniforme
pause(6);
sound(qnu,f_aud); %Archivo de voz tras la cuantificaci√≥n no uniforme

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
title('ComparaciÛn temporal');
legend('Original', 'Cuant-Uniforme', 'Cuant-No-Uniforme');

%% c)
ecm_qu = 1/length(y)*sum(abs(y-qu).^2);
ecm_qnu = 1/length(y)*sum(abs(y-qnu).^2);