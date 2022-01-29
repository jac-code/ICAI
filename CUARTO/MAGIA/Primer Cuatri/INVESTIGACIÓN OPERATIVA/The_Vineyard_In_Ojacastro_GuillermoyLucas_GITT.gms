$title TheVineyardInOjacastro

option optcr = 0 ;

sets
i       'Portions' /X,Y,Z/
j       'Systems' /a,b,c,d,e,f/;

scalar  ta 'Total amortization (3000 €)' /6000/;

table   ip(i,j)  'Average increase in production in tonnes in portion i installing system j'

        a   b   c   d   e   f
X       30  40  25  28  35  26
Y       26  21  27  40  35  40
Z       25  18  20  25  30  25;

table   a(i,j)  'Anual amortization in € of water system j in portion i'

        a     b     c     d     e     f
X       3000  4000  2500  2300  3200  3300
Y       3200  2700  4000  5000  2000  4500
Z       2800  2000  2000  2800  3000  2200;

table   mc(i,j)  'Maintenance cost of system j in portion i'

        a     b     c     d     e     f
X       1000  1200  900   1100  1200  1300
Y       1200  800   1400  1500  1200  1500
Z       1200  700   800   1000  1100  900;


parameter
p   'Grapes price [€ per kg]' /0.85/;

parameter
M1 'upper bound' /2/;

parameter
m 'lower bound' /1/;

variables
OFV     'Objective function value. Global profit of the vineyard'
X(i,j)  'Indicator if system j is installed in the portion i'

binary variable X;

equations
EQ_OF           'objective function'
NSYS2           'Number of systems installed'
NSYS3   
AMOR            'Limitation of total amortization'
MCOST           'Total maintenance cost should be lower than one fifth of the total expected income.'
EQ_CON1(i,j)    'The portions where the system is installed should be contiguous (horizontal,vertical or diagonal)'
EQ_CON2(i,j)
EQ_YA           'If we select the portion (Y, a) then we need to select (X, a) and (X, b)'
EQ_ACOLUMN(i)   'If the selected portion is in the column “a” the rest of portions should be selected in the same row'
EQ_XROW(j)      'If there is a selected portion in the row X”, if there are any other portions selected, they should belong to the same column';

EQ_OF..         OFV =E= sum((i,j), X(i,j)*(ip(i,j)*1000*p - a(i,j) - mc(i,j)));

NSYS2..         2 =L= sum[(i,j), X(i,j)];

NSYS3..         3 =G= sum[(i,j), X(i,j)];

AMOR..          sum[(i,j), X(i,j)*a(i,j)] =L= ta;

MCOST..         sum[(i,j), X(i,j)*mc(i,j)] =L= 1/5*OFV;

EQ_CON1(i,j)..  M1+(1-X(i,j)) =G= X(i+1,j) + X(i-1, j)+ X(i, j+1)+ X(i, j-1)+ X(i+1, j+1)+ X(i+1, j-1)+ X(i-1, j+1)+ X(i-1, j-1);

EQ_CON2(i,j)..  m*X(i,j) =L= X(i+1,j) + X(i-1, j)+ X(i, j+1)+ X(i, j-1)+ X(i+1, j+1)+ X(i+1, j-1)+ X(i-1, j+1)+ X(i-1, j-1);

EQ_YA..         X("X","a") + X("X","b") =G= 2*X("Y","a");

EQ_ACOLUMN(i).. m*X(i,"a") =L= sum(j,X(i,j+1));

EQ_XROW(j)..    m*X("X",j) =L= sum(i,X(i+1,j));

model vineyard /ALL/;

solve vineyard using mip maximizing OFV;

display X.L, OFV.L;
 
