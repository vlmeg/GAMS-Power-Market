* Formulation of Transportation Problem
sets i supply points /1, 2/
sets j demand points /1, 2, 3/;
parameter s(i) supply at point i /1 350, 2 600 /;
parameter d(j) demand at point j /1 325, 2 300, 3 275/;
table dist(i,j) distance from i to j 123
        1     2     3
1       2.5   1.7   1.8
2       2.5   1.8   1.4;
scalar M cost of trasportation per mile /90/;

parameter c(i,j) cost of transportation from i to j;
c(i,j) = M * dist(i,j)/1000;

* *Formulation
*************
*Declaration of Variables and Constraints
free variable z cost of transportation;
positive variable x(i,j) amount transported from i to j;
equations obj, const1, const2;

obj..       z=e=sum((i,j),c(i,j)*x(i,j));

const1(i).. sum(j,x(i,j)) =e= s(i);

const2(j).. sum(i,x(i,j)) =e= d(j);

model formulation/all/;
* Solves the problem as an lp using xa

option lp=xa;
option solprint = off;
option optcr = 0;
solve formulation using lp minimizing z;
display x.l,z.l;
