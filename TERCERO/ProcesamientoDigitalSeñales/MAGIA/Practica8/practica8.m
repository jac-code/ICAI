%% Definimos período de muestreo
Ts=2^3;

%% Definimos la longitud del buffer de transmisión
BL_TX = 2^15;

%% Definimos el número de simbolos por frame
N = BL_TX/Ts;

%% Orden de la modulación
%Elejimos igual que en el python, orden 4
M = 4;

%% Creación del generador de símbolos aleatorios de Bernouilli

symbols = exp(1j*(2*pi*(floor(rand(N,1)*M)/M)+pi/4));

%% Interpolamos

interpolated_symbols = zeros(1,Ts*length(symbols));
interpolated_symbols(1:Ts:end)= symbols;

%% Filtramos con convolución normal
%Valor de beta entre 0 y 1 y valor de span de tipo entero
Beta = 0.35;%indica el porcentaje roll off
span = 10;% longitud del filtro en símbolos
sps = Ts;%Muestras por símbolo, es decir el período de muestreo
%Generación del filtro de coseno alzado
h = srrc_filter(Beta,span,sps,"sqrt");
%filtramos la señal con nuestro simbolos interpolados previamente
y_conv = conv(interpolated_symbols,h);
figure;
plot(y_conv);

%% Aclaraciones
%El porcentaje de roll off lo podemos relacionar con la eficiencia
%espectral, es decir, la pendiente de la zona de transición entre banda de
%paso y banda de corte, cuanto más pequeño sea, mayor eficiencia espectral
%pero menor ancho de banda, es decir, este valor nos indica el exceso de
%ancho de banda de nuestro filtro.
%El span nos indica el número de símbolos de nuestro filtro, debe ser un
%escalar positivo

%% Filtrado con overlap-save

longitud_filtro = length(h)+1;

%Calculamos la fast fourier transform del filtro con 500 puntos para 
%poder hacer la multiplicacion punto a punto 

H_f=fft(h, 500);

%Definimos la longitud de los trozos que se van cogiendo de la señal original
longitud_trozo= 500-longitud_filtro+1;

%Inicializamos la salida
y= zeros(1, length(interpolated_symbols));

for i=1:ceil(length(interpolated_symbols)/longitud_trozo)
    
    %En la primera iteracion necesitamos meter longitud_del_filtro-1 ceros
    if(i==1)
        %Creamos un trozo completo = trozo original+(longitud_filtro-1)zeros
        x_r=zeros(1, longitud_trozo+longitud_filtro-1);
        x_r(longitud_filtro: end)= interpolated_symbols(i:longitud_trozo);
    else
        %En iteraciones posteriores: las longitud_filtro-1 primeras
        %muestras del trozo completo corresponden a las p-1 ultimas muestras del
        %trozo original anterior
        
        x_r=zeros(1, longitud_trozo+longitud_filtro-1);
        x_r(1: longitud_filtro-1)= interpolated_symbols((i-1)*longitud_trozo-longitud_filtro+2: (i-1)*longitud_trozo);
        
        if(i==ceil(length(interpolated_symbols)/longitud_trozo))
            x_r(longitud_filtro: longitud_filtro+length(interpolated_symbols((i-1)*longitud_trozo+1: end))-1)= interpolated_symbols((i-1)*longitud_trozo+1: end);
        else
            x_r(longitud_filtro: end)= interpolated_symbols((i-1)*longitud_trozo+1: i*longitud_trozo);
        end
    end
    
    %Es ahora cuando se hace el producto punto a punto de las DFT del
    %filtro e y_r => equivale a convolucion circular
    
    fft_trozo=fft(x_r);
    
    producto_parcial=H_f.*fft_trozo;
    
    trozo_salida=ifft(producto_parcial);
    
    y((i-1)*(longitud_trozo)+1:  i*longitud_trozo)=trozo_salida(longitud_filtro:end);
    
end

figure;
plot(y);

%% 
%Podemos comprobar que tanto con el algoritmo de overlap-save como con la
%convolución funciona correcatamente, forma de comprobar que el algoritmo
%está correctamente implementado