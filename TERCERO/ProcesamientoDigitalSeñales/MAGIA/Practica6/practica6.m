%Practica 6

%% DISEÑO FILTRO FIR

%% Apartado a)
%Cargo fichero

[x, Fs]= audioread("PDS_P6_3A_LE1_G2.wav");
load("PDS_P6_3A_LE1_G2.mat")

%Hago sonar el audio

%sound(x, Fs);

%Se observa un ruido molesto

%% Apartado b)

%Calculamos la fast fourier transform
X_f=fft(x, length(x))/length(x);

%Centramos espectro en el 0
X_f= fftshift(abs(X_f));

%Creamos vector de frecuencias para poder representarlo
vector_frec= linspace(-Fs/2,Fs/2, length(x));

figure;
plot(vector_frec, X_f);
xlabel("Frecuencia [Hz]");
ylabel("Amplitud [V]");
axis([-10000 10000 0 0.05]);
title("Espectro de x(t)");
grid on;



%% Apartado c) Justificacion filtro

% El filtro tiene que tener una frecuencia de corte de 5000Hz ya que de esta manera atenuará 
% casi de manera completa el tono molesto del audio sin acercase demasiado a la señal que nos interesa.
% Además el tono es de 6000Hz, por tanto podemos esperar que la banda de transicion del filtro deseado 
% sea menor que 1Khz
load('COEFICIENTES.mat');


%% Apartado d) Representacion del filtro

%Obtenemos la respuesta en frecuencia del filtro FIR

%No normalizamos la fft porque nos coeficientes exportados al .mat estan
%normalizados
H_lowpass=fft(Num_Filter, 500);
H_lowpass=fftshift(H_lowpass);


%Vector de frecuencias de referencia
f_lowpass=linspace(-Fs/2, Fs/2, length(H_lowpass));


H_lowpass= mag2db(abs(H_lowpass));

figure;
plot(f_lowpass, H_lowpass);
xlabel("Frecuencia [Hz]");
ylabel("Atenuacion [dB]");
axis([0 50000 -100 10]);
title("Filtro Diseñado");
grid on;


% Para justificar si lo hemos diseñado bien sometemos a x a un filtrado

g= filter(Num_Filter, 1, x);
G_f=fftshift(abs(fft(g, length(g))/length(g)));

figure;
plot(vector_frec, G_f);
xlabel("Frecuencia [Hz]");
ylabel("Amplitud");
axis([-10000 10000 0 0.01]);
title("Espectro de g(t)");
grid on;

%% ALGORITMO OVERLAP-SAVE

%La longitud del filtro FIR esta determinada por el numero de
%coeficientes=> el orden del mismo +1

longitud_filtro = M+1;

%Calculamos la fast fourier transform del filtro con 500 puntos para 
%poder hacer la multiplicacion punto a punto 

H_f=fft(Num_Filter, 500);

%Definimos la longitud de los trozos que se van cogiendo de la señal original
longitud_trozo= 500-longitud_filtro+1;

%Inicializamos la salida
y= zeros(1, length(x));


%El bucle tiene tantas iteraciones como trozos de 500-100= 400 muestras
%haya contenidos en la señal original

for i=1:ceil(length(x)/longitud_trozo)
    
    %En la primera iteracion necesitamos meter longitud_del_filtro-1 ceros
    if(i==1)
        %Creamos un trozo completo = trozo original+(longitud_filtro-1)zeros
        x_r=zeros(1, longitud_trozo+longitud_filtro-1);
        x_r(longitud_filtro: end)= x(i:longitud_trozo);
    else
        %En iteraciones posteriores: las longitud_filtro-1 primeras
        %muestras del trozo completo corresponden a las p-1 ultimas muestras del
        %trozo original anterior
        
        x_r=zeros(1, longitud_trozo+longitud_filtro-1);
        x_r(1: longitud_filtro-1)= x((i-1)*longitud_trozo-longitud_filtro+2: (i-1)*longitud_trozo);
        
        %Hay que tener cuidado con la ultima iteracion ya que el ultimo
        %trozo no va a ser de 400 muestras asi que añadimos ceros a la
        %derecha
        if(i==ceil(length(x)/longitud_trozo))
            x_r(longitud_filtro: longitud_filtro+length(x((i-1)*longitud_trozo+1: end))-1)= x((i-1)*longitud_trozo+1: end);
        else
            x_r(longitud_filtro: end)= x((i-1)*longitud_trozo+1: i*longitud_trozo);
        end
    end
    
    %Es ahora cuando se hace el producto punto a punto de las DFT del
    %filtro e y_r => equivale a convolucion circular
    
    fft_trozo=fft(x_r);
    
    producto_parcial=H_f.*fft_trozo;
    
    trozo_salida=ifft(producto_parcial);
    
    y((i-1)*(longitud_trozo)+1:  i*longitud_trozo)=trozo_salida(longitud_filtro:end);
    
end




%% APARTADO DE ANALISIS

%Calculo g[n]

g= filter(Num_Filter, 1, x);

y=y(1: end-(length(y)-length(x))); %Me quito los ultimos valores

%Construyo un vector de muestras
vector_muestras= 1:1:length(g);

y=y.';

figure;
hold on;
plot(vector_muestras, g, 'black--o');
plot(vector_muestras, y);
xlabel("Muestras [n]");
ylabel("Amplitud");
axis([12075 12095 0 0.15]);
title("Filtrado estándar VS Overlap-save");
legend('Resultado Filter', 'Overlap-save');
grid on;


%La coincidencia es total


%Aqui se muestra con un subplot

figure;
subplot(2,1,1)
plot(vector_muestras, g,'black');
xlabel("Muestras [n]");
ylabel("Amplitud");
title("Filtrado estándar");
grid on;


subplot(2,1,2)
plot(vector_muestras,y);
xlabel("Muestras [n]");
ylabel("Amplitud");
title("Overlap-save");
grid on;


%% Calculo del error cuadratico medio


%Recordamos que el ECM es 1/n * sum(abs(y-g))
error=(1/length(y))* sum(abs(y-g).^2);
disp(error);


%% Representación en frecuencia


%Me calculo las fft, las centro y represento todo

Y_f=fftshift(abs(fft(y, length(y))/length(y)));

%La fft de la x la tengo del primer ej
%Tambien tenemos en el workspace un vector de frecuencias valido

figure;
subplot(3,1,1)
plot(vector_frec, X_f,'black');
xlabel("Frecuencia [Hz]");
ylabel("Amplitud");
title("Espectro original");
axis([-6500 6500 0 0.007]);
grid on;


subplot(3,1,2)
plot(vector_frec,G_f);
xlabel("Frecuencia [Hz]");
ylabel("Amplitud");
axis([-6500 6500 0 0.007]);
title("Filtrado estándar G[z]");
grid on;

subplot(3,1,3)
plot(vector_frec, Y_f);
xlabel("Frecuencias [Hz]");
ylabel("Amplitud");
axis([-6500 6500 0 0.007]);
title("Overlap-save Y[z]");
grid on;


%Representamos también la superposicion

figure;
hold on;
plot(vector_frec, X_f,'r');
plot(vector_frec, G_f, 'y');
plot(vector_frec, Y_f, 'b');
xlabel("Frecuencias [Hz]");
ylabel("Amplitud");
title("Superposicion de espectros");
axis([-6500 6500 0 0.007]);
legend('original', 'filter', 'overlap-save');
grid on;

%% Para ver si el filtrado ha funcionado podemos escuchar la señal

%Efectivamente ya no está el pitido
%sound(y, Fs);