%% PRÁCTICA 3
%% Filtrado de señales
load ('PDS_P3_3A_LE2_G6.mat'); % cargamos el archivo
% load('coeficientesFiltros.mat') % para que el corrector tenga en el workspace los coeficientes del filtro

%% a)
Ts = t(2) - t(1);
fs = 1/Ts;

%% b) -- Convolución 
% b = numero de coeficeintes del filtro --> añadir k ceros
yn = zeros(1, length(x) + length(b) - 1);

for i = 1:length(x)+length(b)-1 % recorremos x[n]
    aux = zeros(1, length(b)); % guardamos productos parciales
    for k = 1:length(b)
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
legend('b[n] ');
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
legend('Señal original', 'Convolución manual', 'Función conv()', 'Función filter()');
grid on

%% Diseño de filtros FIR
%% a) y b)
figure;
plot(vector_frec_xn, Xf);
title('Espectro señal x[n]');
xlabel('Frecuencia [Hz]');
ylabel('|Xf|');
grid on;

zn = conv(LP_Filter, x);
Zf = fft(zn, length(zn));
Zf = fftshift(abs(Zf));
vector_frec_zn = linspace(-fs/2, fs/2, length(Zf));

figure;
subplot(2,1,1);
plot(vector_frec_xn, Xf);
title('Espectro x[n]');
xlabel('Frecuencia[Hz]');
ylabel('|Xf()|');
grid on;

subplot(2,1,2);
plot(vector_frec_zn, Zf);
title('Espectro señal filtrada con LPF');
xlabel('Frecuencia[Hz]');
ylabel('|Zf()|');
grid on;

%% c) y d)
wn = conv(HP_Filter, x);
Wf = fft(wn, length(wn));
Wf = fftshift(abs(Wf));
vector_frec_wn = linspace(-fs/2, fs/2, length(Wf));

figure;
subplot(2,1,1);
plot(vector_frec_xn, Xf);
title('Espectro x[n]');
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
% y[n] = LP de x[n]
yn = conv(LP_Filter, x);

%% b)
% g[n] = HP de y[n]
gn = conv(HP_Filter, yn);

%% c)
% h[n] --> BP de x[n]
hn = conv(BP_Filter, x);

%% d) y e)
vector_frec_xn = linspace(-fs/2, fs/2, length(x));
vector_frec_yn = linspace(-fs/2, fs/2, length(yn));
vector_frec_gn = linspace(-fs/2, fs/2, length(gn));

% En una misma linea calculo transformada rápida y centro espectro
Xf=fftshift(abs(fft(x, length(x))));
Yf=fftshift(abs(fft(yn, length(yn))));
Gf=fftshift(abs(fft(gn, length(gn))));
vector_frec_hn = linspace(-fs/2, fs/2, length(hn));
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
title('Espectro después de filtro BP');
xlabel('Frecuencia [Hz]');
ylabel('|Hf()|');
grid on;

figure;
subplot(3,1,1);
plot(vector_frec_xn, Xf);
title('Espectro señal x[n]');
xlabel('Frecuencia [Hz]');
ylabel('|Xf()|');
grid on;

subplot(3,1,2);
plot(vector_frec_yn, Yf);
title('Espectro despues de LPF');
xlabel('Frecuencia [Hz]');
ylabel('|Xf()|');
grid on;

subplot(3,1,3);
plot(vector_frec_gn, Gf);
title('Espectro después de LPF+HPF');
xlabel('Frecuencia [Hz]');
ylabel('|Gf()|');
grid on;

%% Orden del filtro 
%% b) 
% Utilizamos la función freqz de matlab que te muestra el espectro de los
% filtros

figure;
freqz(LP_Filter);
title("Orden 100");

figure;
freqz(LP_Filter_50);
title("Orden 50");

figure;
freqz(LP_Filter_20);
title("Orden 20");

figure;
freqz(LP_Filter_10);
title("Orden 10");

%% c)
retardo_10= ((length(LP_Filter_10)-1)/2)*Ts*1000;
retardo_20= ((length(LP_Filter_20)-1)/2)*Ts*1000;
retardo_50= ((length(LP_Filter_50)-1)/2)*Ts*1000;
retardo_100= ((length(LP_Filter)-1)/2)*Ts*1000; 