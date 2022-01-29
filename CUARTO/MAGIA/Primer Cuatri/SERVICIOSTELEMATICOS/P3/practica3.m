%% PRACTICA 3. SERVICIOS TELEMATICOS MULTIMEDIA

% Guillermo Aldrey Pastor

% Fecha de Entrega: 06/11/2020

% En este archivo "practica3.m" se procede a la resolucion de la practica.
% Se comentara brevemente los pasos a seguir, ya que la explicacion de cada
% apartado se explica en detalle en el pdf que se adjunta junto con este archivo.

%% ENUNCIADO

% Contruir un vocoder CELP capaz de analizar y sintetizar los fragmentos 
% de voz usados en la práctica 2 para diseño del vocoder con LP
clc;clear;close all

[v_n , F_v] = audioread('vocal.wav');
soundsc(v_n , F_v);

[c_n , F_c] = audioread('consonante.wav');
soundsc(c_n , F_c);

[f_n , F_f] = audioread('frasecorta.wav');
soundsc(f_n , F_f);


% a) Fase de Analisis, probando con diferentes codebooks, diferentes
% ordenes para el predictor lineal y diferentes valores de pesos del error.

    % Vamos a usar mi frase corta como senial de voz

    
    % Debemos variar el valor de cb, el orden del predictor lineal M, y
    % el valor de peso del error c
    
    %Caso 1. codebook = 40 veces 1024
    
    [f_n , F_f] = audioread('frasecorta.wav');
    
    % generación del codebook gaussiano
    randn('state', 0);
    cb=randn(40, 1024);  % 40 veces 1024
    
    N=160; M=10; L=40; c=0.8;Pidx=[16 160];
    
    % xhat nos da la senial sintetizada
    [xhat, e, k, theta0, P, b]=celp(f_n, N, L, M, c, cb, Pidx);
    
    error = f_n - xhat;
    
    figure
    plot(f_n)
    hold on
    plot(xhat)
    hold on
    plot(error)
    axis ([0 length(f_n) -1 1])
    legend('Señal Original','Señal Sintetizada CELP', 'Error')
    title('Comparativa Caso 1')
    
    soundsc(f_n , F_f)
    soundsc(xhat, F_f)
    
    % Borramos variables para el siguiente caso
    clc;clear;close all
    
    %Caso 2. codebook = 20 veces 1024
    
    [f_n , F_f] = audioread('frasecorta.wav');
    
    % generación del codebook gaussiano
    randn('state', 0);
    cb=randn(20, 1024);  % 20 veces 1024
    
    N=160; M=10; L=20; c=0.8;Pidx=[16 160];
    
    % xhat nos da la senial sintetizada
    [xhat, e, k, theta0, P, b]=celp(f_n, N, L, M, c, cb, Pidx);
    
    error = f_n - xhat;
    
    figure
    plot(f_n)
    hold on
    plot(xhat)
    hold on
    plot(error)
    axis ([0 length(f_n) -1 1])
    legend('Señal Original','Señal Sintetizada CELP', 'Error')
    title('Comparativa Caso 2')
        
    soundsc(f_n , F_f)
    soundsc(xhat, F_f)
    
     % Borramos variables para el siguiente caso
    clc;clear;close all
    
    %Caso 3. codebook = 80 veces 1024
    
    [f_n , F_f] = audioread('frasecorta.wav');
    
    % generación del codebook gaussiano
    randn('state', 0);
    cb=randn(80, 1024);  % 80 veces 1024
    
    N=160; M=10; L=80; c=0.8;Pidx=[16 160];
    
    % xhat nos da la senial sintetizada
    [xhat, e, k, theta0, P, b]=celp(f_n, N, L, M, c, cb, Pidx);
    
    error = f_n - xhat;
    
    figure
    plot(f_n)
    hold on
    plot(xhat)
    hold on
    plot(error)
    axis ([0 length(f_n) -1 1])
    legend('Señal Original','Señal Sintetizada CELP', 'Error')
    title('Comparativa Caso 3')
        
    soundsc(f_n , F_f)
    soundsc(xhat, F_f)
    
    % Borramos variables para el siguiente caso
    clc;clear;close all
    
    %Caso 4. M = 14
    
    [f_n , F_f] = audioread('frasecorta.wav');
    
    % generación del codebook gaussiano
    randn('state', 0);
    cb=randn(40, 1024);  % 40 veces 1024
    
    N=160; M=14; L=40; c=0.8;Pidx=[16 160];
    
    % xhat nos da la senial sintetizada
    [xhat, e, k, theta0, P, b]=celp(f_n, N, L, M, c, cb, Pidx);
    
    error = f_n - xhat;
    
    figure
    plot(f_n)
    hold on
    plot(xhat)
    hold on
    plot(error)
    axis ([0 length(f_n) -1 1])
    legend('Señal Original','Señal Sintetizada CELP', 'Error')
    title('Comparativa Caso 4')
        
    soundsc(f_n , F_f)
    soundsc(xhat, F_f)

    % Borramos variables para el siguiente caso
    clc;clear;close all
    
    %Caso 5. M = 20
    
    [f_n , F_f] = audioread('frasecorta.wav');
    
    % generación del codebook gaussiano
    randn('state', 0);
    cb=randn(40, 1024);  % 40 veces 1024
    
    N=160; M=20; L=40; c=0.8;Pidx=[16 160];
    
    % xhat nos da la senial sintetizada
   [xhat, e, k, theta0, P, b]=celp(f_n, N, L, M, c, cb, Pidx);
    
    error = f_n - xhat;
    
    figure
    plot(f_n)
    hold on
    plot(xhat)
    hold on
    plot(error)
    axis ([0 length(f_n) -1 1])
    legend('Señal Original','Señal Sintetizada CELP', 'Error')
    title('Comparativa Caso 5')
        
    soundsc(f_n , F_f)
    soundsc(xhat, F_f)

    % Borramos variables para el siguiente caso
    clc;clear;close all
    
    %Caso 6. M = 24
    
    [f_n , F_f] = audioread('frasecorta.wav');
    
    % generación del codebook gaussiano
    randn('state', 0);
    cb=randn(40, 1024);  % 40 veces 1024
    
    N=160; M=24; L=40; c=0.8;Pidx=[16 160];
    
    % xhat nos da la senial sintetizada
    [xhat, e, k, theta0, P, b]=celp(f_n, N, L, M, c, cb, Pidx);
    
    error = f_n - xhat;
    
    figure
    plot(f_n)
    hold on
    plot(xhat)
    hold on
    plot(error)
    axis ([0 length(f_n) -1 1])
    legend('Señal Original','Señal Sintetizada CELP', 'Error')
    title('Comparativa Caso 6')
        
    soundsc(f_n , F_f)
    soundsc(xhat, F_f)
  
    % Borramos variables para el siguiente caso
    clc;clear;close all
    
    %Caso 7. c = 1
    
    [f_n , F_f] = audioread('frasecorta.wav');
    
    % generación del codebook gaussiano
    randn('state', 0);
    cb=randn(40, 1024);  % 40 veces 1024
    
    N=160; M=10; L=40; c=1;Pidx=[16 160];
    
    % xhat nos da la senial sintetizada
    [xhat, e, k, theta0, P, b]=celp(f_n, N, L, M, c, cb, Pidx);
    
    error = f_n - xhat;
    
    figure
    plot(f_n)
    hold on
    plot(xhat)
    hold on
    plot(error)
    axis ([0 length(f_n) -1 1])
    legend('Señal Original','Señal Sintetizada CELP', 'Error')
    title('Comparativa Caso 7')
        
    soundsc(f_n , F_f)
    soundsc(xhat, F_f)

    % Borramos variables para el siguiente caso
    clc;clear;close all
    
    %Caso 8. c = 0.4
    
    [f_n , F_f] = audioread('frasecorta.wav');
    
    % generación del codebook gaussiano
    randn('state', 0);
    cb=randn(40, 1024);  % 40 veces 1024
    
    N=160; M=10; L=40; c=0.4;Pidx=[16 160];
    
    % xhat nos da la senial sintetizada
    [xhat, e, k, theta0, P, b]=celp(f_n, N, L, M, c, cb, Pidx);
    
    error = f_n - xhat;
    
    figure
    plot(f_n)
    hold on
    plot(xhat)
    hold on
    plot(error)
    axis ([0 length(f_n) -1 1])
    legend('Señal Original','Señal Sintetizada CELP', 'Error')
    title('Comparativa Caso 2')
        
    soundsc(f_n , F_f)
    soundsc(xhat, F_f)
 
     % Borramos variables para el siguiente caso
    clc;clear;close all
    
    % Posible mejor caso
    [f_n , F_f] = audioread('frasecorta.wav');
    
    % generación del codebook gaussiano
    randn('state', 0);
    cb=randn(20, 1024);  % 20 veces 1024
    
    N=160; M=20; L=20; c=0.8;Pidx=[16 160];
    
    % xhat nos da la senial sintetizada
    [xhat, e, k, theta0, P, b]=celp(f_n, N, L, M, c, cb, Pidx);
    
    error = f_n - xhat;
    
    figure
    plot(f_n)
    hold on
    plot(xhat)
    hold on
    plot(error)
    axis ([0 length(f_n) -1 1])
    legend('Señal Original','Señal Sintetizada CELP', 'Error')
    title('Comparativa Mejor Caso')
        
    soundsc(f_n , F_f)
    soundsc(xhat, F_f)
    

