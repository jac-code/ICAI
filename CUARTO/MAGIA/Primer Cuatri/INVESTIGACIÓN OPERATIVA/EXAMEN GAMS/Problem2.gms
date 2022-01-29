
SETS i nodes /n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11/
ALIAS (i,j)

SETS k(i) demand nodes / n1, n2, n3, n5, n6, n7, n8, n11/
l(i) storage nodes /n4, n9, n10/

PARAMETERS c(l) storage at l /n4 100, n9 300, n10 200/
d(k) demand at k /n1 220, n2 220, n3 20, n5 10, n6 20, n7 10, n8 20, n11 10/

SCALAR lf flow limit [cubic meters] /100/
TABLE a(i,j) existing relations between nodes
*1 if there is a pipline between node i and j
*0 else
   n1 n2 n3 n4 n5 n6 n7 n8 n9 n10 n11
n1 0  1  0  1  1  0  0  0  0  0   0
n2 1  0  1  0  1  1  0  1  0  0   0
n3 0  1  0  0  0  1  0  0  1  0   0
n4 1  0  0  0  0  0  0  0  0  1   0
n5 1  1  0  0  0  0  1  1  0  0   0
n6 0  1  1  0  0  0  0  1  1  0   0
n7 0  0  0  0  1  0  0  1  0  1   0
n8 0  1  0  0  1  1  1  0  0  1   1
n9 0  0  1  0  0  1  0  0  0  0   1
n10 0 0  0  1  0  0  1  1  0  0   1
n11 0 0  0  0  0  0  0  1  1  1   0


TABLE p(i,j) cost for using pipelines between i and j [kEuros]
*Only private pipelines have costs
   n1 n2 n3 n4 n5 n6 n7 n8 n9 n10 n11
n1  0 0  0  0  0   0 0  0  0    0 0
n2  0 0  10 0  0  11 0  15 0    0 0
n3  0 10 0  0  0   0 0  0  0    0 0
n4  0 0  0  0  0   0 0  0  0    0 0
n5  0 0  0  0  0   0 0  9  0    0 0
n6  0 11 0  0  0   0 0  0  0    0 0
n7  0 0  0  0  0   0 0  8  0    0 0
n8  0 15 0  0  9   0 8  0  0    0 0
n9  0 0  0  0  0   0 0  0  0    0 0
n10 0 0  0  0  0   0 0  0  0    0 0
n11 0 0  0  0  0   0 0  0  0    0 0

VARIABLES OFV objective function value
Y(i,j) gas flow going from i to j
X(i,j) indicator of whether the pipeline from i to
j is used or not

BINARY VARIABLES X;
POSITIVE VARIABLE Y,OFV;

EQUATIONS
OF objective function. total cost of
the supply
STORAGE(l) maximun storage in node l
DEMAND(k) required demand in each node
CONECTIONS(i,j) cancels flow when the pipeline doesn't exist
XY1(i,j) relation 1 between X and Y
XY2(i,j) relation 2 between X and Y
ONEWAY(i,j) the flow can only go in one
direction in each pipeline
;

OF .. OFV =E= SUM
((i,j),X(i,j)*p(i,j));
STORAGE(l) .. SUM(j,Y(l,j)) - SUM(j,Y(j,l))
=L= c(l);
DEMAND(k) .. SUM(i, Y(i,k)) - SUM(i,Y(k,i))
=E= d(k);
CONECTIONS(i,j) .. Y(i,j) =L= lf*a(i,j);
XY1(i,j) .. Y(i,j) =L= lf*X(i,j);
XY2(i,j) .. Y(i,j) =G= 0.001*X(i,j);
ONEWAY(i,j) .. X(i,j) + X(j,i) =L= 1;

MODEL NATURALGAS /OF, STORAGE, DEMAND, CONECTIONS,
XY1, XY2, ONEWAY/
SOLVE NATURALGAS MINIMIZING OFV USING LP