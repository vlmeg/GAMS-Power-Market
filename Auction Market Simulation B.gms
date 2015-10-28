*Auction Market Simulation  B

set i generator companies /1,2,3,4,5/ ;
set head1 /ST , BPS , Pmax, Pmin, RUP,RDN/;
set j customers /1,2,3,4,5,6,7/ ;
set head2 /BPD,Pmax/ ;
set k number of hours /1,2/;

Table gen(i,head1)

  ST   BPS   Pmax Pmin RUP  RDN
* $/hr $/MWh MW   MW
1 1000 20.50 750  150  1.25 .57
2 1500 21.50 600  100  1.35 .65
3 750  25.55 200  50   1.45 .55
4 500  22    400  100  1.25 .75
5 100  27.50 150  40   1.55 .45;

Table sup(j,head2)

   BPD  Pmax
* $/MWh MW
1 32.35 250
2 30.59 350
3 28.25 500
4 27.75 100
5 23.50 200
6 22.60 350
7 20.30 450;

parameter LSF(k) at hour k
/1 0.67,2 1/;

*Formulation
***********
*Declaration of variables and constrains variable
positive variable PD(j,k) MWh of power demanded ;
positive variable PG(i,k) MWh of power supplied ;
free variable F total costs ;
binary variable UST(i,k) startup;
binary variable W1(i,k) generator's offer;
binary variable W2(j,k) demands's bid;
equations obj,constr1,constr2,constr3,constr4,constr4,constr5,constr6;

*Objective Function
obj..
F=e=sum((j,k),((sup(j,'BPD')*PD(j,k))))-sum((i,k),gen(i,'BPS')*(PG(i,k)
+W1(i,k)*gen(i,'Pmin'))+gen(i,'ST')*UST(i,k));

*Supply= demand constraint
constr1(k)..
sum(i,W1(i,k)*gen(i,'Pmin')+PG(i,k))=e= sum(j,PD(j,k));

*Constrains on Generation AND load
constr2(i,k)..
PG(i,k)=l=W1(i,k)*gen(i,'Pmax')-W1(i,k)*gen(i,'Pmin');
constr3(j,k)..
PD(j,k)=l=W2(j,k)*sup(j,'Pmax')*LSF(k);

*Ramp Rate Constrains
constr4(i,k)$(ord(k) gt 1)..
gen(i,'Pmin')+PG(i,k)=l=gen(i,'RUP')*(gen(i,'Pmin')+PG(i,k-1));
Constr5(i,k)$(ord(k) gt 1)..
gen(i,'Pmin')+PG(i,k)=g=gen(i,'RDN')*(gen(i,'Pmin')+PG(i,k-1));

*Start Up Constrain
constr6(i,k)..
UST(i,k)=g= W1(i,k)-W1(i,k-1);

model formulation /all/;
*Solves the problem as an lp using xa option lp=xa;
option solprint=off;
option optcr=0;
Solve formulation using mip maximizing F;
parameter Pactual(i,k);
Pactual(i,k)= W1.l(i,k)*gen(i,'Pmin')+PG.l(i,k);
Display F.l,Pactual, PG.l,PD.l;