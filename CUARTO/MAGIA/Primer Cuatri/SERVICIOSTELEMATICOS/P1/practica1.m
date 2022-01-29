%% PRACTICA 1. SERVICIOS TELEMATICOS MULTIMEDIA

% Guillermo Aldrey Pastor

% Fecha de Entrega: 04/10/2020

% En este archivo "practica1.m" se procede a la resolucion de la practica
% utilizando partes de todos los archivos de cuantizacion uniforme y cuantizacion no
% uniforme proporcionados por el profesor.

%% PARTE A

% a) Mostrar las muestras, sus valores discretizados y sus correspondientes 
%    codewords o valores codificados en digital.

% Obtenemos la frecuencia de muestreo y nuestra senial junto con su vector
% de tiempos

clc;clear;close all

global q

[m,Fs] = audioread('audio.wav');
sound(m,Fs);
t = 0:1/Fs:((length(m)-1)/Fs);

% Procedo a muestrear mi senial, y para ello diezmamos la senial original 
% (la cual ya es digital), de esa forma estamos tomando una de cada M 
% muestras, aumentando el periodo de muestreo. 
% Obtenemos vector de tiempo y nuestra senial.

 

% Representacion de ambas seniales, la original y la diezmada
figure()
plot(t,m,'-o');
hold on
stem(t_samp,m_samp,'-*');
hold on
title('Seniales en el tiempo');
xlabel('Tiempo, s');
ylabel('Amplitud, V');
legend('señal original', 'señal muestreada');

% Aplicamos zoom para demostrar que se han tomado una de cada M muestras,
% siendo M = 4

zoom_1 = 18000:18050;
zoom_2 = (18000/4):(18050/4);

figure()
plot (t(zoom_1),m(zoom_1),'-x','linewidth', 2)
hold on
plot (t_samp(zoom_2),m_samp(zoom_2), '-o')
hold on 
legend('señal original','señal muestreada');
title('Representación de las señales con zoom')
xlabel('Tiempo (s)')
ylabel('Amplitud (V)')


L = 12; % Deseamos 12 niveles de cuantizacion
[sqnr,m_quan,code] = uniform_pcm(m_samp,L);


% b)  Representar las señales original y discretizada y verificar la 
%     correspondencia de los codewords asignados

figure(2)
plot (t,m/max(m),'-b','linewidth', 2)
hold on
stem (t_samp,m_samp/max(m), '--ro')
hold on
for i=1:L
    plot (t,q(i)* ones(1,length(t)),'--g');hold on
end
legend('señal original normalizada','señal muestreada normalizada');
echo off

sound(m_samp, Fs1); %Se aprecia como se escucha peor nuestro audio,
                   % y tiene sentido debido a la comprension.
                  


% c) Variar el número de niveles de discretización y representar en una 
%    gráfica los correspondientes valores de relación señal/ruido (SQNR) 
%    en función del número de bits por codeword

[sqnr_8L,m_quan_8L,code_8L]=uniform_pcm(m_samp,8);
[sqnr_16L,m_quan_16L,code_16L]=uniform_pcm(m_samp,16);

pause   % Press a key to see the SQNR for L = 8.
sqnr_8L

pause   % Press a key to see the SQNR for L = 8.
sqnr_16L
 
 
pause   % Press a key to see the plot of the signal and its 
        % quantized versions.
        
figure(3)
t = t_samp; m = m_samp;
plot(t,m,'-',t,m_quan_8L,'-.',t,m_quan_16L,'-',t,zeros(1,length(t)), ...
    'linewidth', 2)
legend('Original','Cuantizada (L=8)','Cuantizada (L=16)','Location', ...
    'SouthEast');


pause % Press a key to see the first 5 samples, corresponding quanited   
      % values, and corresponding codewords with 8 quantization levels
m(1:5)
m_quan_8L(1:5)
code_8L(1:5,:)
 
pause % Press a key to see the first 5 samples, corresponding quanited  
      % values, and corresponding codewords with 16 quantization levels
m(1:5)
m_quan_16L(1:5)
code_16L(1:5,:)
echo off


% Cuando la amplitud de la senial es nula, los escalones son mas grandes,
% eso implica que el error SRN no es bueno. Lo que vamos a hacer a
% continuacion es cambiar el valor de L y comprobar como si subimos el
% numero de niveles de cuantificacion, esta sera mas precisa.


[sqnr_24L,m_quan_24L,code_24L]=uniform_pcm(m_samp,24);
[sqnr_32L,m_quan_32L,code_32L]=uniform_pcm(m_samp,32);
 
pause   % Press a key to see the SQNR for L = 24.
sqnr_24L
 
pause   % Press a key to see the SQNR for L = 32.
sqnr_32L
 
pause   % Press a key to see the plot of the signal and its 
        % quantized versions.
        
figure
t = t_samp; m = m_samp;
plot(t,m,'-',t,m_quan_24L,'-.',t,m_quan_32L,'-',t,zeros(1,length(t)), ...
    'linewidth', 2)
legend('Original','Cuantizada (L=24)','Cuantizada (L=32)','Location', ...
    'SouthEast');

 
 pause % Press a key to see the first 5 samples, corresponding quanited   
      % values, and corresponding codewords with 24 quantization levels
m(1:5)
m_quan_24L(1:5)
code_24L(1:5,:)
 
