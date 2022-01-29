sets
c        tipo de anuncio / C, A, V /
l        linea de tren / l1, l2, l3, l4, l5 /
;

table    impact(c,l)      Impacto que se obtiene por tipo de cartel y linea [€]
         l1      l2      l3      l4      l5
C         4       6      10      11       7
A        35      50      30      20      45
V        70      60      55      60      50
;

table    dim(c,l)      Numero de tipo de anuncio por estacion en cada linea
         l1      l2      l3      l4      l5
C        10      15      12       8       9
A         6       5       4       6       3
V         2       1       3       3       4
;

parameters
e_max(l)     Numero maximo de estacions por linea
/
l1       6
l2       5
l3       5
l4       4
l5       5
/

c_cos(c)     Numero maximo de carteles por linea
/
C       0.8
A         2
V         5
/

c_con(c)     Carteles ya comprados
/
C      200
A      100
V       50
/

presup Presupuesto disponible / 550 /
;

integer variable
n_e(l)           Numero de estaciones contratadas de cada linea

binary variable
b_l(l)         Indica si se contrata en la linea l


variable
Impacto       Impacto de la publicidad [€]
Coste         Coste de publicidad [€]
;

equations

E_Impacto    Impacto de la publicidad
E_Coste      Coste de publicidad
E_N_Carteles(c)     Restriccion numero de carteles de cada tipo
E_N_Estacions(l)     Restriccion numero de estaciones por linea
E_PRESUP            Restriccion de presupuesto maximo
E_CONT_LINEA(l)  Restriccion si se contrata la linea l
E_LIN_MAX        Restriccion de numero maximo de lineas que se pueden contratar
E_LIN1_LIN3      Relacion entre la contratacion de la linea 1 y 3
;


E_Impacto ..  Impacto =e=  SUM[l, n_e(l)*SUM[c, dim(c,l)*impac(c,l)]];
E_Coste ..    Coste =e=  SUM[(c,l), n_e(l)*dim(c,l)*c_cos(c)];
E_N_Carteles(c) .. SUM[ll, n_e(l)*dim(c,l)] =l= c_con(c);
E_N_Estacions(l) ..   n_e(l) =l= e_max(l);
E_PRESUP  ..  Coste =l= presup;
E_CONT_LINEA ..   n_e(l) =l= 100*b_l(l) ;
E_LIN_MAX ..     SUM[l, b_l(l)] =l= 4;
E_LIN1_LIN3 .. SUM[l$(ORD(l)=1), b_l(l)] =e= SUM[l$(ORD(l)=3), b_l(l)];

model Publi_a /E_Impacto,E_Coste,E_N_Carteles,E_N_Estacions/ ;
model Publi_b /E_Impacto,E_Coste,E_N_Carteles,E_N_Estacions,E_PRESUP/ ;
model Publi_c /E_Impacto,E_Coste,E_N_Carteles,E_N_Estacions,E_PRESUP,E_CONT_LINEA,E_LIN_MAX,E_LIN1_LIN3/ ;

*resolvemos apartado a)
*solve Publi_a  using MIP maximizing Impacto;

*resolvemos apartado b)
*solve Publi_b  using MIP maximizing Impacto;

*resolvemos apartado c)

*obligamos a contratar la liena 4
b_l.fx('l4') = 1;

option optcr = 0;
solve Publi_c  using MIP maximizing Impacto;

;
