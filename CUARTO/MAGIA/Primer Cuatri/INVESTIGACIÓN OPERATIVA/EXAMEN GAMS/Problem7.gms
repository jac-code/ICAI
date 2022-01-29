OPTION OPTCR=0.0;
SETS
i available cities /A,B,C,D,E,F,G,H/
ALIAS(i,j)
PARAMETERS f(i) food obtained in city i
/A 15000,B 12000,C 9000,D 10000,E 13000,F 8000,G 11000,H 17000/
fc(i) fixed cost of using airport in city i
/A 2000,B 1500,C 1400,D 1600,E 2100,F 2000,G 1800,H 1000/
cp(i) cost of using a plane in city i
/A 18000,B 17500,C 17500,D 17000,E 16000,F 17000,G 16500,H 15000/
ckmkg additional cost per kg and km for ground transporting
/0.004/
cap maximum capacity of the planes
/20000/
maxp maximum number of planes we can use in every city
/3/
maxc maximum number of cities from where to ship the food in planes
/4/

TABLE d(i,j) distance between city i and city j expressed in km
    A   B   C   D   E   F   G   H
A     350 280 470 750 420 520 1050
B 350     320 240 400 480 510 680
C 280 320     420 650 170 260 820
D 470 240 420     270 550 300 450
E 750 400 650 270     800 530 540
F 420 480 170 550 800     340 940
G 520 510 260 300 530 340     600
H 1050 680 820 450 540 940 600

VARIABLES
VFO Value of the Objective Function expressed as the total cost in � of the operation
BINARY VARIABLE X
X(i) Variable that shows if we are using city i as a city where planes take off
INTEGER VARIABLE
N(i) Number of planes used in the city i
POSITIVE VARIABLE
C(i,j) Amount of food ground transported from city i to city j expressed in kg

EQUATIONS
FO Total cost of the operation expressed in �
PLANELIMITATION(i) Limitation on the number of planes that can take off from city i
CITYLIMITATION Indicates that you can not fly from more than a certain amount of cities
FLOWGROUND(i) Amount of food ground transported from city i expressed in kg
FOODLIMITATION(i) The amount of food ground transported form i to j can`t be bigger than
the total amount initially existing
CITYIMPLICATION(i) This implies that if a city airport is used at least one plane must take off
from that city
FLOWFOOD(i) Food is sent from the cities which the airport is being used
;
FO .. VFO =E= SUM[(i), N(i)*cp(i) + X(i)*fc(i)] + SUM[(i,j), ckmkg*d(i,j)*C(i,j)];
PLANELIMITATION(i) .. N(i) =L= maxp*X(i);
CITYLIMITATION .. SUM(i, X(i)) =L= maxc;
FLOWGROUND(i) .. SUM[(j), C(i,j)] =E= f(i)*[1-X(i)];
FOODLIMITATION(i) .. SUM[(j), C(i,j)] =L= f(i)*[1-X(i)];
CITYIMPLICATION(i) .. X(i) =L= N(i);
FLOWFOOD(i) .. N(i)*cap =G= f(i)*X(i) + SUM(j, C(j,i));

MODEL SECTIONA
/FO,FLOWGROUND,FOODLIMITATION,PLANELIMITATION,CITYLIMITATION,CITYIMPLICATION,FLOWFOOD/;
SOLVE SECTIONA USING LP MINIMIZING VFO