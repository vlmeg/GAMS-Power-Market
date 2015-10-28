*Formulation of Nordic Market Simulation B

set j Technology Types /Nuclear, Hydro, Coal, Wind, Gas, Oil/
set i Areas / SE1, SE2, SE3, SE4, NO1, NO2, NO3, NO4, NO5, FI, DK1, DK2/ ;
Alias(i,k);
set m /ntmax/;

table g(i,j) MAX vailable capacity of technology i at point j

    Nuclear     Hydro   Coal   Wind   Gas   Oil
SE1 0           11400   0      0      0     0
SE2 0           4800    0      0      0     0
SE3 6570        0       0      0      0     0
SE4 0           0       130    4280   1070  3800
NO1 0           6200    0      0      0     0
NO2 0           5930    0      0      0     0
NO3 0           5544    0      0      656   0
NO4 0           5500    0      0      0     0
NO5 0           5800    0      1000   0     0
FI  2696        3124    4804   2500   2645  1368
DK1 0           0       3850   2673   2772  462
DK2 0           0       1150   1027   828   138 ;

parameter l(i) load at point i
/SE1 1441, SE2 3690, SE3 10053, SE4 10407, NO1 7041, NO2 5754, NO3 2715,
NO4 2471, NO5 3870, FI 13522, DK1 4502, DK2 1786/;

table c(i,j) generator cost at each area
     Nuclear   Hydro   Coal   Wind   Gas   Oil
SE1  13        8.25    16     10     90    50
SE2  13.25     8.5     16.75  10.25  90    50
SE3  13.5      8.75    17.5   10.5   90    50
SE4  13.75     9       18.25  10.75  90    50
NO1  14        7       19     11     90    50
NO2  14.25     7.25    19.75  11.25  90    50
NO3  14.5      7.5     20.5   11.5   90    50
NO4  14.75     7.75    21.25  11.75  90    50
NO5  15        8       22     12     90    50
FI   15.25     9.25    22.75  12.25  90    50
DK2  15.5      9.5     23.5   12.5   90    50
DK1  15.75     9.75    24.25  12.75  90    50 ;

table n(i,k,m) net transfer capacity
        ntmax
SE1.SE2 2600
SE2.SE1 3300
SE2.SE3 5900
SE3.SE2 7300
SE3.SE4 3920
SE4.SE3 2000
NO1.NO2 1700
NO2.NO1 2600
NO1.NO3 250
NO3.NO1 250
NO1.NO5 600
NO5.NO1 700
NO2.NO5 250
NO5.NO2 250
SE2.NO3 1000
NO3.SE2 600
NO4.NO3 900
SE2.NO4 250
NO4.SE2 100
SE1.NO4 450
NO4.SE1 700
SE3.NO1 2095
NO1.SE3 1245
SE1.FI  1500
FI .SE1 1100
SE3.FI  500
FI .SE3 500
NO2.DK1 950
DK1.NO2 1000
SE3.DK1 680
DK1.SE3 740
DK1.DK2 590
DK2.DK1 600
SE4.DK2 1300
DK2.SE4 1700



*Formulation
***********
*Declaration of variables and constrains

free variable z cost of generating electricity;
positive variable x(i,j) MW of electricity generated;
variable y(i,k) MW imported-exported;
x.up(i,j)=g(i,j);
y.up(i,k)=n(i,k,'ntmax');
equations obj,const1,const2;

*objective function
obj..
z=e=sum((i,j),x(i,j)*c(i,j));

*Supply =demand constrain
const1(i)..
sum(j,x(i,j))-sum(k,y(i,k))=e= l(i);

*Const2
const2(i,k)..
y(i,k)=e=-y(k,i);


model formulation /all/;
*Solves the problem as an lp using xa
option lp=xa;
option solprint=off;
option optcr=0;
Solve formulation using lp minimizing z;
display x.l,z.l,y.l;