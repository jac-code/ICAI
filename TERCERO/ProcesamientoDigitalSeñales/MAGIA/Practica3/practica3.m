%% PRÁCTICA 3

% Procesamiento digital de la señal
% Fecha: 04/03/2021
% Grupo: Javier Álvarez Martínez y Álvaro Prado Moreno

%% Ejercicio 1: Filtrado de señales

load ('PDS_P3_3A_LE1_G2.mat'); %cargamos el archivo
load('coeficientesFiltros.mat') %para que el corrector tenga en el workspace los coeficientes del filtro

%% apartado a)

Ts = t(3)-t(2);%calculamos el período de muestreo
fs = 1/Ts; %obtenemos la frecuencia de muestreo

%% apartado b)

%en una convolucion lineal la longitud del resultado es la suma de
%longitudes de los vectores involucrados -1

y_n = zeros(1,length(x)+length(b)-1); %inicializamos el vector resultado a 0 
    %creamos un vector auxiliar para los productos parciales 

for i=1:length(x)+length(b)-1 % para cada valor de x[n] 
    aux=zeros(1, length(b)); %vector auxiliar para guardar productos parciales
    for k=1:length(b) %producto de la señal desplazada con los coeficientes del filtro siempre que el indice este dentro de los limites
      if(i>=k)
           if((i-k+1)<=length(x))
             aux(k)=b(k)*x(i-k+1);  
           end
       end
    end
    y_n(i)=sum(aux);
end


%% apartado c)


g_n = conv(b,x);%filtrado con la convolución 

%Miramos el workspace y vemos que el resultado es igual que en apartado
%anterior

%por defecto esta función te calcula la circunvolucion completa aunque
%puede modificarse con un tercer parametro

%% apartado d)

h_n = filter(b,1,x);%filtrado con la aplicación de filtros de matlab


%En este caso el resultado tiene el mismo tamaño que la señal x ya que la
%funcion filter de matlab te devuelve un vector de igual tamaño que el
%tercer argumento que le pasas en caso de que sea un vector.
%% apartado e)


%Es importante tener en cuenta el cambio de dimensionalidad para calcular
%los vectores de tiempos

%Definimos como salto T_s el periodo de muestreo

tiempos_y_n = linspace(0,length(y_n)*Ts,length(y_n));
tiempos_g_n = tiempos_y_n;
tiempos_h_n = linspace(0,length(h_n)*Ts,length(h_n));

figure;
hold on;
plot(t,x, 'b');
plot(tiempos_y_n, y_n, '*');
plot(tiempos_g_n, g_n, 'black');
plot(tiempos_h_n, h_n, 'g');
title('Representacion temporal');
xlabel('Tiempo(s)');
ylabel('Amplitud(V)');
legend('Señal original', 'Filtrado con convolucion manual', 'Comando conv', 'Comando filter');
grid on;
axis([0.0997 0.1005 -inf inf]);


%% apartado f)

%Me creo un vector de referencia para los coeficientes del filtro
valores_n= 1:1:101;


figure;
plot(valores_n, b);
title('Coeficientes del filtro');
xlabel('n');
ylabel('Amplitud[V]');
legend('b[n]');
grid on;

% calculo para le retardo de grupo

retardo_grupo=((length(b)-1)/2)*Ts;

%% apartado g)

X = fft(x,length(x)); %transformada rapida de fourier
X = fftshift(abs(X)); %centramos espectro
frecuencias_x = linspace(-fs/2,fs/2,length(x)); %construimos vector de frecuencias

Y_N = fft(y_n, length(y_n));
Y_N=fftshift(abs(Y_N));
frecuencias_y_n = linspace(-fs/2,fs/2,length(y_n));

G_N = fft(g_n, length(g_n));
G_N=fftshift(abs(G_N));
frecuencias_g_n = linspace(-fs/2,fs/2,length(g_n));

H_N = fft(h_n, length(h_n));
H_N=fftshift(abs(H_N));
frecuencias_h_n = linspace(-fs/2,fs/2 ,length(h_n));

%Representamos los espectros de manera consecutiva

figure;
subplot(4,1,1);
plot(frecuencias_x, X);
title('Espectro señal x[n]');
xlabel('Frecuencia[Hz]');
ylabel('|X|');
subplot(4,1,2);
plot(frecuencias_y_n,Y_N);
title('Espectro señal y[n]');
xlabel('Frecuencia[Hz]');
ylabel('|Y|');
subplot(4,1,3);
plot(frecuencias_g_n,G_N);
title('Espectro señal g[n]');
xlabel('Frecuencia[Hz]');
ylabel('|G|');
subplot(4,1,4);
plot(frecuencias_h_n,H_N);
title('Espectro señal h[n]');
xlabel('Frecuencia[Hz]');
ylabel('|H|');

%% Ejercicio 2: Diseño de filtros FIR

%% apartados a) y b) Filtrado paso bajo

% Volvemos a representar el espectro de x[n] para observar los armonicos

figure;
plot(frecuencias_x, X);
title('Espectro señal x[n]');
xlabel('Frecuencia[Hz]');
ylabel('|X(e^ jw)|');
grid on;


%Armonicos con frecuencias mas altas: 51KHz y 64KHz. No obstante hay un
%armonico con frecuencia de 50KHz. La unica manera de cumplir las
%especificaciones es eliminando los 3 en lugar de los 2 superiores

% Tras seguir los pasos tenemos los coeficientes del filtro paso bajo en el
% workspace en la variable lowpass


z_n=conv(lowpass, x); %sometemos a la señal a nuestro filtro

%Calculo el espectro sin normalizar y lo centro
Z_N=fft(z_n, length(z_n));
Z_N=fftshift(abs(Z_N));

