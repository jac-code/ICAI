%% PRÁCTICA 2

% Procesamiento digital de la señal
% Fecha: 24/02/2021
% Grupo: Javier Álvarez Martínez y Álvaro Prado Moreno


%% LEER ANTES DE CORRER EL PROGRAMA

% Algunas de las variables utilizadas en los distintos apartados tienen el
% mismo nombre para ayudar a entender el proceso matematico vease fs2 o
% algun nombre de señal. Por tanto, el orden de ejecucion del codigo es muy
% importante si se quieren obtener los resultados esperados.

%% Ejercicio 1: Diezmado por un factor entero

%% Apartado a)

[x,fs1]= audioread('PDS_P2_3A_LE2_G6.wav'); %cargamos el archivo de audio
sound(x,fs1); %reproducimos el archivo

%La frecuencia de muestreo es fs1 devuelta por la funcion audioread

disp(fs1);


%% Apartado b)

T_x = 1/fs1; %Calculamos periodo de la señal
tiempos_x = linspace(0,length(x)*T_x,length(x));%Creamos el vector de tiempos para la representación con saltos igual al periodo

figure; %representamos la señal original
plot(tiempos_x,x);
ylabel('Amplitud [V]');
xlabel('Tiempo[s]');
title('Representación de la señal original x(t)');
grid on;

%% Apartado c)

pos= find(abs(x)>0.01); % indices en x cuyos valores son mayores de 0,01V en módulo
y = x(pos(1):1:pos(end)); %Creamos nueva señal eliminando el principio y el final de la anterior
tiempos_y = linspace(0,length(y)*T_x,length(y)); %nuevo vector de tiempo (menos valores mismo periodo) 


figure; %representamos la nueva señal mas corta por haber aplicado la restriccion
plot(tiempos_y,y);
ylabel('Amplitud [V]');
xlabel('Tiempo[s]');
title('Representación de la señal y(t)');
grid on;

sound(y, fs1); %para ver si distinguimos

%% Apartado d)

%Obtenemos una nueva señal g[n] resultado de diezmar la y[n] por un factor
%M=2

M = 2;
[g,tiempos_g] = Diezmador(y,tiempos_y,M);%llamamos a nuestra función creada

%% Apartado f)

fs2 = fs1/M; % puede calcularse como una division de nuestra frecuencia de entrada

% tambien podria calcularse mediante el nuevo vector de tiempos de g:
% T_g= (tiempos_g(7)-tiempos_g(6));
% fs2= 1/T_g

% Como X e Y tienen la misma frecuencia de muestreo=> en ambos casos la
% nueva frecuencia es la anterior /M

%% Apartado g)

ts2 = 1/fs2;
tiempo_g = linspace(0,length(g)*ts2,length(g));%vector de tiempos para representación de señal g

figure;
plot(tiempos_y,y, 'black *');
hold on;
plot(tiempos_g,g, 'r o');
ylabel('Amplitud[V]');
xlabel('Tiempo[s]');
axis([1.6275 1.628 -0.8 1]); %las señales tienes un periodo muy reducido, hacemos zoom para ver bien la diferencia de valores
title('Comparación señales y(t) y g(t)');
legend('y(t) Original','g(t) Final');
grid on;


% En la imagen puede verse como exactamente la señal g corresponde a 1 de
% cada dos muestras de la señal y

%% Apartado h)

%Para demostrar el proceso de diezmado en el dominio de la frecuencia no
%tenemos mas que representar ambos espectros y ver las diferencias

%Como se indica en la aclaracion de la practica se debe de multiplicar el
%espectro por Fs

Y= fft(y, length(y));              %Transformada rapida de Fourier
Y=fftshift(abs(Y));                                  %Centramos en el 0
frecuencias_Y= linspace(-fs1/2, fs1/2, length(Y)); 

G= fft(g, length(g));
G= fftshift(abs(G));
frecuencias_G= linspace(-fs2/2, fs2/2, length(G));


%Aclaracion: se ha tomado la decision de no normalizar la fft respecto a la
%longitud del vector para poder ver claramente los efectos del diezmado en
%la amplitud de la señal


figure;
subplot(2,1,1);
plot(frecuencias_Y, Y);
ylabel('|Y(f)|');
xlabel('Frecuencia[Hz]');
axis([-4000 4000 0 inf]);
title('Espectro de la señal y(t) ORIGINAL');
grid on;

