
SETS
i products /A,B,C/
j factories /F1,F2,F3,F4,F5,F6/

PARAMETERS
p(i) price of product i
     /A 60,  B 82.5, C   108/
b(i) contracted quantity of product i
     / A 700, B 500, C 600/
f(j) capacity of factory j
     / F1 550.0, F2 700, F3 1100,
         F4 350, F5 400, F6 450/

TABLE c(i,j) manufacturing cost of product i in factory j
     F1   F2  F3 F4   F5   F6
A     25  30  26 34  32  30
B    30  32    34 35  38  40
C     40  46  42  37  40  50

VARIABLES
VFO      value of the objective function: maximize profits by substracting the manufacturing cost from the sales price
X (i,j)  quantity of product i produced in factory j

POSITIVE VARIABLE X;

EQUATIONS
FO   profits obtain by each product
CAPACITY(j) capacity of each factory cannot be exceed
CONTRACT(i) number of units already sold via contracts;
FO..             VFO =E= SUM((i,j),( p(i)- c(i,j))*X(i,j));
CAPACITY(j)..   SUM((i),X(i,j)) =L= f(j)
CONTRACT(i)..      SUM ((j), X (i,j))) =G= b(i);

MODEL PRODUCTS /ALL/

SOLVE PRODUCTS USING LP MAXIMIZING VFO

