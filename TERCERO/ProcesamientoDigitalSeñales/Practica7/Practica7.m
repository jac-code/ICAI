%% Práctica 7
load("PDS_P7_3A_LE1_G2.mat");

%% a)
[dn, fs_dn]=audioread("PDS_P7_3A_LE1_G2_d_n.wav");
%sound(dn, fs_dn);

%% b)
[xn, fs_xn]= audioread("PDS_P7_3A_LE1_G2_x_n.wav");
%sound(xn, fs_xn);

%% Implementación del algoritmo LMS
%Calculamos todos los coeficientes de nuestro filtro

%El set de coeficientes adaptados corresponde al set anterior con
%modificaciones

%W[k+1]= w[k]+2*xn[k]*e[k]*mu

%Inicializacion de los coeficientes del filtro
w= zeros(1, M+1);

%Inicializamos memoria del filtro
memoria= zeros(1, length(w));

%Inicializamos el error 

e=zeros(1, length(xn));

%Matriz que guarda los coeficientes en cada interacion

Matriz_coef=zeros(length(xn), length(w));

%Inicializo la y 

y=zeros(1, length(xn));

for i=1:length(xn)
    
    %Introducimos en la memoria una muestra nueva de xn
    memoria=[xn(i), memoria(1:end-1)];
    
    %y[i]=xn[k]conv wi[k]
    
    y(i)=sum(w.*memoria);
    
    %Calculamos el error: e(i)= dn(i)-y(i)
    e(i)=dn(i)-y(i);
    
    %Nuevo set de coeficientes
    w= w + memoria.*(2*e(i)*mu);
    
    Matriz_coef(i, 1:end)=w;
end

%Acabado el proceso tengo el set de coeficientes bueno

%% Análisis de resultados
%% a)
vector_muestras = 1:1:length(xn);

figure;
hold on;
plot(vector_muestras,dn);
plot(vector_muestras,e);
xlabel("Muestras [n]");
ylabel("Amplitud [V]");
title("Señal original vs señal ruido filtrado");
legend('Señal original con ruido','Señal corregida');
axis([0 length(xn) -1 1]);
grid on;

figure;
subplot(2,1,1);
plot(vector_muestras,dn);
xlabel("Muestras [n]");
ylabel("Amplitud [V]");
title("Señal original");
axis([0 length(xn) -1 1]);
grid on;

subplot(2,1,2)
plot(vector_muestras,e);
xlabel("Muestras [n]");
ylabel("Amplitud [V]");
title("Señal original con ruido filtrado");
axis([0 length(xn) -1 1]);
grid on;

%% b)
figure;
hold on;
plot(vector_muestras, xn);
plot(vector_muestras, y);
xlabel("Muestras [n]");
ylabel("Amplitud [V]");
title("Señal ruido vs Estimación: 100 primeras muestras");
legend('Señal Ruido','Estimacion');
axis([0 100 -1 1]);
grid on;

figure;
hold on;
plot(vector_muestras,xn);
plot(vector_muestras, y);
xlabel("Muestras [n]");
ylabel("Amplitud [V]");
title("Señal ruido vs Estimación: 100 últimas muestras");
legend('Señal Ruido','Estimacion');
axis([length(xn)-100 length(xn) -1 1]);
grid on;

figure;
subplot(2,1,1);
plot(vector_muestras,xn);
xlabel("Muestras [n]");
ylabel("Amplitud [V]");
title("Señal ruido original");
axis([0 1000 -1 1]);
grid on;

subplot(2,1,2)
plot(vector_muestras,y);
xlabel("Muestras [n]");
ylabel("Amplitud [V]");
title("Señal ruido estimado: evolución");
axis([0 1000 -1 1]);
grid on;

%% c)
Df = fftshift(abs(fft(dn, length(dn))/length(dn)));
Xf = fftshift(abs(fft(xn, length(xn))/length(xn)));
Yf = fftshift(abs(fft(y, length(y))/length(y)));
Ef = fftshift(abs(fft(e, length(e))/length(e)));

vec_frec = linspace(-fs_dn/2, fs_dn/2, length(dn));

figure;
hold on;
plot(vec_frec, Df);
plot(vec_frec, Yf);
xlabel("Frecuencia [Hz]");
ylabel("Amplitud [V]");
title("Señal audio original con ruido VS Señal ruido");
legend('Espectro d[n]', 'Espectro y[n]');
grid on;

figure;
hold on;
plot(vec_frec,Df);
plot(vec_frec, Yf);
xlabel("Frecuencia [Hz]");
ylabel("Amplitud [V]");
title("Señal audio original con ruido VS Señal ruido");
axis([-15000 15000 0 0.008])
legend('Espectro dn[n]', 'Espectro y[n]');
grid on;

