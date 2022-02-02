%% PRACTICA 1

%  Procesamiento digital de la señal
%  Fecha: 12/02/2021
%  Grupo: Álvaro Prado Moreno y Javier Álvarez Martínez


%% EJERCICIO 1: Muestreo

load ('PDS_P1_3A_LE1_G2.mat'); %cargamos el archivo

%% Apartado a)

Ts=t(3)-t(2);   %La diferencia entre dos valores del vector de tiempos nos da el periodo

fs= (1/Ts); %Hallamos la frecuencia de muestreo


%% Apartado b)

X_f= fft(x, length(x)) / length(x); %Hallo transformada de la x(t) (solo replica fundamental)

X_f=fftshift(X_f); %Centro en 0 el espectro

n=length(t);

fn=linspace((-fs/2), (fs/2), n); %Creo vector de frecuencias para respresentar espectro

figure;
plot(fn, abs(X_f));
xlabel("frecuencia (Hz)");
ylabel("|X_f|");
title("Transformada de Fourier de x(t)");
grid on;


bw=16000;     %Obtenemos el band-width observando el especto

fs_min=2*bw;  %Aplicamos la regla de nyquist y hallamos la fs minima


%% apartado c)


%Defino las nuevas frecuencias de muestreo

fs_g= 1.5*fs_min; 
fs_h= ((2*fs_min)/3); 


%Hallo nuevos periodos

ts_g=1/fs_g;
ts_h=1/fs_h;

%Defino los nuevos vectores temporales

temp_g= t(1):ts_g:t(end);
temp_h= t(1):ts_h:t(end);


%Nuevas señales, resultado de muestrear la señal original

g=interp1(t,x,temp_g,'spline'); % Muestreo con fs>fs_min
h=interp1(t,x, temp_h, 'spline'); % Muestreo con fs<fs_min



%% apartado d)


%Hallo las transformadas

G_f= fft(g, length(g))/(length(g));
H_f= fft(h, length(h))/(length(h));

%Centro espectros

G_f=fftshift(G_f);
H_f=fftshift(H_f);


%hallo los vectores de frecuencias para cada transformada

fn_g=linspace((-fs_g/2), (fs_g/2), length(g));
fn_h=linspace((-fs_h/2), (fs_h/2), length(h));


%represento todo junto

figure;
hold on
plot(fn, abs(X_f), 'b')
plot(fn_g, abs(G_f), 'y')
plot(fn_h, abs(H_f), 'r');
xlabel("f (Hz)");
ylabel("Modulos");
legend('X:original', 'G: fs>fs_N', 'H: fs<fs_N')
axis([-17000 17000 0 10]);
grid on;


%% Para verlo en cuadricula
% 
% figure;
% subplot(2,2,1);
% plot(fn_g, abs(G_f), 'y')
% xlabel("f (Hz)");
% ylabel("|G(f)|");
% axis([-17000 17000 0 10]);
% grid on;
% 
% 
% subplot(2,2,2);
% plot(fn_h, abs(H_f), 'r');
% xlabel("f (Hz)");
% ylabel("|H(f)|");
% axis([-17000 17000 0 10]);
% grid on;
% 
% 
% subplot(2,2,[3,4]);
% plot(fn, abs(X_f), 'b')
% xlabel("f (Hz)");
% ylabel("|X(f)|");
% axis([-17000 17000 0 10]);
% grid on;

%% apartado e)

%Creamos una nueva figura para la representacion temporal

figure;
hold on;
plot(t, x, 'b')
plot(temp_g, g , 'y') %Cada señal tiene su referencia temporal 
plot(temp_h, h, 'r');
xlabel("Tiempo (s)");
ylabel("Amplitud (V)");
title('Representacion temporal de las tres señales');
legend('x(t)','g(t)','h(t)');
axis([0 0.0008 -10 20]); %ajustamos el eje x para distinguir las señales
grid on;




%% EJERCICIO 2: Cuantificación

