function [UET,UENT] = Umbrales_enmasc_individual(F,LTR,LNTR,UA,MAP)
%UMBRALES_ENMASC_INDIVIDUAL Calcula los umbrales de enmascaramiento individual.
%
%   [UET,UENT]=UMBRALES_ENMASC_INDIVIDUAL(F,LTR,LNTR,UA,MAP)
%   Calcula el efecto enmascarante de las componentes tonales (matriz UET) y 
%   de las componentes no tonales (matriz UENT) sobre las l�neas de frecuencia
%   vecinas. Para esto, el nivel de presi�n sonora de cada componente enmascarante
%   es sumado con su �ndice de enmascaramiento y con su funci�n de enmascaramiento.
%
%   F es el vector de densidad espectral de potencia normalizada, obtenido con
%   ANALISIS_FFT. UA es la matriz de umbral absoluto y MAP es el vector de mapeo
%   entre las l�neas de frecuencia y su �ndice para la matriz UA; ambos obtenidos
%   con UMBRAL_ABSOLUTO. La matriz LTR es la lista reducida de las componentes
%   tonales y la matriz LNTR es la lista reducida de las componentes no-tonales,
%   ambas obtenidas con REDUCCION.
%
%   Ver tambi�n ANALISIS_FFT, COMPONENTES_TONALES, UMBRAL ABSOLUTO, REDUCCION.

% Los umbrales de enmascaramiento individual para las componentes tonales 
% y no tonales se fijan en -INF, ya que la funci�n de enmascaramiento tiene
% atenuaci�n infinita m�s all� de -3 y de +8 Barks, o sea, la componente no
% tiene efecto enmascarante sobre frecuencias m�s all� de aquellos rangos.
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

% S�lo un subconjunto de las muestras son consideradas para el futuro c�lculo
% del umbral de enmascaramiento global. El n�mero de estas muestras depende
% de la tasa de muestreo y de la capa de codificaci�n. Toda la informaci�n 
% necesaria est� en la matriz UA, la cual contiene las frecuencias, las tasas
% de banda cr�tica y el umbral absoluto.
if not(isempty(LTR)) & not(isempty(LNTR))
   for i = 1:130,
      zi = UA(i,2);  % Tasa de banda cr�tica de la frecuencia considerada.   
      if not(isempty(LTR))
         
         % Para las componentes tonales.
         for k = 1:length(LTR(:,1)),
            j  = LTR(k,1);
            zj = UA(MAP(j),2); % Tasa de banda cr�tica de la componente enmascarante.
            dz = zi-zj; % Distancia en Barks hasta la componente enmascarante.
            
            % Como la componente tonal tiene atenuaci�n infinita m�s all� de -3 y
            % de +8 Barks, entonces los c�lculos s�lo se realizan para el rango
            % dz = {-3...+8}.
            if (dz>=-3 & dz<8)
               
               % �ndice de Enmascaramiento.
               avtm = -1.525-0.275*zj-4.5;
               
               % Funci�n de Enmascaramiento.
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
            zj = UA(MAP(j),2); % Tasa de banda cr�tica de la componente enmascarante.
            dz = zi-zj; % Distancia en Barks hasta la componente enmascarante.
            
            % Como la componente no-tonal tiene atenuaci�n infinita m�s all�
            % de -3 y de +8 Barks, entonces los c�lculos s�lo se realizan para
            % el rango dz = {-3...+8}.
            if (dz>=-3 & dz<8)
               
               % �ndice de Enmascaramiento.
               avnm = -1.525-0.175*zj-0.5;
               
               % Funci�n de Enmascaramiento.
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