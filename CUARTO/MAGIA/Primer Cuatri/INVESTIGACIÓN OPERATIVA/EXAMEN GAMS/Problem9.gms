sets
i numero de semana / s1, s2, s3 /
j puesto de trabajo / p1, p2, p3 /

parameters
b (i) demanda de bombones de la semana i/ s1 43, s2 33, s3 0/
c (j) coste unitario de produccion por puesto j/ p1 2, p2 1, p3 0.8 /
k (j) coste unitario de alamacenaje por semana en puesto j
         / p1 0.02, p2 0.03, p3 0.005 /
m (j) stock maximo en puesto j/  p1 30, p2 30, p3 35/
n (j) m�nimo stock en puesto j/ p1 10, p2 10, p3 10/
p (j) producci�n m�xima semanal en puesto j/ p1 20, p2 10, p3 8/
z (j) stock inicial y final en puesto j/ p1 17, p2 20, p3 20/

variables
S (i, j) cantidad de producto al inicio de la semana i en puesto j.
X (i, j) producci�n durante la semana i en el puesto j.
Y(i,j)  demanda decada caja j la semana i.
CT coste total de produccion .

POSITIVE VARIABLE X, S, Y;

EQUATIONS
COSTE coste total de produccion [euros]
CAPACIDADMAX (i,j) capacidad maxima de produccion semanal de cada puesto j [bombones]
STOCKMIN (i,j) Stock minimo de cada puesto j [bombones]
STOCKMAX (i,j) Stock maximo de cada puesto j [bombones]
STOCKIN (j)  Stock inicial de cada puesto j [bombones]
STOCKFIN (j)  Stock final de cada puesto j [bombones]
DEMANDAPUESTO (i,j) satisfaccion demanda de cada caja j en la semana i [bombones]
DEMANDATOTAL (i) demanda total de la semana i;

COSTE .. CT =E= SUM((i,j), c(j) * X(i,j)) + SUM((i,j),(S(i,j)+S(i+1, j))/2*k(j))-SUM((j),S('s3',j)/2*k(j));
CAPACIDADMAX (i,j) ..  X(i,j) =L= p(j) ;
STOCKMIN (i, j) .. S(i,j) =G= n(j) ;
STOCKMAX (i, j) .. S(i,j) =L= m(j) ;
STOCKIN (j) .. S('s1', j) =E= z (j);
STOCKFIN (j) .. S('s3', j) =E= z (j);
DEMANDAPUESTO (i,j) $ (ORD(i) ne CARD(i))) ..  S(i, j) + X(i,j)- S(i+1,j)=E= +Y(i,j);
DEMANDATOTAL (i) .. SUM ((j), Y(i,j))=E= b(i);


model produccion /all/;
solve produccion using LP minimizing CT;