%% Apartado f) 

%Siempre 1 bit de signo


%Caso 1: 3 bits parte entera y 0 decimal 

q = quantizer('fixed', 'round', 'saturate', [4, 0]); % Creo escala

y1=num2bin(q,k);  % Obtengo equivalencia en binario aplicando escala
ks30=bin2num(q,y1); %Recupero señal digital de la equivalencia binaria

%Caso 2: 1 bit parte entera 2 decimal

q = quantizer('fixed', 'round', 'saturate', [4, 2]);

y2=num2bin(q, k);
ks12=bin2num(q,y2);


%Caso 3: 3 bits parte entera 2 decimal

q = quantizer('fixed', 'round', 'saturate', [6, 2]);

y3=num2bin(q,k);
ks32=bin2num(q,y3);


%Caso 4: 5 bits parte entera 0 decimal

q = quantizer('fixed', 'round', 'saturate', [6, 0]);

y4=num2bin(q,k);
ks50=bin2num(q,y4);


%% Apartado g) -> tiempo

%Representamos las señales recuperadas y la original 

%t_k es el vector temporal que no varia para ninguna de las señales

figure;

hold on
plot(t_k, k, 'b-*');    %Señal original marcada
plot(t_k, ks30, 'r-o'); %La hemos marcado porque solapa con ks50
plot(t_k, ks12, 'y');
plot(t_k, ks32, 'black');
plot(t_k, ks50, 'green');

legend('original', '3 ent 0 dec','1 ent 2 dec','3 ent 2 dec', '5 ent 0 dec');
xlabel('Tiempo(s)');
ylabel('Amplitud(V)');
title('Cuantificación comparativa en el tiempo');
axis([0 0.001 -4 7]); %Conocida la grafica original se ajustan ejes para distinguir señales
grid on;


maximo = max(k);%vemos el valor máximo de la señal
minimo = min(k);%vemos el valor mínimo de la señal

%% Apartado g) -> frecuencia

%Diferencias de las señales en el dominio de la frecuencia

%Primero hallamos las transformadas

K_f= fft(k, length(k)) / length(k); %Hallamos la transformada de fourier
K_f=fftshift(K_f); %Centramos la señal en 0

Ks30_f= fft(ks30, length(k)) / length(k); 
Ks30_f=fftshift(Ks30_f);

Ks12_f= fft(ks12, length(k)) / length(k);
Ks12_f=fftshift(Ks12_f);


%Representamos las señales en el dominio de la frecuencia

f_k= 1/t_k(2); %hallo la frecuencia de la señal
vector_f= linspace(-f_k/2, f_k/2, length(k)); %construyo vector de frecuencias para la representacion


figure;
hold on;
plot(vector_f, abs(K_f), 'b-*');
plot(vector_f, abs(Ks30_f), 'r');
plot(vector_f, abs(Ks12_f), 'g');
grid on;
xlabel('Frecuencia(Hz)');
ylabel('Amplitud(V)');
title('Cuantificación comparativa en frecuencia');
legend('K_f','Ks30_f','Ks12_f');
grid on;



%% Apartado h)

%Calculo de errores cuadráticos medios

ecm_s30 = 1/length(k)*sum(abs(k-ks30).^2);%ECM entre señal original y señal cuantificada con 3 bits parte entera y 0 decimal
ecm_s12 = 1/length(k)*sum(abs(k-ks12).^2);%ECM entre señal original y señal cuantificada con 1 bit parte entera y 2 decimal
ecm_s32 = 1/length(k)*sum(abs(k-ks32).^2);%ECM entre señal original y señal cuantificada con 3 bits parte entera y 2 decimal
ecm_s50 = 1/length(k)*sum(abs(k-ks50).^2);%ECM entre señal original y señal cuantificada con 5 bits parte entera y 0 decimal

%% EJERCICIO 3 : Señal de audio

