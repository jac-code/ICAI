function [salida, nuevos_tiempos] = Interpolador(y,t,L)

    %Los argumentos son:
    %  - y señal a interpolar
    %  - t vector de tiempos de la señal
    %  - L factor de interpolacion
    
    %Valores de salida:
    %  - salida: la señal interpolada
    %  - nuevos_tiempos: la nueva referencia temporal
    
    %Interpolar consiste en añadir L-1 muestras a 0 por cada muestra de la
    %señal de entrada
   
    salida= zeros(1, length(y)*L); %vector a 0 de la longitud que va a ocupar la señal interpolada
    salida(1:L:end) = y;           %sobre el vector de zeros introduzco los valores de la señal original 
    
    salto=(t(2)-t(1))/L;           %nuevo_periodo=periodo_anterior/L
   
    nuevos_tiempos= t(1):salto:(t(end)+salto); %nueva referencia temporal mas larga
end

