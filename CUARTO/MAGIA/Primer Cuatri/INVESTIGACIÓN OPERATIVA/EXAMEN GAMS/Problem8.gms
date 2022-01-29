SETS
 i campos / C1, C2, C3, C4 /
 j meses / 1, 2, 3, 4, 5, 6 /

ALIAS (i,k) ;

SCALARS
m Penalización por falta de agua en un campo [euros por cajas] /2/
v Volumen máximo del contenedor [litros]/50/
t Precio del contenedor en un campo  [euros] /2/


PARAMETERS
 u(i) Cantidad de lluvia por el campo i por mes [litros]
 /C1 60
  C2 60
  C3 60
  C4 80 / ;

TABLE d(i,j) Demanda del campo i en el mes j [litros por cajas]
    1  2  3  4  5  6
C1 59 54 64 65 62 66
C2 60 56 66 66 63 69
C3 64 49 65 70 58 68
C4 55 50 68 59 67 68 ;

TABLE c(i,k) Cantidad máxima de agua de la turbería entre los nodos i [litros por tuberías]
       C1    C2    C3   C4
C1      0   100   100    0
C2    100     0   100    1
C3    100   100     0    1
C4      0     1     1    0 ;

TABLE p(i,j) Precio del producto del campo i en el mes j  [euros]
     1           2           3           4           5          6
C1  5.90        5.00        6.40        7.00        7.50      6.00
C2  6.195       5.25        6.72        7.35        7.875     6.30
C3  6.50475     5.5125      7.056       7.7175      8.26875   6.615
C4  6.82999     5.78813     7.4088      8.10338     8.68219   6.9457 ;

VARIABLES
X(i,j)   Numero de litros de agua total en el campo i en el mes j[litros]
Q(i,j)   Cantidad de agua en el contenedor del campo C1 en el mes j  [litros]
Z(i,j)   Productos fabricados para la venta [kilos]
F(i,k,j) Flujo entre los nodos i y k por el mes j [litros por tubería por mes]
E(i,j)   Sobras de agua con respecto a la demanda [litros]
H(i,j)   Falta de agua con respecto a la demanda [litros]
W(i,j)   Valdrá 1 si hay defecto de agua
G(i)     Valdrá 1 si se pone contenedor en el campo i
BF       Beneficios del granjero [euros]
;

POSITIVE VARIABLES X, Q, Z, F, E, H, BF ;
BINARY VARIABLES W, G ;

EQUATIONS
 BENEFICIOS     beneficios total del granjero [euros]
 PRODUCTO(i,j)  total de productos para la venta[kilos]
 CAPACIDAD(i,j) capacidad máxima de un contenedor en el campo i por el campo j[litros]
 TUBERIA(i,k,j) capacidad máxima de cada tubería entre los nodos i y k [litros]
 BALANCE(i,j)   balance en cada nodo de la red [litros]
 BALANCET(j)    Total de agua en toda la red en el mes j [litros]
 BALANCEA(i,j)  determinar la cantidad de agua total por mes y por campo C2 C3 C4 [litros]
 BALANCEB(j)    determinar la cantidad de agua total por mes y por el campo 1 [litros]
 FALTA(i,j)     determinar si hay defecto o no
 EXCESO(i,j)    exceso de agua en el campo i el mes j  CONTENEDOR     1 contenedor como maximo en cada campo
;

 BENEFICIOS      ..
      BF =E= SUM((i,j),(Z(i,j)*p(i,j))- H(i,j)*m) - SUM(i, t*G(i)) ;

 PRODUCTO(i,j)   ..   Z(i,j) =E= d(i,j) - H(i,j);
 CAPACIDAD(i,j)  ..   Q(i,j) =L= v ;
 TUBERIA(i,k,j)  ..   F(i,k,j) =L= c(i,k) ;
 BALANCE(i,j)    ..   X(i,j) + H(i,j) - E(i,j) =E= d(i,j);
 BALANCET(j)     ..
      SUM(i,X(i,j)) =E= SUM(i,u(i)) + SUM(i,Q(i,j)-Q(i,j-1));
 BALANCEA(i,j)$[ORD(i)>1] ..
      X(i,j)=E= u(i)+SUM(k,F(k,i,j))-SUM(k,F(i,k,j))+Q(i,j)-Q(i,j-1);
 BALANCEB(j)     ..
      X('C1',j)=E=u('C1')+ SUM(k, F(k,'C1',j))
      -SUM(k, F('C1',k,j))+Q('C1',j) - Q('C1',j-1);
 FALTA(i,j)      ..   H(i,j) =L= W(i,j)*v ;
 EXCESO(i,j)     ..   E(i,j) <= (1-W(i,j))*v ;
 CONTENEDOR      ..   SUM(i,G(i)) =L= 1;

MODEL ALMACENAMIENTO / ALL / ;
SOLVE ALMACENAMIENTO USING MIP MAXIMIZING BF ;
