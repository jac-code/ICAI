%% PRACTICA 4. SERVICIOS TELEMATICOS MULTIMEDIA

% Guillermo Aldrey Pastor

% Fecha de Entrega: 13/11/2020

% En este archivo "practica4.m" se procede a la resolucion de la practica.
% Se comentara brevemente los pasos a seguir, ya que la explicacion de cada
% apartado se explica en detalle en el pdf que se adjunta junto con este archivo.

%% PARTE A - ANALISIS MPEG1 AUDIO EN NIVEL I

% El nivel 1 de MPEG ofrece una calidad muy buena comparada con la alta
% velocidad de transmision que facilita. Es el mas simple y esta pensado
% para bitrates superiores a 128kbps

clc;clear;close all
    
% Hemos realizado esta parte con la funcion Test_MPEG.m



%% PARTE B - ANALISIS MPEG1 AUDIO EN NIVEL III (MP3)

clc;clear;close all

% El nivel 3 (MP3) es más complejo y originalmente tuvo como objetivo la
% transmision de audio sobre líneas ISDN (Integrated Services Digital Network).
% Pensado para bitrates cercanos a 64 Kbps por canal

% a) Usar el fichero de audio anterior y el código para convertir el fichero 
% wav a mp3 usando al menos dos velocidades (tasas de bits diferentes)

    % He usado el fichero "Jazz.wav" y el codigo del archivo Wav2mp3 para
    % convertir mi fichero wav a mp3, usando tres velocidades distintas
    % (96, 160 y 256).
    
    [x , Fs] = audioread('Jazz.wav');
    [x1 , Fs1] = audioread('Jazz96.mp3');
    [x2 , Fs2] = audioread('Jazz160.mp3');
    [x3 , Fs3] = audioread('Jazz256.mp3');
    
    
    figure;
    hold on;
    plot(x3,'y')
    plot(x2,'g')
    plot(x1,'r')
    plot(x,'b')
    title('Comparacion ficheros')
    legend('Señal codificada a 256 bps','Señal codificada a 160 bps','Señal codificada a 96 bps','Señal Original')
    hold off;
    
    figure;
    subplot(4,1,1)
    plot(x,'b')
    title('Señal Original')
    subplot(4,1,2)
    plot(x1,'r')
    title('Señal codificada a 96 bps')
    subplot(4,1,3)
    plot(x2,'g')
    title('Señal codificada a 160 bps')
    subplot(4,1,4)
    plot(x3,'y')
    title('Señal codificada a 256 bps')
    
    
% b) Indicar el tiempo transcurrido en el proceso de paso a mp3 en ambas
% ocasiones

    % V=96bps --> t = 14.456788 seconds
    % V=160 bps --> t = 18.865840 seconds
    % V=256 bps --> t = 26.083397 seconds 
    
% c) Comparar tamaños de fichero wav y los dos obtenidos al pasarlos por el
% compresor (ratios de compresion)

    Tam_wav = 871;
    Tam_Jazz96 = 118;
    Tam_Jazz160 = 197;
    Tam_Jazz256 = 316;
    
    Cr96 = Tam_wav / Tam_Jazz96;
    Cr160 = Tam_wav / Tam_Jazz160;
    Cr256 = Tam_wav / Tam_Jazz256;
    


% d) Comentar la calidad obtenida en todos los casos. Evaluar diferencia o
% errores de manera cuantitativa
    
    error1 = x(1:length(x1)) - x1; %Error entre original y Jazz96
    error2 = x(1:length(x2)) - x2; %Error entre original y Jazz160
    error3 = x(1:length(x3)) - x3; %Error entre original y Jazz256
    
    figure;
    hold on;
    plot(error3,'r')
    plot(error2,'g')
    plot(error1,'y')
    title('Comparacion errores')
    legend('Error entre original y Jazz256', 'Error entre original y Jazz160','Error entre original y Jazz96')
    hold off;
    
    figure;
    subplot(3,1,1)
    plot(error1,'b')
    title('Error entre original y Jazz96')
    subplot(3,1,2)
    plot(error2,'r')
    title('Error entre original y Jazz160')
    subplot(3,1,3)
    plot(error3,'g')
    title('Error entre original y Jazz256')
    
    figure;
    subplot(3,1,1)
    histogram(error1)
    subplot(3,1,2)
    histogram(error2)
    subplot(3,1,3)
    histogram(error3)
    
    mean(error1)
    mean(error2)
    mean(error3)
 
    std(error1)
    std(error2)
    std(error3)


% e) Usar el fichero de audio en formato .wav para cargarlo en 'Audacity' y
% desde esa aplicacion exportarlo como formato mp3. Evaluar tamaños origen
% y final y su ratio de compresion. Cargar ambos ficheros en Matlab, tanto
% el original wav, como el expotado mp3, y analizar sus diferencias o error
% de manera cuantitativa y de forma gráfica con gráficos e histograma.
    
    [xAu , FsAu] = audioread('JazzAudacity.mp3');
    errorAu = x(1:length(xAu)) - xAu;
    
    figure;
    subplot(2,1,1)
    plot(errorAu, 'r')
    title('ErrorAudacity')
    subplot(2,1,2)
    histogram(errorAu)
    title('Histograma del errorAudacity')
    
    mean(errorAu)
    std(errorAu)
  

% f ) Comentar la calidad obtenida respecto a los casos analizados antes.
% Evaluar las diferencias encontradas en ambos metodos de paso a mp3.

    sound(x, Fs)
    sound(x1, Fs1)
    sound(x2, Fs2)
    sound(x3, Fs3)
    sound(xAu, FsAu)






