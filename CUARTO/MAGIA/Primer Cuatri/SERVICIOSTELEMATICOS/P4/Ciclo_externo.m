function [XFSF,preflag] = Ciclo_externo(SFBT,IX,qquant,quantanf,scalefac_scale)
%CICLO_EXTERNO Realiza el ciclo para el control de la distorsión.
%
%   [XFSF,PREFLAG]=CICLO_EXTERNO(SFBT,IX,QQUANT,QUANTANF,SCALEFAC_SCALE)
%   XFSF es el vector de la distorsión en cada una de las bandas del factor de
%   escala. PREFLAG indica si la opción de preénfasis ha sido utilizada o no.
%
%   SFBT es la matriz de las bandas del factor de escala, obtenida en WAV2MP3.
%   IX es el vector de valores espectrales cuantizados, obtenido con CICLO_INTERNO.
%   QQUANT y QUANTANF son los valores usados para el intervalo de cuantización,
%   obtenidos con CICLO_INTERNO. SCALEFAC_SCALE es el factor logarítmico de 
%   cuantización para los factores de escala, obtenido en WAV2MP3.
%
%   Ver también WAV2MP3, CICLO_INTERNO.

global XR gr xmin scalefac_l

% La opción de preénfasis no se implementa.
preflag = 0;

% Calcula la distorsión en las bandas del factor de escala (vector XFSF), y luego
% amplifica las bandas del factor de escala que exceden el umbral de enmascaramiento.
ifqstep = 2^(0.5*(1+scalefac_scale));
XFSF = zeros(1,21);
for sb = SFBT,
   for i = sb(3):sb(4),
      XFSF(sb(1)) = XFSF(sb(1))+(abs(XR(i))-IX(i)^(4/3)*2^((qquant+quantanf)/4))^2/sb(2);
   end
   if xmin(sb(1)) < XFSF(sb(1))
      scalefac_l(sb(1),gr) = scalefac_l(sb(1),gr) + 1;
      xmin(sb(1)) = xmin(sb(1))*ifqstep^(2*scalefac_l(sb(1),gr));
      for i = sb(3):sb(4),
         XR(i) = XR(i)*ifqstep^scalefac_l(sb(1),gr);
      end
   end
end