%%
[sa_x,f_aud]= audioread('PDS_P1_3A_LE1_G2.wav'); %Cargamos el archivo de audio
t_aud = 1/f_aud;
tiempo_sa_x=linspace(0,length(sa_x)*t_aud,length(sa_x));

figure;%Representamos la señal original de audio
plot(tiempo_sa_x,sa_x);
ylabel('Amplitud(V)');
xlabel('Tiempo [s]');
ylim([-1 1]);
grid on;
title('Señal de audio original');

%Cálculo los valores máximo y mínimo de amplitud de la señal
maximo_audio = max(sa_x);
minimo_audio = min(sa_x);

posiciones= find(abs(sa_x)>0.01); %Nos quedamos con los indices de los valores que cumplen ser mayores de 0,01V 

y=sa_x(posiciones(1):1:posiciones(end)); %Extraemos los valores mediante los indices

tiempo_y = linspace(0,length(y)*t_aud,length(y));

%% Cuantificación uniforme de la señal de audio

q = quantizer('fixed', 'round', 'saturate', [7, 6]); %escala de cuantificación de 7 bits totales de los cuales 6 son para parte decimal y uno para bit de signo

sa_y=num2bin(q,y);  % Obtengo equivalencia en binario aplicando escala
qu =bin2num(q,sa_y); %Recupero señal digital de la equivalencia binaria


%% EJERCICIO 4: Cuantificación no uniforme 


%% Apartado b) representación de los bloques compresor y expansor
valores = linspace(-1,1,100); %conjunto de muestras a evaluar por los bloques
A = 87.6;

respuesta_compresor = Compresor(valores,A);
respuesta_expansor = Expansion(valores,A);

figure;
subplot(2,1,1);
plot(valores,respuesta_compresor);
title('Bloque compresor');
xlabel('valores de entrada (-1:1)');
ylabel('Fa(x)');
grid on;
subplot(2,1,2);
plot(valores,respuesta_expansor);
title('Bloque expansor');
ylabel('Fa^-1(x)');
xlabel('valores de entrada (-1:1)');
grid on;

%% Apartado c) Cuantificación no uniforme de la señal de audio

y_compresor = Compresor(y,A);%Primero comprimimos la señal original
q_binario = num2bin(q,y_compresor);%Realizamos cuantificación usando la escala creada en el apartado de cuantificación uniforme
q_decimal = bin2num(q,q_binario);%Pasamos los niveles de amplitud cuantificados en binario a decimal
qnu = Expansion(q_decimal,A);%Expandimos la señal
qnu = transpose(qnu);%Ponemos como vector columna los valores de salida



%% Análisis de la cuantificación

%% apartado a) Comparación cualitativa
sound(sa_x,f_aud); %Archivo de voz original
pause(6);
sound(qu,f_aud); %Archivo de voz tras la cuantificación uniforme
pause(6);
sound(qnu,f_aud); %Archivo de voz tras la cuantificación no uniforme

%% apartado b) Representación temporal
figure; %comparacion entre señal original de audio, señal cuantificada uniformemente y señal cuantificada no uniformemente
plot(tiempo_sa_x,sa_x, 'b');
hold on;
plot(tiempo_y,qu, 'r *');
hold on;
plot(tiempo_y,qnu, 'g o');
grid on;
ylim([-1 1]);
xlim([0 6]);
ylabel('Amplitud[V]');
xlabel('Tiempo[s]');
ylim([-0.4 0.4]);
xlim([2.12 2.18]);
title('Comparación temporal de las señales');
legend('original','cuant-Uniforme','cuant-No-Uniforme');

%% apartado c) Comparación cuantitativa
%evaluamos el error cuadrático con la señal y(señal filtrada) para que las
%dimensiones concuerden
ecm_qu = 1/length(y)*sum(abs(y-qu).^2);%error cuadrático medio entre señal original y señal cuantificada uniformemente
ecm_qnu = 1/length(y)*sum(abs(y-qnu).^2);%error cuadrático medio entre señal original y señal cuantificada no uniformemente
