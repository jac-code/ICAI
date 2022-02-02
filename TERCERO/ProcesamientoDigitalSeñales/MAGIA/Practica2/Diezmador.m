function [salida, nuevos_tiempos] = Diezmador(y,t,M)
    
    %Los argumentos son
    %  - y señal a diezmar
    %  - t vector de tiempos de la señal
    %  - M factor de diezmado
    
    %Valores de salida:
    %  - salida: la señal diezmada
    %  - nuevos_tiempos: la nueva referencia temporal
    
    %Diezmar consiste en tomar 1 de cada M muestras en el dominio temporal 
    
    salto=(t(2)-t(1))*M;  %Lo mismo que decir salto=mi_nuevo_periodo=M*periodo_anterior
    
    % Mi frecuencia de muestreo se ve dividida por un factor M y mi periodo
    % lo contrario
    
    nuevos_tiempos= t(1):salto:t(end); %mi nuevo vector de tiempos coge 1 referencia de cada m del vector de tiempos original
    
    salida = zeros(1,floor(length(y)/M)); % inicializo el vector a 0
    salida = y(1:M:end);                  % tomo 1 de cada M valores de la señal 
    
end

