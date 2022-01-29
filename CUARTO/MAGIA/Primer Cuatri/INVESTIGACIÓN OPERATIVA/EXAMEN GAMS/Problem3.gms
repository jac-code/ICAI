
SETS
i rows of the neighborhood structure / 1, 2, 3, 4, 5, 6, 7 /
j columns of the neighborhood structure / 1, 2, 3, 4, 5 /
k type of house / LC, MC /
alias(i2,i)
alias(j2,j)

SCALARS
acre number of acres in the neighborhood /35/
dem total demand of houses in the neighborhood /550/
M section A: value of the upper limit LC per grid (logical implication) /10/
e auxiliary parameter of the logical implication /0.1/
z section A: value of the lower limit (logical implication)/0.1/
W section B: value of the upper limit of MC per neighborhood(logical implication) /250/

PARAMETERS
c(k) cost per house of type k / LC 21000, MC 25000 /
max(k) maximum number of houses of type k / LC 10, MC 15 /
minn(k) minimum number of houses per neigh.of type k /LC 200, MC 100 /
maxn(k) maximum number of houses per neigh.of type k /LC 350, MC 450 /

VARIABLES
VFOA objective function A
VFOB objective function B
X(i,j,k) number of houses per cell i j of type k
D(i,j) A: logical implication
T B: government tax reduction
R auxiliary number of MC houses
Q auxiliary number of MC houses

INTEGER VARIABLE X
BINARY VARIABLE D,T
POSITIVE VARIABLE R,Q

EQUATIONS
OFA objective function(A): minimum total cost of houses
OFB objective function(B):A plus a gov tax reduction
MAXACRE(i,j,k) maximum number of houses in grid i j of type k
DEMAND total demand of houses expected
MINNEIGH(k) minimum number of houses of type k per neighbourhood
MAXNEIGH(k) maximum number of houses of type k per neighbourhood
COUNCOND LC 50 units higher than the half number of MC houses
ADJACRE1 more than 7 LC houses implies D=1
ADJACRE2 if D=1 then min 5 LC houses in the adjacent cells
GOVTAX MC houses exceeding 250 implies half of the MC cost
POSIT number of houses that must be positive
AUX1 auxiliary 1
AUX2 auxiliary 2

OFA .. VFOA =E= SUM[(i,j,k), X(i,j,k)*c(k)];
OFB .. VFOB =E= SUM((i,j),X(i,j,'LC')*c('LC'))+(R+Q)*c('MC');
MAXACRE(i,j,k) .. X(i,j,k)=L=max(k);
DEMAND .. SUM[(i,j,k), X(i,j)]=G=dem;
MINNEIGH(k) .. SUM[(i,j), X(i,j,k)]=G=minn(k);
MAXNEIGH(k) .. SUM[(i,j), X(i,j,k)]=L=maxn(k);
COUNCOND .. SUM[(i,j),X(i,j,'LC')]=G=50+0.5*SUM[(i,j),X(i,j,'MC')];
ADJACRE1(i,j) .. X(i,j,'LC')=L=7+3*D(i,j);
ADJACRE2(i,j,i2,j2)$(ORD(i2)<=ORD(i)+1 AND ORD(i2)>=ORD(i)-1 AND
ORD(j2)<=ORD(j)+1 AND ORD(j2)>=ORD(j)-1) .. X(i2,j2,'LC')=G=5*D(i,j);
GOVTAX .. SUM[(i,j),X(i,j,MC)]=G=250-(1-T)*W;
POSIT(i,j,k) .. X(i,j,k)=G=0;
AUX1 .. R=G=SUM ((i,j), X(i,j,'MC'))-W*T;
AUX2 .. Q=G=SUM ((i,j), X(i,j,'MC')*0.5)-W*(1-T);

MODEL URBANPLANA /OFA, MAXACRE, DEMAND, MINNEIGH, MAXNEIGH, COUNCOND,
ADJACRE1, ADJACRE2, POSIT/
MODEL URBANPLANB /OFB, MAXACRE, DEMAND, MINNEIGH, MAXNEIGH, COUNCOND,
ADJACRE1, ADJACRE2, GOVTAX, POSIT, AUX1, AUX2/
OPTION OPTCR = 0.0;

SOLVE URBANPLANA MINIMIZING VFOA USING MIP;
*SOLVE URBANPLANB MINIMIZING VFOB USING MIP;