%% PRÁCTICA 3
%% Filtrado de señales
load ('PDS_P3_3A_LE2_G6.mat'); % cargamos el archivo
load('coeficientesFiltros.mat') % para que el corrector tenga en el workspace los coeficientes del filtro

%% a)
Ts = t(2) - t(1);
fs = 1/Ts;

%% b) -- Convolución 
% k = numero de coeficeintes del filtro --> añadir k ceros

yn = zeros(1, length(x) + length(b) - 1);

for i=1:length(x)+length(b)-1 % para cada valor de x[n] 
    aux = zeros(1, length(b)); %vector auxiliar para guardar productos parciales
    for k = 1:length(b) %producto de la señal desplazada con los coeficientes del filtro siempre que el indice este dentro de los limites
      if(i >= k)
           if((i-k+1) <= length(x))
             aux(k) = b(k) * x(i-k+1);
           end
       end
    end
    yn(i) = sum(aux);
end

%% c) -- Convolución con función de Matlab
gn = conv(b, x);

%% d) -- Filtrado con función Matlab
hn = filter(b, 1, x);

%% e)
%Es importante tener en cuenta el cambio de dimensionalidad para calcular
%los vectores de tiempos

%Definimos como salto T_s el periodo de muestreo

vec_temp_yn = linspace(0, length(yn)*Ts, length(yn));
vec_temp_gn = vec_temp_yn;
vec_temp_hn = linspace(0, length(hn)*Ts, length(hn));

figure;
hold on;
plot(t,x, 'b');
plot(vec_temp_yn, yn, '*');
plot(vec_temp_gn, gn, 'black');
plot(vec_temp_hn, hn, 'g');
title('Representación temporal');
xlabel('Tiempo [seg]');
ylabel('Amplitud [V/V]');
legend('Señal original', 'Filtrado con convolucion manual', 'Función conv()', 'Función filter()');
grid on;
axis([0.0997 0.1005 -inf inf]);


%% f)
valores_n = 1:1:101; % vector con coeficientes del filtro

figure;
plot(valores_n, b);
title('Coeficientes del filtro');
xlabel('n');
ylabel('Amplitud [V/V]');
legend('b[n]');
grid on;

% retardo de grupo --> (L - 1) / 2
retardo_grupo =((length(b)-1) / 2)*Ts;

%% g)
Xf = fft(x,length(x));
Xf = fftshift(abs(Xf));
vector_frec_xn = linspace(-fs/2,fs/2,length(x));

Yf = fft(yn, length(yn));
Yf = fftshift(abs(Yf));
vector_frec_yn = linspace(-fs/2,fs/2,length(yn));

Gf = fft(gn, length(gn));
Gf = fftshift(abs(Gf));
vector_frec_gn = linspace(-fs/2,fs/2,length(gn));

Hf = fft(hn, length(hn));
Hf = fftshift(abs(Hf));
vector_frec_hn = linspace(-fs/2,fs/2 ,length(hn));

figure;
subplot(4,1,1);
plot(vector_frec_xn, Xf);
title('Espectro x[n]');
xlabel('Frecuencia [Hz]');
ylabel('|Xf|');
subplot(4,1,2);
plot(vector_frec_yn,Yf);
title('Espectro y[n]');
xlabel('Frecuencia [Hz]');
ylabel('|Yf|');
subplot(4,1,3);
plot(vector_frec_gn,Gf);
title('Espectro g[n]');
xlabel('Frecuencia[Hz]');
ylabel('|Gf|');
subplot(4,1,4);
plot(vector_frec_hn,Hf);
title('Espectro h[n]');
xlabel('Frecuencia [Hz]');
ylabel('|Hf|');

figure;
plot(vector_frec_xn, Xf);
xlabel('Frecuencia [Hz]');
ylabel('|Xf|');
hold on
plot(vector_frec_yn,Yf);
xlabel('Frecuencia [Hz]');
ylabel('|Yf|');
hold on
plot(vector_frec_gn, Gf);
xlabel('Frecuencia[Hz]');
ylabel('|Gf|');
hold on
plot(vector_frec_hn, Hf);
title('Comparación espectros');
xlabel('Frecuencia [Hz]');
ylabel('|Mod|');
legend('Señal original', 'Filtrado con convolucion manual', 'Función conv()', 'Función filter()');
grid on

%% Diseño de filtros FIR
%% a) y b)
figure;
plot(vector_frec_xn, Xf);
title('Espectro señal x[n]');
xlabel('Frecuencia [Hz]');
ylabel('|Xf|');
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
plot(vector_frec_xn, Xf);
title('Espectro señal x[n]');
xlabel('Frecuencia[Hz]');
ylabel('|Xf()|');
grid on;