pause % Press a key to see the first 5 samples, corresponding quanited  
      % values, and corresponding codewords with 32 quantization levels
m(1:5)
m_quan_32L(1:5)
code_32L(1:5,:)
echo off

% También se imprimen por pantalla los 5 primeros valores de: la señal
% original, el correspondiente cuantificado y el codigo del nivel. Viendo
% estos valores, podemos verificar que el proceso es correcto. Los valores
% originales son todos 0, y los códigos de los niveles corresponden a la
% mitad, lo cual tiene todo el sentido.


% d) Se puede comprobar como a medida que aumenta el nivel de cuantizacion
% nuestra senial se escucha mejor



%% PARTE B

% a) Desarrollar dos funciones para un compresor tipo A-Law y su inversa 
%    y verificar su correcto funcionamiento.


% b) Repetir los casos analizados de los casos de digitalización 
%    no uniforme de la ley mu pero con la ley A.

% Primero usamos mulaw, funcion otorgada, ya que luego sera de gran ayuda
% para ver las diferencias respecto de A-LAW.

i = [3,4,5,6,7,8];
mu      = 255;
for j=1:length(i)
    valor = i(j)
    L= (2^valor)-1
    
    [sqnr,m_quan,code]=mulaw_pcm(m_samp,L,mu);
    %----------------------------------------------------------------------
    pause   % Press a key to see the SQNR.
    sqnr
%     pause % Press a key to see the first five input values.
%     m_samp(1:5)
%     pause % Press a key to see the first five quantized values.
%     m_quan(1:5)
%     pause % Press a key to see the first five codewords.
%     code(1:5,:)
    
    % Plot the quantization error for each sample.
    q_error = m_samp - m_quan;
    figure; plot (q_error)
    title('diferencia entre valor real y valor aproximado')
    
    
    % Plot the quantized value as a function of the input value. 
    [Y,Index]=sort(m_samp); % Ordena de menor a mayor las muestras
    figure; plot(Y,m_quan(Index))
    title('Muestras ordenadas de menor a mayor frente cuantizadas indexadas por el orden anterior')
    sound(m_quan,Fs1);
end
echo off 


% A continuacion, hacemos lo propio utilizando la funcion creada que se
% corresponde con la A-LAW


i = [3,4,5,6,7,8];
A      = 87.7;
for j=1:length(i)
    valor = i(j)
    L= (2^valor)-1
    
    [sqnr,m_quan,code]=alaw_pcm(m_samp,L,A);
    %----------------------------------------------------------------------
    pause   % Press a key to see the SQNR.
    sqnr
%     pause % Press a key to see the first five input values.
%     m_samp(1:5)
%     pause % Press a key to see the first five quantized values.
%     m_quan(1:5)
%     pause % Press a key to see the first five codewords.
%     code(1:5,:)
    
    % Plot the quantization error for each sample.
    q_error = m_samp - m_quan;
    figure; plot (q_error)
    title('diferencia entre valor real y valor aproximado')
    
    
    % Plot the quantized value as a function of the input value. 
    [Y,Index]=sort(m_samp); % Ordena de menor a mayor las muestras
    figure; plot(Y,m_quan(Index))
    title('Muestras ordenadas de menor a mayor frente cuantizadas indexadas por el orden anterior')
    sound(m_quan,Fs1);
end
echo off   




%% PARTE C

% En este apartado vamos a completar el estudio de mi senial de voz pero
% esta vez utilizando ADCOM y DCPM

% ADPCM

clc;clear;close all

[Y,Fs] = audioread('audio.wav'); % Se lle una voz

[n, m] =size (Y);


 y = adpcm_encoder(Y);
YY = adpcm_decoder(y);

t=1:n;

figure (1)
plot(t, YY, t, Y)
title("Ejemplo ADPCM")
legend('decodificada','original')


figure(2)
plot(Y, YY, '*')
title("Señal original frente a decodificada")

% DPCM


close all
clear
% signal sampling
fs=1/2000;
tn=0:fs:1/25;
%SELECT A SIGNAL ****************************
%s=.5*sin(2*pi*50*tn);
[s,fs]=audioread('audio.wav');  %read .wav file

primero = find(s>=0.01,1,'first')
y = s(primero:100000)
ty = 0:1/fs:((length(y)-1)/fs);

% He tenido que tomar menos muestras de la senial original para que
% funcionase el DPCM.

%lpc and encoder-decoder parameters
lpclen=20;
bitsize=input('bitsize=');
fprintf('\nPlease wait... data length is %i\n',length(y))
%LPF parameters
tap=100;
cf=.15;

% DPCM with predictor
[Q,b, ai] = dpcm_enco_lpc(y, lpclen, bitsize);
[st]=dpcm_deco_lpc(b, ai, bitsize);
Sa=lpf(tap,cf,st);
%[xa,ya]=stairs(tn,Sa);

figure
subplot(3,1,1);plot(y,'r');
ylabel('amplitude');
title('DPCM with predictor (red:input, green:decoder output, blue: LPF output)');
subplot(3,1,2);plot(st,'g');
ylabel('amplitude');
subplot(3,1,3);plot(Sa,'b');
ylabel('amplitude');
xlabel('index, n');
grid

fprintf('\npress a key to hear input\n\n');
pause
sound(y,fs);
fprintf('press a key to hear LPF output\n\n');
pause
sound(Sa,fs);
