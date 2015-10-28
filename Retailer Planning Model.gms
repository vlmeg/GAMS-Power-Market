*Retailer Planning Model

set j scenarios/1,2,3,4,5/;
set head scenario details/sp,pl,prob/;
table l(j,head)


  sp     pl   prob
* $/MWh  MW
1 60.3   50   0.35
2 65.2   45   0.15
3 67.8   52   0.15
4 59.4   47   0.15
5 57.2   49   0.2 ;


*Formulation
*********
*Declaration Of Variables and Constrains
positive variable PF MW to buy from forward market ;
positive variable PS MW to buy from spot market:
free variable f objective function;
equations obj,constr1;

*objective function
obj..
f=e=sum(j,((l(j,'pl')*64*l(j,'prob')))-(ps(j)*l(j,'sp')*l(j,'prob')))-(pf*60);

*Constrain
constr1(j)..
ps(j)+pf=e=l(j,'pl');

Model formulation /all/;
*Solves the problem as an lp using xa
option lp=xa;
option solprint=off;
option optcr=0;
Solve formulation using lp maximizing f;
Display f.l,PF.l;