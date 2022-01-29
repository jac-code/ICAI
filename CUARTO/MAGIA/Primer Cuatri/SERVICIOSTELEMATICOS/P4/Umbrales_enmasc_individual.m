function [UET,UENT] = Umbrales_enmasc_individual(F,LTR,LNTR,UA,MAP)
%UMBRALES_ENMASC_INDIVIDUAL Calcula los umbrales de enmascaramiento individual.
%
%   [UET,UENT]=UMBRALES_ENMASC_INDIVIDUAL(F,LTR,LNTR,UA,MAP)
%   Calcula el efecto enmascarante de las componentes tonales (matriz UET) y 
%   de las componentes no tonales (matriz UENT) sobre las líneas de frecuencia
%   vecinas. Para esto, el nivel de presión sonora de cada componente enmascarante
%   es sumado con su índice de enmascaramiento y con su función de enmascaramiento.
%
%   F es el vector de densidad espectral de potencia normalizada, obtenido con
%   ANALISIS_FFT. UA es la matriz de umbral absoluto y MAP es el vector de mapeo
%   entre las líneas de frecuencia y su índice para la matriz UA; ambos obtenidos
%   con UMBRAL_ABSOLUTO. La matriz LTR es la lista reducida de las componentes
%   tonales y la matriz LNTR es la lista reducida de las componentes no-tonales,
%   ambas obtenidas con REDUCCION.
%
%   Ver también ANALISIS_FFT, COMPONENTES_TONALES, UMBRAL ABSOLUTO, REDUCCION.

% Los umbrales de enmascaramiento individual para las componentes tonales 
% y no tonales se fijan en -INF, ya que la función de enmascaramiento tiene
% atenuación infinita más allá de -3 y de +8 Barks, o sea, la componente no
% tiene efecto enmascarante sobre frecuencias más allá de aquellos rangos.
if isempty(LTR)
   UET = [];
else
   UET = zeros(length(LTR(:,1)),130) - 200; % -200 dB equivale a -INF.
end
if isempty(LNTR)
   UENT = [];
else
   UENT = zeros(length(LNTR(:,1)),130) - 200; % -200 dB equivale a -INF.
end

% Sólo un subconjunto de las muestras son consideradas para el futuro cálculo
% del umbral de enmascaramiento global. El número de estas muestras depende
% de la tasa de muestreo y de la capa de codificación. Toda la información 
% necesaria está en la matriz UA, la cual contiene las frecuencias, las tasas
% de banda crítica y el umbral absoluto.
if not(isempty(LTR)) & not(isempty(LNTR))
   for i = 1:130,
      zi = UA(i,2);  % Tasa de banda crítica de la frecuencia considerada.   
      if not(isempty(LTR))
         
         % Para las componentes tonales.
         for k = 1:length(LTR(:,1)),
            j  = LTR(k,1);
            zj = UA(MAP(j),2); % Tasa de banda crítica de la componente enmascarante.
            dz = zi-zj; % Distancia en Barks hasta la componente enmascarante.
            
            % Como la componente tonal tiene atenuación infinita más allá de -3 y
            % de +8 Barks, entonces los cálculos sólo se realizan para el rango
            % dz = {-3...+8}.
            if (dz>=-3 & dz<8)
               
               % Índice de Enmascaramiento.
               avtm = -1.525-0.275*zj-4.5;
               
               % Función de Enmascaramiento.
               if (-3<=dz & dz<-1)
                  vf = 17*(dz+1)-(0.4*F(j)+6);
               elseif (-1<=dz & dz<0)
                  vf = (0.4*F(j)+6)*dz;
               elseif (0<=dz & dz<1)
                  vf = -17*dz;
               elseif (1<=dz & dz<8)
                  vf = -(dz-1)*(17-0.15*F(j))-17;
               end
               
               % Umbral de enmascaramiento, componentes tonales.
               UET(k,i) = F(j)+avtm+vf;
            end
         end
      end
      
      % Para las componentes no tonales.
      if not(isempty(LNTR))
         for k = 1:length(LNTR(:,1)),
            j  = LNTR(k,1);
            zj = UA(MAP(j),2); % Tasa de banda crítica de la componente enmascarante.
            dz = zi-zj; % Distancia en Barks hasta la componente enmascarante.
            
            % Como la componente no-tonal tiene atenuación infinita más allá
            % de -3 y de +8 Barks, entonces los cálculos sólo se realizan para
            % el rango dz = {-3...+8}.
            if (dz>=-3 & dz<8)
               
               % Índice de Enmascaramiento.
               avnm = -1.525-0.175*zj-0.5;
               
               % Función de Enmascaramiento.
               if (-3<=dz & dz<-1)
                  vf = 17*(dz+1)-(0.4*F(j)+6);
               elseif (-1<=dz & dz<0)
                  vf = (0.4*F(j)+6)*dz;
               elseif (0<=dz & dz<1)
                  vf = -17*dz;
               elseif (1<=dz & dz<8)
                  vf = -(dz-1)*(17-0.15*F(j))-17;
               end
               
               % Umbral de enmascaramiento, componente no-tonal.
               UENT(k,i) = F(j)+avnm+vf;
               
            end
         end
      end
   end
end