% b) Realizar la fase de síntesis para cada uno de los casos analizados en
% el apartado anterior. Mostrar los errores obtenidos en cada caso

% c) Comparar la voz resultante de la síntesis con la original. Evaluar la
% audicion apreciada.

% d) Preparar casos para ser transmitidos a diferente velocidad y evaluar
% la calidad de los resultados obtenidos

    % Vamos a transmitir un caso variando la velocidad, para comprobar como
    % cambian los resultados
    
    clc;clear;close all
    
    [f_n , F_f] = audioread('frasecorta.wav');
    
    % Caso: N=160; M=10; L=40; c=0.8;Pidx=[16 160];
    
    randn('state', 0);
    cb=randn(20, 1024);  % 20 veces 1024
    
    N=160; M=20; L=20; c=0.8;Pidx=[16 160];
    
    % Analisis con Celp
    [xhat_celp, e_celp, k_celp, theta0_celp, P_celp, b_celp]=celp(f_n, N, L, M, c, cb, Pidx);
    % Subimos la velocidad a 16000
    [xhat_celp16k, e_celp16k, k_celp16k, theta0_celp16k, P_celp16k, b_celp16k]=celp16k(f_n, N, L, M, c, cb, Pidx);
    % Bajamos la velocidad a  9600
    [xhat_celp9600, e_celp9600, k_celp9600, theta0_celp9600, P_celp9600, b_celp9600]=celp9600(f_n, N, L, M, c, cb, Pidx);
    
    error_celp = f_n - xhat_celp;
    error_celp16k = f_n - xhat_celp16k
    error_celp9600 = f_n - xhat_celp9600
    
    figure
    plot(f_n)
    hold on
    plot(xhat_celp)
    hold on
    plot(error_celp)
    axis ([0 length(f_n) -1 1])
    legend('Señal Original','Señal Sintetizada CELP', 'Error celp')
    title('Comparativa analizando con Celp')
    
    figure
    plot(f_n)
    hold on
    plot(xhat_celp16k)
    hold on
    plot(error_celp16k)
    axis ([0 length(f_n) -1 1])
    legend('Señal Original','Señal Sintetizada CELP', 'Error celp 16k')
    title('Comparativa analizando con Celp con velocidad 16k')
    
    figure
    plot(f_n)
    hold on
    plot(xhat_celp9600)
    hold on
    plot(error_celp9600)
    axis ([0 length(f_n) -1 1])
    legend('Señal Original','Señal Sintetizada CELP', 'Error celp 9600')
    title('Comparativa analizando con Celp con velocidad 9600')
    
    figure
    hold on
    subplot(3,1,1)
    plot(error_celp, 'r')
    axis ([0 length(error_celp) -1 1])
    title('Error celp')
    subplot(3,1,2)
    plot(error_celp16k, 'g')
    axis ([0 length(error_celp16k) -1 1])
    title('Error celp, v = 16k')
    subplot(3,1,3)
    plot(error_celp9600)
    axis ([0 length(error_celp9600) -1 1])
    title('Error celp, v = 9.6k')
    hold off;
    
    figure
    plot([error_celp9600, error_celp16k, error_celp])
    title('Comparativa errores cambiando la velocidad de transmision')
    legend('Error celp v=9.6k','Error celp v = 16k', 'Error celp')
    
    