subplot(2,1,2);
plot(frecuencias_G, G);
ylabel('|G(f)|');
xlabel('Frecuencia[Hz]');
axis([-4000 4000 0 inf]);
title('Espectro de la señal g(t) DIEZMADA');
grid on;

% Conclusion: Espectro se mantiene=> no pierdo info

% Importante que tu fs>=2*BW => 1/M>= 2*BW=> 1/(2*M)>=BW 


%% Ejercicio 2: Interpolación por un factor entero

%% Apartado b): Realizamos interpolacion

L = 2;
[h, tiempos_h] = Interpolador(y,tiempos_y,L);

% Puede comprobarse que ha ido bien mirando el tamaño de h y los valores de
% h respecto a y


disp(length(h));
y(1:6)
h(1:6)

%% Apartado c): nueva frecuencia de muestreo

fs2 = L*fs1;

%Otra manera: haciendo uso del nuevo vector temporal generado por la
%funcion interpolador
%fs2_prima=1/(tiempos_h(3)-tiempos_h(2));

%% Apartado d): filtrado de la señal

fc_digital=(1/(2*L)); %fc_digital = BW de la señal digital+efecto de interpolacion
fc_analogica= (1/(2*L))*fs2; %pasamos a analógico con el producto por fs2


k= Filtro(h, fs2, L, fc_analogica); %La ganancia del filtro deberá ser L por la pérdida en potencia al filtrar el resto de replicas


%% Apartados e) y f) justificar la eleccion realizada

% La justificación se ha realizado en el informe

%% Apartado g)

figure;
plot(tiempos_y,y, 'black o');
hold on;
plot(tiempos_h,h, 'r *');
ylabel('Amplitud [V/V]');
xlabel('Tiempo [seg]');
axis([1.6275 1.6276 -0.8 1]); %las señales tienes un periodo muy reducido, hacemos zoom para ver bien la diferencia de valores
title('Comparación y(t) y h(t)');
legend('y(t) - Original','h(t) - Interpolada');
grid on;


%Para definir nuestra señal retrasada empezamos a tomar muestras a partir
%de un t determinado

%Para ver cuanto tengo que retrasar la señal k(t) miro la diferencia
%temporal y multiplico por la frecuencia=muestras/s *s= muestras

%0.0000468 = diferencia temporal 
% muestras a eliminar= 9 muestras

auxiliar = zeros(1,9);
auxiliar2 = k(10:1:end);

k = [auxiliar auxiliar2];

figure;
plot(tiempos_h,h, 'black o');
hold on;
plot(tiempos_h,k, 'r *');
ylabel('Amplitud[V]');
xlabel('Tiempo[s]');
axis([0.0325 0.03256 -0.01 0.05]); %Ampliamos mucho para poder ver que ocurre
title('Comparación señales h(t) y k(t)');
legend('h(t) resultado interpolacion','h(t) despues de filtrado');
grid on;


figure;
plot(tiempos_h,h, 'black o');
hold on;
plot(tiempos_h,k, 'r *');
hold on;
plot(tiempos_y, y, 'g +');
ylabel('Amplitud[V]');
xlabel('Tiempo[s]');
axis([0.0325 0.03256 -0.01 0.05]); %Ampliamos mucho para poder ver que ocurre
title('Comparación señales h(t) y k(t)');
legend('h(t) - Interpolada','k(t) - Filtrada', 'y(t) - Original');
grid on;

%% Apartado h)

Y= fft(y, length(y));                 %Transformada rapida de Fourier
Y=fftshift(abs(Y));                                 %Centramos en el 0
frecuencias_Y= linspace(-fs1/2, fs1/2, length(Y));  %Vector de frecuencias analógicas

H=fft(h, length(h));                %A parte de la frecuencia de muestreo multiplicamos por 2 para la amplitud 
H= fftshift(abs(H));                                %sea igual que la de Y
frecuencias_H= linspace(-fs2/2, fs2/2, length(H));

K=fft(k, length(k)); %Lo multiplicamos por la ganancia del filtro 
K= fftshift(abs(K));
frecuencias_K= linspace(-fs2/2, fs2/2, length(K));

%Aclaracion: se han representado los espectros sin normalizar respecto al
%numero de muestras para poder observar los efectos de la interpolacion en
%la amplitud

