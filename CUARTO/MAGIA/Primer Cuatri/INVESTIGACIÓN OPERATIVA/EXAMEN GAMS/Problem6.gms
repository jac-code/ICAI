sets i fuel / BA, BD, NG /
j plant /1, 2, 3, 4/
h hours /1*24/

scalars n max level of contamination for the region g per m3 / 13000 /
d1 need of the region in peak hour MWh /4500/
d2 need of the region in others hour MWh /3750/
M big M /1000000/

parameters c(i) cost to consume 1 t of fuel i / BA 8500, BD 4000, NG 3500 /
d(j) consumtion for plant j for one day /1 8, 2 4, 3 25, 4 1 /
g(i) amount of fuel i available t per day / BA 500, BD 200, NG 1000 /
p(h) Indicator whether we are in peak hour or not /1 0,2 0,3 0,4 0,5 0,6 0,7 0,8 0,9 0,10 0,11 0,12 0,13 0,14 0,15 0,16 0,17 0,18 0,19 0,20 1,21 1,22 1,23 1,24 1/;

table e(i,j) Quantity of co2 created when 1 t of fuel i is consummed in plant j
    1  2  3   4
BA 65 140 185 265
BD 10 75  120 200
NG 75 71  45 125;
table o(i,j) energy produced by plant j when burning fuel i
1 2 3 4 BA 250 140 185 265 BD 350 75 120 300 NG 150 71 45 325;

variables X(i,j,h) Amount of fuel i consumed in plant j in hour h
Y(j,h) Plant j on at hour h K Cost

POSITIVE variables X(i,j,h);
BINARY variables Y(j,h);

equations CONTA Air pollution limit
MAXTON(i) Maximum quantity of fuel i available
NEED(h) Energy demand in hour h
LINK1(j,h) Relation 1 between X and Y
LINK2(j,h) Relation 2 between X and Y
FO Total cost of creating energy for one day ;

CONTA .. SUM[(i,j,h),X(i,j,h)*e(i,j)]=L=n ;
MAXTON(i) .. SUM[(j,h),X(i,j,h)]=L=g(i) ;
NEED(h) . SUM[(i,j),X(i,j,h)*o(i,j)-Y(j,h)*d(j)]=G=d2+p(h)*(d1-d2);
LINK1(j,h) .. M*SUM[i,X(i,j,h)]=G=Y(j,h);
LINK2(j,h) .. SUM[i,X(i,j,h)]=L=M*Y(j,h);
FO .. K =E= SUM[(i,j,h),X(i,j,h)*c(i)];

model cost /all/;
OPTION OPTCR=0.0;
solve cost using MIP minimizing K