figure;
subplot(1,3,1);
plot(vec_frec,Df);
xlabel("Frecuencia [Hz]");
ylabel("Amplitud [V]");
axis([-15000 15000 0 0.008]);
title("Señal audio original con ruido");
grid on;

subplot(1,3,2);
plot(vec_frec,Ef, 'r');
xlabel("Frecuencia [Hz]");
ylabel("Amplitud [V]");
axis([-15000 15000 0 0.008]);
title("Señal final error");
grid on;

subplot(1,3,3);
plot(vec_frec,Yf, 'g');
xlabel("Frecuencia [Hz]");
ylabel("Amplitud [V]");
axis([-15000 15000 0 0.008]);
title("Ruido estimado");
grid on;

figure;
hold on;
plot(vec_frec,Xf);
plot(vec_frec,Yf);
xlabel("Frecuencia [Hz]");
ylabel("Amplitud [V]");
title("Señal del ruido correlada VS estimada");
legend("Ruido Correlado", "Estimacion");
axis([4400 4500 0 0.001]);
grid on;

%% d) y e)

%En cada iteracion tenemos M+1 coeficientes asi que lo representamos en
%forma de superficie

%En el gráfico se puede ver como van evolucionando esos 11 coeficientes a
%los largo de las muchisimas iteraciones del bucle. 

coeficientes=1:1:M+1;

s=surf(coeficientes,vector_muestras, Matriz_coef, 'FaceAlpha',0.5,'EdgeColor','none');


%Por otro lado analizamos la evolución de los coeficientes por separado en
%el tiempo

figure;
hold on;
for i=1: M+1
    plot(vector_muestras, Matriz_coef(:,i));
end
title('Evolución de los coeficientes');
xlabel('Iteracion');
ylabel('Valor');
grid on;
legend('Coeficiente 1','Coeficiente 2', 'Coeficiente 3', 'Coeficiente 4','Coeficiente 5', 'Coeficiente 6', 'Coeficiente 7', 'Coeficiente 8', 'Coeficiente 9', 'Coeficiente 10', 'Coeficiente 11');

%Se puede observar como las mayores variaciones en los coeficientes se
%producen en las primeras iteraciones. Pasadas 17000 iteraciones parece que todos los coeficientes 
%se estabilizan y el crecimiento hacia los Woptimos es paulatino

%Por otro lado, Se observa como el valor de los coeficientes 'tiembla' en
%ciertos instantes temporales n. Estos instantes son donde existe señal de
%audio. El valor de los coeficientes tiende a minimizar la señal error
%e[n]. No obstante, cuando existe señal de audio el valor de los
%coeficientes oscila porque el error no se puede hacer 0 ya que la señal
%y[n] es una estimación del error y no de la señal de audio


%% Extra: Utilizamos codigo del .m proporcionado por Carlos 

%Utilizando este código se obtienen los coeficientes óptimos del filtro de
%Wiener

%Estos coeficientes son exactamente los óptimos y no una aproximación tras
%iteraciones como los del algoritmo LMS

%% Autocorrelation Matrix

[r_x,lags] = xcorr(xn);

% Matriz de índices de correlación
corr_indexes = (0:M)-(0:M)';
corr_indexes = corr_indexes(:);

% Matriz de correlación
Rx = zeros(length(corr_indexes),1);
for i = 1:length(corr_indexes)
    Rx(i) = r_x(lags==corr_indexes(i));
end
Rx = reshape(Rx,M+1,M+1);

% Valor máximo del paso del algoritmo LMS
[U, V] = eig(Rx/Rx(1,1)); % La matriz de autocorrelación se normaliza con respecto a la potencia de ruido para calcular los autovalores normalizados
mu_max = 1/max(max(V));

%% Vector de Correlación Cruzada

[r_dx, lags] = xcorr(dn,xn);

corr_indexes = (0:M)';

Rdx = zeros(length(corr_indexes),1);
for i = 1:length(corr_indexes)
    Rdx(i) = r_dx(lags==corr_indexes(i));
end


%% Filtro de Wiener

W_opt = inv(Rx)*Rdx;


%Obtengo ultimos coeficientes del algoritmo LMS

ultimos_coef=Matriz_coef(length(xn), :);
vector_referencia=1:1:11;
figure;
hold on;
plot(vector_referencia, ultimos_coef);
plot(vector_referencia, W_opt);
title('LMS Vs Weiner');
xlabel('Nº Coeficiente');
ylabel('Valor');
grid on;
legend('Coeficientes LMS', 'Coeficientes Weimer');