%Vector de frecuencias
frecuencias_z_n= linspace(-fs/2, fs/2, length(Z_N));

figure;
subplot(2,1,1);
plot(frecuencias_x, X);
title('Espectro señal x[n]');
xlabel('Frecuencia[Hz]');
ylabel('|X(e^ jw)|');
grid on;

subplot(2,1,2);
plot(frecuencias_z_n, Z_N);
title('Espectro señal filtrada con LPF');
xlabel('Frecuencia[Hz]');
ylabel('|Z(e^ jw)|');
grid on;


%% apartados c) y d) filtrado paso alto

% Volvemos a representar el espectro de x[n] para observar los armonicos

figure;
plot(frecuencias_x, X);
title('Espectro señal x[n]');
xlabel('Frecuencia[Hz]');
ylabel('|X(e^ jw)|');
grid on;


% Diseñamos el filtro paso alto que elimina la continua y los armónicos
% fundamentales de frecuencias de 9KHz y 10KHz

% Los coeficientes quedan guardados en la variable highpass


w_n=conv(highpass, x); %sometemos a la señal a nuestro filtro paso alyo

%Calculo el espectro sin normalizar y lo centro
W_N=fft(w_n, length(w_n));
W_N=fftshift(abs(W_N));

%Vector de frecuencias
frecuencias_w_n= linspace(-fs/2, fs/2, length(W_N));

%Representamos espectro original y tras filtrado
figure;
subplot(2,1,1);
plot(frecuencias_x, X);
title('Espectro señal x[n]');
xlabel('Frecuencia[Hz]');
ylabel('|X(e^ jw)|');
grid on;

subplot(2,1,2);
plot(frecuencias_w_n, W_N);
title('Espectro señal filtrada con HPF');
xlabel('Frecuencia[Hz]');
ylabel('|W(e^ jw)|');
grid on;


%% Ejercicio 3: Superposicion de filtros

%% Apartado a)

% Obtenemos la señal y_n sometiendo a un filtrado paso bajo a la señal x
y_n=conv(lowpass, x);

%% Apartado b)

% Obtenemos la señal g_n sometiendo a un filtrado paso alto a la señal y

g_n=conv(highpass, y_n);

%% Apartado c)

% Diseñamos un filtro paso banda con las frecuencias de corte superior e
% inferior empleadas para los filtros paso bajo y paso alto,
% respectivamente

% Obtenemos la señal h[n] como resultado de filtrar x(t) usando el nuevo
% filtro
h_n=conv(bandpass, x);

%% Apartado d)

% Me creo los vectores de frecuencias 

frecuencias_x= linspace(-fs/2, fs/2, length(x));
frecuencias_y_n= linspace(-fs/2, fs/2, length(y_n));
frecuencias_g_n= linspace(-fs/2, fs/2, length(g_n));

% En una misma linea calculo transformada rápida y centro espectro
X=fftshift(abs(fft(x, length(x))));
Y_N=fftshift(abs(fft(y_n, length(y_n))));
G_N=fftshift(abs(fft(g_n, length(g_n))));

figure;
subplot(3,1,1);
plot(frecuencias_x, X);
title('Espectro señal x[n]');
xlabel('Frecuencia[Hz]');
ylabel('|X(e^ jw)|');
grid on;

subplot(3,1,2);
plot(frecuencias_y_n, Y_N);
title('Espectro después de LPF');
xlabel('Frecuencia[Hz]');
ylabel('|Y(e^ jw)|');
grid on;

subplot(3,1,3);
plot(frecuencias_g_n, G_N);
title('Espectro después de LPF+HPF');
xlabel('Frecuencia[Hz]');
ylabel('|G(e^ jw)|');
grid on;


%% apartado e)


%Nos creammos el vector de frecuencias de la señal h[n]

frecuencias_h_n= linspace(-fs/2, fs/2, length(h_n));

%Calculamos el espectro

H_N=fftshift(abs(fft(h_n, length(h_n))));

% Representamos los espectros de x[n], h[n] y g[n]


figure;
subplot(3,1,1);
plot(frecuencias_x, X);
title('Espectro señal x[n]');
xlabel('Frecuencia[Hz]');
ylabel('|X(e^ jw)|');
grid on;

subplot(3,1,2);
plot(frecuencias_g_n, G_N);
title('Espectro después de LPF+HPF');
xlabel('Frecuencia[Hz]');
ylabel('|G(e^ jw)|');
grid on;

subplot(3,1,3);
plot(frecuencias_h_n, H_N);
title('Espectro después de filtro paso banda');
xlabel('Frecuencia[Hz]');
ylabel('|H(e^ jw)|');
grid on;


%% Ejercicio 4: Orden del filtro 

%% Apartado a) 

% Abrimos la sesion que habiamos creado para el diseño del filtro paso bajo
% y exportamos los coeficientes al workspace para los nuevos filtros
% utilizando nombres de variables descriptivos que permiten identificar el
% orden

%% Apartado b) 

% Utilizamos la función freqz de matlab que te muestra el espectro de los
% filtros

figure;
freqz(lowpass);
title("Orden 100");

figure;
freqz(lowpass50);
title("Orden 50");

figure;
freqz(lowpass20);
title("Orden 20");

figure;
freqz(lowpass10);
title("Orden 10");


%% Apartado c)

% El calculo para el retardo de grupo retardo_s=muestras*Periodo de muestreo

retardo_10= ((length(lowpass10)-1)/2)*Ts*1000; %El por 1000 para pasarlo a ms
retardo_20= ((length(lowpass20)-1)/2)*Ts*1000;
retardo_50= ((length(lowpass50)-1)/2)*Ts*1000;
retardo_100= ((length(lowpass)-1)/2)*Ts*1000; 