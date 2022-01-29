function LBC = Limites_banda_critica
%LIMITES_BANDA_CRITICA L�mites de las Bandas Cr�ticas.
%
%   LBC=LIMITES_BANDA_CRITICA
%   Proporciona, en la matriz LBC, los valores de la tabla "L�MITES DE LAS BANDAS
%   CR�TICAS" tal y como est� dada en el est�ndar ISO 11172-3; para la Capa II,
%   y una frecuencia de muestreo de 44.1 kHz.
%   
%   Ver tambi�n UMBRAL_ABSOLUTO

% En la matriz LBC se almacena la tabla "L�mites de las Bandas Cr�ticas" para la
% Capa II a 44.1 kHz, proporcionada por el est�ndar ISO 11172-3. Las frecuencias
% corresponden al l�mite superior de cada banda cr�tica.

% �ndice   |	Frecuencia	| Tasa de Banda Cr�tica
%					  	(Hz)					  (z)
LBC = [
  1	   		   43.066	 			 0.425
  2	   		   86.133	 			 0.850
  3	  			  129.199	 			 1.273
  5	  			  215.332	 			 2.112
  7	  			  301.465	 			 2.934
 10	  			  430.664	 			 4.124
 13	  			  559.863	 			 5.249
 16	  			  689.063	 			 6.301
 19	  			  818.262	 			 7.274
 22	  			  947.461	 			 8.169
 26	 			 1119.727	 			 9.244
 30	 			 1291.992				10.195
 35	 			 1507.324				11.232
 40	 			 1722.656				12.125
 46	 			 1981.055				13.042
 51	 			 2325.586				14.062
 56	 			 2756.250				15.100
 62	 			 3273.047				16.110
 69	 			 3875.977				17.079
 74	 			 4478.906				17.904
 79	 			 5340.234				18.922
 85	 			 6373.828				19.963
 92	 			 7579.688				20.971
 99    			 9302.344				22.074
105				11369.531				22.984
117				15503.906				24.013
130				19982.813				24.574
];