figure;
subplot(3,1,1);
plot(frecuencias_Y, Y);
ylabel('|Yf(f)|');
xlabel('Frecuencia[Hz]');
axis([-4000 4000 0 inf]);
title('Espectro de y[n]');
grid on;

subplot(3,1,2);
plot(frecuencias_H, H);
ylabel('|Hf(f)|');
xlabel('Frecuencia[Hz]');
axis([-4000 4000 0 inf]);
title('Espectro de h[n]');
grid on;

subplot(3,1,3);
plot(frecuencias_K, K);
ylabel('|Kf(f)|');
xlabel('Frecuencia[Hz]');
axis([-4000 4000 0 inf]);
title('Espectro de k[n]');
grid on;





%% Ejercicio 3: Cambio de frecuencia de muestreo por un factor racional

%% Apartado a)

% Realizado en el informe. El factor es de K=4/3=L/M

%% Apartado b)

L = 4;
[h_n,tiempos_h_n] = Interpolador(y,tiempos_y,L);


%% Apartado c)

fs2=fs1*L;

%La nueva frecuencia de muestreo es 4 veces la anterior=> 384 KHz
%Otra manera: fs2 = 1/(tiempos_h_n(3)-tiempos_h_n(2));

%% Apartado d)

fc_digital_h=(1/(2*L)); %fc_digital = BW de la señal digital+efecto de interpolacion
fc_analogica_h= (1/(2*L))*fs2; %pasamos a analógico con el producto por fs2

k= Filtro(h_n, fs2, L, fc_analogica_h); %La ganancia del filtro deberá ser L por la pérdida en potencia al filtrar el resto de replicas

% Usamos el mismo codigo de antes pero cambiando el numero de muestras
% mirando la grafica

auxiliar=zeros(1,18);  %19 muestras a 0 que se añaden al final
auxiliar2=k(19:1:end); %empiezo a coger muestras a partir de la 10

k=[auxiliar auxiliar2];

tiempos_k=linspace(0, length(k)*(1/fs2), length(k));

%% Apartado e)

% Respondido en el informe

%% Apartado f)

M = 3;
[g,tiempos_g] = Diezmador(k,tiempos_k,M);%llamamos a nuestra función creada

%% Apartado g) 
figure;
plot(tiempos_y,y, 'b *');
hold on;
plot(tiempos_k,k,'black +');
hold on;
plot(tiempos_g,g, 'r o');
grid on;
legend('y(t) - Original','k(t) - Filtrada ','g(t) - Diezmada');
axis([0.0325 0.03256 -0.01 0.05]);
xlabel('Tiempo [seg]');
ylabel('Amplitud [V/V]');
title('Representacion temporal del cambio de fs por un factor racional')

%% Apartado h)

H_N = fft(h_n, length(h_n));             
H_N= fftshift(abs(H_N));                                
frecuencias_H_N= linspace(-fs2/2, fs2/2, length(H_N));

K= fft(k, length(k)); 
K= fftshift(abs(K));
frecuencias_K= linspace(-fs2/2, fs2/2, length(K));

ts_g = tiempos_g(3)-tiempos_g(2);
fs_g = 1/ts_g;
G= fft(g, length(g));
G= fftshift(abs(G));
frecuencias_G= linspace(-fs_g/2, fs_g/2, length(G));


figure;
subplot(4,1,1);
plot(frecuencias_Y, Y);
ylabel('|Y(f)|');
xlabel('Frecuencia [Hz]');
axis([-4000 4000 0 inf]);
title('Espectro y[n] - ORIGINAL');
grid on;

subplot(4,1,2);
plot(frecuencias_H_N, H_N);
ylabel('|H(f)|');
xlabel('Frecuencia [Hz]');
axis([-4000 4000 0 inf]);
title('Espectro h[n] - INTERPOLADA');
grid on;

subplot(4,1,3)
plot(frecuencias_K, K);
ylabel('|K(f)|');
xlabel('Frecuencia[Hz]');
axis([-4000 4000 0 inf]);
title('Espectro k[n] - FILTRADA');
grid on;

subplot(4,1,4)
plot(frecuencias_G, G);
ylabel('|G(f)|');
xlabel('Frecuencia [Hz]');
axis([-4000 4000 0 inf]);
title('Espectro g[n] - DIEZMADA' );
grid on;


%Aclaracion: se han representado los espectros sin normalizar respecto al
%numero de muestras para poder observar los efectos de la interpolacion, el filtro y el diezmado en
%la amplitud