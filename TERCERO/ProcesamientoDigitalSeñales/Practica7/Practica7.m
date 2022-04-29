%% Práctica 7
load("PDS_P7_3A_LE2_G6.mat");

%% a)
% dn --> señal a la que hay que quitarle el ruido
[dn, fs_dn]=audioread("PDS_P7_3A_LE2_G6_d_n.wav");
%sound(dn, fs_dn);

%% b)
% xn --> señla con ruido de fondo, correlado con el de dn
[xn, fs_xn]= audioread("PDS_P7_3A_LE2_G6_x_n.wav");
%sound(xn, fs_xn);

%% Algoritmo LMS
% M+1 coeficientes del filtro en cada instante n
wn = zeros(1, M+1);

% memoria del filtro
mem_filtro = zeros(1, length(wn));

% error del sistema adaptativo
en = zeros(1, length(xn));

% coeficientes en cada iteración
coeficientes_iteracion = zeros(length(xn), length(wn));

% ruido estimado / ruido filtrado
yn = zeros(1, length(xn));

for i=1:length(xn)
    % cargamos memoria filtro en xn
    mem_filtro = [xn(i), mem_filtro(1:end-1)];
    
    % filtrado mediante la convolución completa
    yn(i) = sum(wn.*mem_filtro);
    
    % cálculo del error
    en(i) = dn(i) - yn(i);
    
    % cálculo nuevo set de coeficientes
    wn = wn + mem_filtro.*(2*en(i) * mu);
    
    coeficientes_iteracion(i, 1:end) = wn;
end

%% Comprobar el valor de mu
[Rx, j] = xcorr(xn, 'biased');
matriz_autocorr = toeplitz(Rx(length(xn):length(xn)+M-1));
autov = eig(matriz_autocorr);
mu_max = 1/max(autov);

% calculamos el máximo valor de mu con la potencia de x[n]
pot_x = mean(xn)^2+var(xn);
mu_max_potencia = 1/((M+1)*pot_x);

%% Análisis de resultados
%% a)
vec_muestras = 1:1:length(xn);

figure;
hold on;
plot(vec_muestras, dn);
plot(vec_muestras, en);
xlabel("Muestras [n]");
ylabel("Amplitud [V/V]");
title("Señal original VS Señal sin ruido");
legend('Señal original con ruido','Señal sin ruido');
axis([0 length(xn) -1 1]);
grid on;

figure;
subplot(2,1,1);
plot(vec_muestras,dn);
xlabel("Muestras [n]");
ylabel("Amplitud [V/V]");
title("Señal original");
axis([0 length(xn) -1 1]);
grid on;

subplot(2,1,2)
plot(vec_muestras,en);
xlabel("Muestras [n]");
ylabel("Amplitud [V/V]");
title("Señal original sin ruido");
axis([0 length(xn) -1 1]);
grid on;

%% b)
figure;
hold on;
plot(vec_muestras, xn);
plot(vec_muestras, yn);
xlabel("Muestras [n]");
ylabel("Amplitud [V/V]");
title("Señal ruido VS Estimación: 100 primeras muestras");
legend('Señal Ruido','Estimación');
axis([0 100 -1 1]);
grid on;

figure;
hold on;
plot(vec_muestras,xn);
plot(vec_muestras, yn);
xlabel("Muestras [n]");
ylabel("Amplitud [V/V]");
title("Señal ruido VS Estimación: 100 últimas muestras");
legend('Señal Ruido','Estimación');
axis([length(xn)-100 length(xn) -1 1]);
grid on;

figure;
subplot(2,1,1);
plot(vec_muestras,xn);
xlabel("Muestras [n]");
ylabel("Amplitud [V/V]");
title("Señal ruido original");
axis([0 1000 -1 1]);
grid on;

subplot(2,1,2)
plot(vec_muestras,yn);
xlabel("Muestras [n]");
ylabel("Amplitud [V/V]");
title("Señal ruido estimado: evolución");
axis([0 1000 -1 1]);
grid on;

%% c)
Df = fftshift(abs(fft(dn, length(dn))/length(dn)));
Xf = fftshift(abs(fft(xn, length(xn))/length(xn)));
Yf = fftshift(abs(fft(yn, length(yn))/length(yn)));
Ef = fftshift(abs(fft(en, length(en))/length(en)));

vec_frec = linspace(-fs_dn/2, fs_dn/2, length(dn));

figure;
hold on;
plot(vec_frec, Df);
plot(vec_frec, Yf);
xlabel("Frecuencia [Hz]");
ylabel("Amplitud [V/V]");
title("Señal audio original con ruido VS Señal ruido");
legend('Espectro d[n]', 'Espectro yn[n]');
grid on;

figure;
subplot(1,3,1);
plot(vec_frec,Df);
xlabel("Frecuencia [Hz]");
ylabel("Amplitud [V/V]");
axis([-15000 15000 0 0.008]);
title("Señal audio original con ruido");
grid on;

subplot(1,3,2);
plot(vec_frec,Ef, 'r');
xlabel("Frecuencia [Hz]");
ylabel("Amplitud [V/V]");
axis([-15000 15000 0 0.008]);
title("Señal final error");
grid on;

subplot(1,3,3);
plot(vec_frec,Yf, 'g');
xlabel("Frecuencia [Hz]");
ylabel("Amplitud [V/V]");
axis([-15000 15000 0 0.008]);
title("Ruido estimado");
grid on;

figure;
hold on;
plot(vec_frec,Xf);
plot(vec_frec,Yf);
xlabel("Frecuencia [Hz]");
ylabel("Amplitud [V/V]");
title("Señal del ruido correlada VS estimada");
legend("Ruido Correlado", "Estimacion");
axis([4400 4500 0 0.001]);
grid on;

%% d) y e)
coeficientes = 1:1:M+1;
s = surf(coeficientes,vec_muestras, coeficientes_iteracion, 'FaceAlpha',0.5,'EdgeColor','none');

figure;
hold on;
for i = 1:(M+1)
    plot(vec_muestras, coeficientes_iteracion(:,i));
end
title('Evolución de los coeficientes');
xlabel('Nº Iteración');
ylabel('Valor');
grid on;
legend('Coeficiente 1','Coeficiente 2', 'Coeficiente 3', 'Coeficiente 4','Coeficiente 5', 'Coeficiente 6', 'Coeficiente 7', 'Coeficiente 8', 'Coeficiente 9', 'Coeficiente 10', 'Coeficiente 11');




