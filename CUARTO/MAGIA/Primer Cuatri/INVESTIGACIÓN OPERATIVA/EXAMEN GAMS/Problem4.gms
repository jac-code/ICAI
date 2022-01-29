OPTION OPTCR=0

SETS
i Gender /M,F/
j Days /day1*day7/
k Bus Driver number /B1*B25/
n Shifts order /0,1,2/

SCALARS
fc Admin cost /20/
e Equality of work /1.1/
wc Weekend cost /15/
sc Strike Cost/1000/

PARAMETERS
d(j) Demand of bus drivers of day j
/day1 43
day2 42
day3 45
day4 40
day5 38
day6 35
day7 20/

TABLE c(i,j) Cost of Bus Driver of gender i in day j (Women cost 5% less than men)
  day1 day2 day3 day4 day5  day6 day7
M 55    45    40   48    53   60   65
F 52.25 42.75 38   45.6 50.35 57   61.75

VARIABLES
VFO1 Value of the OF1
VFO2 Value of the OF2

BINARY VARIABLES
X(i,j,k) Bus Driver k of gender i in day j availability
Y(i,j,k) Bus Driver k of gender i in day j hired
Z More than 16 women work more than 5 days

EQUATIONS
FO1 Minimizing the costs of the Bus Drivers
FO2 Minimizing the costs of the Bus Drivers (New constraint strike)
HIRE(i,j,k) If a driver is hired then the next two days is available
AVAI(i,j,k) If a driver is not hired in the two latter days then is
not available that day
EQUALITY(j) Equality j
DEMAND(j) Demand j
STRIKE Strike constraint;

FO1 .. VFO1 = SUM[(i,j,k), c(i,j)*X(i,j,k)]+SUM[(i,j,k),
fc*Y(i,j,k)]+SUM[(i,k), wc*(Y(i,"day5",k)+Y(i,"day6",k))];
EQUALITY(j)..SUM[k,X("F",j,k)] =L=SUM[k, X("M",j,k)]*e;
HIRE(i,j,k)..SUM[n,X(i,j++(ord(n)-1),k)]=G=3*Y(i,j,k);
AVAI(i,j,k)..X(i,j,k)=L=SUM[n, Y(i,j--(ord(n)-1),k)] ;
DEMAND(j).. SUM[(i,k), X(i,j,k)] =G= d(j);

FO2 .. VFO2 =E= SUM[(i,j,k), c(i,j)*X(i,j,k)]+SUM[(i,j,k),
fc*Y(i,j,k)]+SUM[(i,k), wc*(Y(i,"day5",k)+Y(i,"day6",k))]+sc*Z;
STRIKE..SUM[(j,k),Y("F",j,k)]=L=31+44*Z;

MODEL BusDrivers1 /FO1,HIRE,AVAI,EQUALITY,DEMAND/
MODEL BusDrivers2 /FO2,HIRE,AVAI,EQUALITY,DEMAND,STRIKE/
SOLVE BusDrivers2 using MIP minimizing VFO2
Display X.l,Y.l