subplot(2,1,2);
plot(frecuencias_z_n, Z_N);
title('Espectro señal filtrada con LPF');
xlabel('Frecuencia[Hz]');
ylabel('|Zf()|');
grid on;


%% apartados c) y d)

% Diseñamos el filtro paso alto que elimina la continua y los armónicos
% fundamentales de frecuencias de 9KHz y 10KHz

% Los coeficientes quedan guardados en la variable highpass


wn = conv(highpass, x); %sometemos a la señal a nuestro filtro paso alyo

%Calculo el espectro sin normalizar y lo centro
Wf = fft(wn, length(wn));
Wf = fftshift(abs(Wf));

%Vector de frecuencias
vector_frec_wn= linspace(-fs/2, fs/2, length(Wf));

%Representamos espectro original y tras filtrado
figure;
subplot(2,1,1);
plot(vector_frec_xn, Xf);
title('Espectro señal x[n]');
xlabel('Frecuencia[Hz]');
ylabel('|Xf()|');
grid on;

subplot(2,1,2);
plot(vector_frec_wn, Wf);
title('Espectro señal filtrada con HPF');
xlabel('Frecuencia[Hz]');
ylabel('|Wf()|');
grid on;

%% Superposicion de filtros
%% a)
% Obtenemos la señal yn sometiendo a un filtrado paso bajo a la señal x
yn = conv(lowpass, x);

%% b)
% Obtenemos la señal gn sometiendo a un filtrado paso alto a la señal y
gn = conv(highpass, yn);

%% Apartado c)
% Diseñamos un filtro paso banda con las frecuencias de corte superior e
% inferior empleadas para los filtros paso bajo y paso alto,
% respectivamente

% Obtenemos la señal h[n] como resultado de filtrar x(t) usando el nuevo
% filtro
hn = conv(bandpass, x);

%% d) 
vector_frec_xn = linspace(-fs/2, fs/2, length(x));
vector_frec_yn = linspace(-fs/2, fs/2, length(yn));
vector_frec_gn = linspace(-fs/2, fs/2, length(gn));

% En una misma linea calculo transformada rápida y centro espectro
Xf=fftshift(abs(fft(x, length(x))));
Yf=fftshift(abs(fft(yn, length(yn))));
Gf=fftshift(abs(fft(gn, length(gn))));

figure;
subplot(3,1,1);
plot(vector_frec_xn, Xf);
title('Espectro señal x[n]');
xlabel('Frecuencia [Hz]');
ylabel('|Xf()|');
grid on;

subplot(3,1,2);
plot(vector_frec_yn, Yf);
title('Espectro después de LPF');
xlabel('Frecuencia [Hz]');
ylabel('|Yf()|');
grid on;

subplot(3,1,3);
plot(vector_frec_gn, Gf);
title('Espectro después de LPF+HPF');
xlabel('Frecuencia [Hz]');
ylabel('|Gf()|');
grid on;

%% e)
vector_frec_hn= linspace(-fs/2, fs/2, length(hn));

Hf = fftshift(abs(fft(hn, length(hn))));

figure;
subplot(3,1,1);
plot(vector_frec_xn, Xf);
title('Espectro señal x[n]');
xlabel('Frecuencia [Hz]');
ylabel('|Xf()|');
grid on;

subplot(3,1,2);
plot(vector_frec_gn, Gf);
title('Espectro después de LPF+HPF');
xlabel('Frecuencia [Hz]');
ylabel('|Gf()|');
grid on;

subplot(3,1,3);
plot(vector_frec_hn, Hf);
title('Espectro después de filtro paso banda');
xlabel('Frecuencia [Hz]');
ylabel('|Hf()|');
grid on;

%% Orden del filtro 
%% a) 
% Abrimos la sesion que habiamos creado para el diseño del filtro paso bajo
% y exportamos los coeficientes al workspace para los nuevos filtros
% utilizando nombres de variables descriptivos que permiten identificar el
% orden

%% b) 
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


%% c)
% El calculo para el retardo de grupo retardo_s=muestras*Periodo de muestreo

retardo_10= ((length(lowpass10)-1)/2)*Ts*1000; %El por 1000 para pasarlo a ms
retardo_20= ((length(lowpass20)-1)/2)*Ts*1000;
retardo_50= ((length(lowpass50)-1)/2)*Ts*1000;
retardo_100= ((length(lowpass)-1)/2)*Ts*1000; 