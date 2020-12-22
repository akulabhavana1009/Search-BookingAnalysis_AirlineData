import search csv data
ssc install nsplit
nsplit date, digits(4 2 2 2 2) gen(year month day hour minute)
save the new data
import booking data
ssc install nsplit
nsplit date, digits(4 2 2 2 2) gen(year month day hour minute)
save the new data
import search_datesplit //data
//check what are the common parameters in both search and booking data and add only those parameters in the command below
duplicates tag year month day hour minute devicecategory country regions usertype fakeairline channelgrouping system newroutetype, generate (dups1) //this creates a unique variable named  'dups1'
import booking_datasplit //data
duplicates tag year month day hour minute devicecategory country regions usertype fakeairline channelgrouping system newroutetype, generate (dups1) //this creates a unique variable named  'dups1'
//tabto see the result; the percentages should be atleast more than 96%
 merge 1:1 year month day hour minute devicecategory country regions usertype fakeairline channelgrouping system newroutetype, using "C:\Users\vivek2vhs\Desktop\data driven Business Insights\book_dupst1.dta" //merging search and bookings datasets
//to know the mode
egen x=mode(_merge)
disp x
*analyze the distribution of merge
 tab _merge

     _merge |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |  1,040,080       97.14       97.14
          2 |     30,554        2.85       99.99
          3 |        120        0.01      100.00
------------+-----------------------------------
      Total |  1,070,754      100.00

* when _merge=1 means just search ,merge_2 means just booking ,_merge=3 means search and booking

*create variable uncomplishedbooking, if uncomplishedbooking=1 means just search. if uncomplishedbooking=0 means booking
 gen uncomplishedbooking=1 if _merge==1
 replace uncomplishedbooking=0 if _merge>1

* want to know  people have more booking in which season
gen season="spring" if month>=3 & month<=5
replace season="summer" if month>=6 & month<=8
replace season="autumn" if month>=9 & month<=11
replace season="winter"  if month==1| month==2|month==12
graph pie if uncomplishedbooking ==0, over(season) sort plabel(_all percent)
 

*want to know which season's revenue is high.
graph bar (mean) revenuesum if uncomplishedbooking ==0, over(season)
 
* want to know when searching which device is popular

 tab devicecategory if _merge==1| _merge==3

deviceCateg |
        ory |      Freq.     Percent        Cum.
------------+-----------------------------------
    desktop |    844,113       81.15       81.15
     mobile |     60,889        5.85       87.00
     tablet |    135,198       13.00      100.00
------------+-----------------------------------
      Total |  1,040,200      100.00

*want to know when book which device is popular
tab devicecategory if _merge==2| _merge==3

deviceCateg |
        ory |      Freq.     Percent        Cum.
------------+-----------------------------------
    desktop |     27,547       89.81       89.81
     mobile |        726        2.37       92.17
     tablet |      2,401        7.83      100.00
------------+-----------------------------------
      Total |     30,674      100.00

*want to know which airline is popular when booking 
graph pie if uncomplishedbooking ==0, over(fakeairline) sort plabel(_all percent)
//To know which airline goes from A-B,B-A,C-D,etc
sort fakeairline
tab fakeroute fakeairline

 

