SETS
i n�mero de proyecto /1,2,3,4,5,6/
j consultora /A,B,C,D/

SCALARS
q n�mero de proyectos -1 /5/
t numero m�nimo de trabajadores que tiene que aportar cada consultora
/200/
g m�nimo de trabajadores que tiene que aportar cada consultora por
proyecto que participe /30/
f numero m�nimo de consultoras que tienen que participar en cada proyecto /2/

PARAMETERS
h(j) numero de trabajadores que ofrece cada consultora j
/A 600, B 750, C 800, D 700/
c(j) coste por cada trabajador asignado para consultora j (miles de �)
/A 22.5, B 21, C 20.5, D 21.5/
n(i) numero m�nimo de trabajadores para el proyecto i
/1 200, 2 275, 3 250, 4 220, 5 180, 6 210/
p (i) presupuesto maximo del proyecto i (millones de �)
/1 4500, 2 6000, 3 5300, 4 4900, 5 4300, 6 4700/
;

VARIABLES
VFO funcion objetivo minimo coste
X(i,j) n�mero de trabajadores de la consultora j asignados al proyecto i
Y(i,j) indicador si la consulta j participa en el proyecto i
;

POSITIVE VARIABLES X;
BINARY VARIABLES Y;

EQUATIONS
FOA funci�n objetivo: minimo coste (apdo A)
MAXTRABAJ(j) n�mero de trabajdores m�ximos por consultora
PRESMAX (i) presupuesto m�ximo por proyecto
PARTICMIN (i) minimo consultoras por proyecto
NINGUN (j) ninguna consultora puede participar en todos los proyectos
MINTRABAJ (j) minimo numero trabajadores por consultora
SIPARTIC (i,j) Si se participa en algun proyecto al menos con 30 trabajadores
PROYECTMIN (i) minimo de trabajadores por proyecto
XPOSITIVE (i,j) variable positiva
;

FOA .. VFO =E= SUM[(i,j), c(j)*X(i,j)];
MAXTRABAJ(j).. SUM(i, X(i,j)) =L= h(j);
PRESMAX(i).. SUM(j, c(j)*X(i,j)) =L= p(i);
PARTICMIN(i).. SUM(j, Y(i,j)) =G= f;
NINGUN(j).. SUM(i, Y(i,j)) =L= q;
MINTRABAJ(j).. SUM(i, X(i,j)) =G= t;
SIPARTIC (i,J).. X(i,j)=G=g*Y(i,j);
PROYECTMIN (i).. SUM(j, X(i,j))=G= n(i);
XPOSITIVE (i,j).. X(i,j)=G=0;
;
MODEL SUBCONTRATACIONA /MAXTRABAJ, PRESMAX, PARTICMIN, NINGUN,
MINTRABAJ, SIPARTIC, PROYECTMIN, XPOSITIVE/
SOLVE SUBCONTRATACIONA MINIMIZING VFO USING MIP;