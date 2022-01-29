function FDE = Factores_escala(S)
%FACTORES_ESCALA Calcula los factores de escala
%
%   FDE=FACTORES_ESCALA(S)
%   Obtiene los factores de escala (matriz FDE) para cada una de las subbandas en
%   la capa II. S es la matriz de 36x32 muestras subbanda obtenidas con
%   FILTRO_SUBBANDA.
%
%   Se determina el máximo valor absoluto para grupos de 12 muestras subbanda y
%   se compara con los valores de la tabla de factores de escala; eligiendo su
%   valor más cercano por exceso como el factor de escala asociado a cada grupo.
%
%   Ver también FILTRO_SUBBANDA

% Tabla de Factores de Escala proporcionada por el estándar ISO 11172-3.
TFE = [
   2.00000000000000; 1.58740105196820; 1.25992104989487; 1.00000000000000; 
   0.79370052598410; 0.62996052494744; 0.50000000000000; 0.39685026299205; 
   0.31498026247372; 0.25000000000000; 0.19842513149602; 0.15749013123686; 
   0.12500000000000; 0.09921256574801; 0.07874506561843; 0.06250000000000; 
   0.04960628287401; 0.03937253280921; 0.03125000000000; 0.02480314143700; 
   0.01968626640461; 0.01562500000000; 0.01240157071850; 0.00984313320230; 
   0.00781250000000; 0.00620078535925; 0.00492156660115; 0.00390625000000; 
   0.00310039267963; 0.00246078330058; 0.00195312500000; 0.00155019633981; 
   0.00123039165029; 0.00097656250000; 0.00077509816991; 0.00061519582514; 
   0.00048828125000; 0.00038754908495; 0.00030759791257; 0.00024414062500; 
   0.00019377454248; 0.00015379895629; 0.00012207031250; 0.00009688727124; 
   0.00007689947814; 0.00006103515625; 0.00004844363562; 0.00003844973907; 
   0.00003051757813; 0.00002422181781; 0.00001922486954; 0.00001525878906; 
   0.00001211090890; 0.00000961243477; 0.00000762939453; 0.00000605545445; 
   0.00000480621738; 0.00000381469727; 0.00000302772723; 0.00000240310869;
   0.00000190734863; 0.00000151386361; 0.00000120155435; 1E-20
];

FDE = [];

for a = 1:12:36,
   for i = 1:32,
      
      % Determina el máximo valor absoluto de 3 grupos (índice a) de 12 muestras
      % subbanda para cada una de las 32 subbandas (índice i) y lo almacena en
      % MAXS.
      MAXS = max(abs(S(a:a+11,i)));
      
      % Realiza un barrido de la tabla de factores de escala hasta encontrar en
      % ella un valor mayor que el valor de MAXS.
      j = 0;
      while (j<64 & MAXS>TFE(64-j))
        	j = j+1;
      end
        
      % Crea el vector MAXT, que es compuesto de cada factor de escala elegido de
      % la tabla (para cada i) en el paso anterior.
      MAXT(i) = TFE(64-j);
      
   end
   
   % Almacena en la matriz FDE los valores que va tomando MAXT (para cada a);
   % resultando una matriz de 3x32, o sea, 3 factores de escala elegidos para
   % cada subbanda.
   FDE = [FDE; MAXT];
end