% e) Comparar los resultados de los vocoders CELP y LP previamente obtenido
% en la P2. Cuantificar diferencia de errores y sonidos.

    clc;clear;close all
    
    [f_n , F_f] = audioread('frasecorta.wav');

    % CELP
    
        % Caso: N=160; M=12; L=40; c=0.8;Pidx=[16 160];
        
        randn('state', 0);
        cb=randn(40, 1024);  % 40 veces 1024
    
        N=160; M=12; L=40; c=0.8;Pidx=[16 160];
        [xhat_celp, e_celp, k_celp, theta0_celp, P_celp, b_celp]=celp(f_n, N, L, M, c, cb, Pidx);
        
        error_celp=xhat_celp-f_n(1:length(xhat_celp));
        
        soundsc(xhat_celp, F_f)
        
    % LPC
    
        % Caso: N=256; N = 12
        
        N=256; M = 12;
        
        [ar, xi, error_lpc, m]=lpcauto(f_n, M, hann(N), N/2);
        
        %Estudiamos el Pitch de la señal de error (aumentamos N)
        N=1000; th=0.18; minlag=10; maxlag=150; fs=F_f;
        p=lpcpitch(error_lpc,m,N,th,minlag,maxlag);

        % Estimamos el pitch de la señal completa
        th=0.18; 
        minlag =100; 
        maxlag =200; 
        Pitch=lpcpitch(error_lpc, m, N, th, minlag, maxlag);

        % Estimamos la ganancia
        Ganancia=lpcgain(xi(M+1, :), Pitch);

        %LLEVAMOS A CABO LA SÍNTESIS del audio:
        xhat_lpc = lpcsyn(ar, Pitch, Ganancia, m); 
        error_LP=xhat_lpc-f_n(1:length(xhat_lpc));
  

        %Escucha de la senial sintetizada
        soundsc(xhat_lpc,F_f);
    
    % Comparamos errores en los dos vocoders
    
    figure
    plot(f_n)
    hold on
    plot(xhat_lpc)
    hold on
    plot(error_LP)
    axis ([0 length(f_n) -1 1])
    legend('Señal Original','Señal Sintetizada LPC','Error LPC')
    title('Comparativa analizando con LPC')
    
    figure
    plot(f_n)
    hold on
    plot(xhat_celp)
    hold on
    plot(error_celp)
    axis ([0 length(f_n) -1 1])
    legend('Señal Original','Señal Sintetizada CELP', 'Error celp')
    title('Comparativa analizando con Celp')
    
    figure
    hold on
    plot(error_LP, 'r')
    hold on
    plot(error_celp, 'g')
    title('Comparativa errores cambiando el tipo de vocoder')
    legend('Error lpc','Error celp')
    
        
        
        
        