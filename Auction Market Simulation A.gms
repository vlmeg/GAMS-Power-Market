*Auction Market Simulation

set i generator companies /1,2,3,4,5/ ;
set head1 /ST , BPS , Pmax, Pmin, RUP,RDN/;
set j customers /1,2,3,4,5,6,7/ ;
set head2 /BPD,Pmax/ ;

Table gen(i,head1)
  ST    BPS     Pmax   Pmin  RUP  RDN
* $/hr  $/MWh   MW     MW
1 1000  20.50   750    150   125  57
2 1500  21.50   600    100   135  65
3 750   25.55   200    50    145  55
4 500   22      400    100   125  75
5 100   27.50   150    40    155  45;


Table sup(j,head2)
    BPD  Pmax
*  $/MWh MW
1  32.35 250
2  30.59 350
3  28.25 500
4  27.75 100
5  23.50 200
6  22.60 350
7  20.30 450;


*Formulation
***********
*Declaration of variables and constrains variable
positive variable PD(j) MWh of power demanded ;
positive variable PG(i) MWh of power supplied ;
free variable F social walfare ;
binary variable UST(i) startup;
binary variable W1(i) generator's offer;
binary variable W2(j) demands's bid;
equations obj,constr1,constr2,constr3,constr4;

*Objective Function Constrain
obj.. F=e=sum((j),sup(j,'BPD')*PD(j))-sum((i),gen(i,'BPS')*(PG(i)+(W1(i)*gen(i,'Pmin')))
+gen(i,'ST')*UST(i));

*Supply=demand constraint
constr1..
sum((i),W1(i)*gen(i,'Pmin')+PG(i))=e=Sum((j),PD(j));


*Constrains on Generation and load
constr2(i)..
PG(i)=l=W1(i)*gen(i,'Pmax')-W1(i)*gen(i,'Pmin');

constr3(j)..
PD(j)=l=W2(j)*sup(j,'Pmax');

*Start up Constrain
constr4(i)..
UST(i)=e= W1(i);

model formulation /all/;
*Solves the problem as an lp using xa option lp=xa;
option solprint=off;
option optcr=0;
Solve formulation using mip maximizing F;
parameter Pactual(i);
Pactual(i)= W1.l(i)*gen(i,'Pmin')+PG.l(i);
display F.l,Pactual, PG.l,PD.l;
