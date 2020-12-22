*clean the dataset : (1)create the paid dummy variable
gen paid =1 if channelgrouping== "Branded Paid Search"
replace paid =1 if channelgrouping== "Paid Search"
replace paid =1 if channelgrouping== "Generic Paid Search"
replace paid =0 if channelgrouping== "(Other)"
replace paid =0 if channelgrouping== "Direct"
replace paid =0 if channelgrouping== "Display"
replace paid =0 if channelgrouping== "Email"
replace paid =0 if channelgrouping== "Organic Search"
replace paid =0 if channelgrouping== "Referral"
replace paid =0 if channelgrouping== "Socail"

*(2)rename the wrong country name
*(3)create the local time 
gen hournew= hour+4 if fakeairline=="Airline 1"
replace hournew= hour+9 if fakeairline=="Airline 2"
replace hournew= hour+7 if fakeairline=="Airline 3"
replace hournew= hour+1 if fakeairline=="Airline 4"
replace hournew= hour+5 if fakeairline=="Airline 5"
replace hournew= hour+1 if fakeairline=="Airline 6"


gen minnew= minutes +30 if fakeairline=="Airline 5"
replace minnew= minutes if fakeairline=="Airline 1"
replace minnew= minutes if fakeairline=="Airline 2"
replace minnew= minutes if fakeairline=="Airline 3"
replace minnew= minutes if fakeairline=="Airline 4"
replace minnew= minutes if fakeairline=="Airline 6"

replace hournew= hournew +1 if minnew>=60 & minnew<120
replace minnew = minnew-60 if minnew>=60 & minnew<120


gen newday= day if hournew <24
replace newday= day+1 if hournew >=24& hournew<=48
replace hournew = hournew -24 if hournew >=24

gen newmonth = month+1 if newday>28 & month==2
replace newmonth = month+1 if newday>31 & month==1
replace newmonth = month+1 if newday>31 & month==3
replace newmonth = month+1 if newday>31 & month==5
replace newmonth = month+1 if newday>31 & month==7
replace newmonth = month+1 if newday>31 & month==8
replace newmonth = month+1 if newday>31 & month==10
replace newmonth = month+1 if newday>31 & month==12
replace newmonth = month+1 if newday>30 & month==4
replace newmonth = month+1 if newday>30 & month==6
replace newmonth = month+1 if newday>30 & month==9
replace newmonth = month+1 if newday>30 & month==11
replace newmonth = month if newday<=28 & month==2
replace newmonth = month if newday<=31 & month==1
replace newmonth = month if newday<=31 & month==3
replace newmonth = month if newday<=31 & month==5
replace newmonth = month if newday<=31 & month==7
replace newmonth = month if newday<=31 & month==8
replace newmonth = month if newday<=31 & month==10
replace newmonth = month if newday<=31 & month==12
replace newmonth = month if newday<=30 & month==4
replace newmonth = month if newday<=30 & month==6
replace newmonth = month if newday<=30 & month==9
replace newmonth = month if newday<=30 & month==11
replace newday = newday -30 if newday>30 & month==4
replace newday = newday -30 if newday>30 & month==6
replace newday = newday -30 if newday>30 & month==9
replace newday = newday -30 if newday>30 & month==11
replace newday= newday-31 if newday>31 & month==1
replace newday= newday-31 if newday>31 & month==3
replace newday= newday-31 if newday>31 & month==5
replace newday= newday-31 if newday>31 & month==6
replace newday= newday-31 if newday>31 & month==7
replace newday= newday-31 if newday>31 & month==8
replace newday= newday-31 if newday>31 & month==10
replace newday= newday-31 if newday>31 & month==12
replace newday = newday-1 if newday>28 & month==2

*(4)create the week
tostring newday, generate(localday)
tostring newmonth , generate(localmonth)
tostring year , generate(yearstring)
gen datestring= yearstring+"-"+ localmonth+ "-"+ localday
gen week=dow(date( datestring ,"YMD"))
label values week daylab
label def daylab 0 "Sunday" 1 "Monday" 2 "Tuesday" 3 "Wednesday" 4 "Thursday" 5 "Friday" 6 "Staturday", replace

*(5)create the weekday dummy variable to seperate the businessman and leisurer in the future
gen weekday=1 if week==1 | week==2 | week==3 | week==4 | week==5
replace weekday=0 if week==6 | week==0


*(6)drop the obersevations if the frequence of country <=10
 keep if freq_country>10
(238 observations deleted)

   *firstly contract the country  and merge with original dataset
    contract country
	save 
*£¨7£© drop the oberservations if the revenue =0
 keep if revenuesum!=0
(37 observations deleted)
*(8) create the diatance variable to find if the long route will have the high price(price= revenue per person£©
 gen distance=0 if fakeroute=="AAA-BBB" | fakeroute=="BBB-AAA"
(303350 real changes made)

replace distance=1 if fakeroute=="CCC-DDD" | fakeroute=="DDD-CCC"
(104046 real changes made)

replace distance=2 if fakeroute=="EEE-FFF" | fakeroute=="FFF-EEE"
(663297 real changes made)
*(9) creat the price using revenue/ passengernum/ returntime(but his part we have the problem is that some newrouttypes are empty can we drop them )

gen is_return=2 if newroutetype=="RT"
(305572 missing values generated)
replace is_return=1 if newroutetype=="OW" | newroutetype=="CP"
(87546 real changes made)
gen price_perpassenger= revenuesum/ passengerssum
(1039973 missing values generated)
gen price= price_perpassenger/ is_return
(1048349 missing values generated)
*(10)create the time of day (morning, afternoon , evening ,night)

 gen  timeofday ="morning" if hournew>=6 & hournew<12
(0 real changes made)
 replace  timeofday ="afternnon" if hournew>=12 & hournew<18
(64503 real changes made)

 replace  timeofday ="evening" if hournew>=18 & hournew<24
(326355 real changes made)
 replace  timeofday ="night" if hournew>=24 | hournew <6
(95532 real changes made)
*(11) create the real season ( spring ,summer, autunm, winter)
gen realseason= "spring"  if newmonth>=3 & newmonth <=5
(759082 missing values generated)

. replace realseason="summer" if newmonth>=4 & newmonth <=8
(488846 real changes made)

. replace realseason="atumun" if newmonth>=9 & newmonth <=11
(201445 real changes made)

. replace realseason="winter" if newmonth>=12 | newmonth <3
(264489 real changes made)


 
* find if distance influence the price so using the regression
 reg price distance

      Source |       SS       df       MS              Number of obs =   22344
-------------+------------------------------           F(  1, 22342) =16085.99
       Model |   456806232     1   456806232           Prob > F      =  0.0000
    Residual |   634462914 22342  28397.7672           R-squared     =  0.4186
-------------+------------------------------           Adj R-squared =  0.4186
       Total |  1.0913e+09 22343  48841.6572           Root MSE      =  168.52

------------------------------------------------------------------------------
       price |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
    distance |   196.2583   1.547406   126.83   0.000     193.2253    199.2914
       _cons |   108.5875   1.583313    68.58   0.000     105.4841    111.6909
------------------------------------------------------------------------------




* we check the number of booking and the number of searching by route to find which route has the more convertionrate 
 *and we can deeply expolre in  these route in the future .
tab fakeroute dataset

           |        dataset
FAKE ROUTE |   booking     search |     Total
-----------+----------------------+----------
   AAA-BBB |    14,449    242,981 |   257,430 
   BBB-AAA |     3,116     42,804 |    45,920 
   CCC-DDD |     4,263     56,130 |    60,393 
   DDD-CCC |     4,450     39,203 |    43,653 
   EEE-FFF |     2,682    320,398 |   323,080 
   FFF-EEE |     1,760    338,457 |   340,217 
-----------+----------------------+----------
     Total |    30,720  1,039,973 | 1,070,693 




* check the number of booking and the number of searching by country find which route has the more convertionrate 
 *and we can deeply expolre in  these country in the future .

. tab country dataset

                      |        dataset
              country |   booking     search |     Total
----------------------+----------------------+----------
            (not set) |        18        995 |     1,013 
              Algeria |         1         58 |        59 
              Andorra |         1         46 |        47 
               Angola |         2         32 |        34 
            Argentina |         8        104 |       112 
            Australia |       326      3,632 |     3,958 
              Austria |        62        971 |     1,033 
              Bahrain |        13        187 |       200 
           Bangladesh |         5        194 |       199 
              Belarus |         0         26 |        26 
              Belgium |       182     10,959 |    11,141 
              Bermuda |         2         12 |        14 
               Bhutan |         6         72 |        78 
              Bolivia |         0         15 |        15 
               Brazil |        18        271 |       289 
               Brunei |         2         30 |        32 
             Bulgaria |         3        167 |       170 
         Burkina Faso |         1         11 |        12 
             Cambodia |        36        369 |       405 
             Cameroon |         1        167 |       168 
               Canada |       142      2,994 |     3,136 
                 Chad |         2         28 |        30 
                Chile |         8         95 |       103 
                China |       189        994 |     1,183 
             Colombia |         1         31 |        32 
              Comoros |         0        121 |       121 
  Congo - Brazzaville |         0         20 |        20 
     Congo - Kinshasa |         0         26 |        26 
           Costa Rica |         4         30 |        34 
          Cote Ivoire |         1         71 |        72 
              Croatia |         2         49 |        51 
               Cyprus |         2         41 |        43 
              Czechia |        40      1,356 |     1,396 
              Denmark |        27        355 |       382 
             Djibouti |         0         31 |        31 
   Dominican Republic |         1         36 |        37 
              Ecuador |         0         12 |        12 
                Egypt |         8         73 |        81 
              Estonia |         8        161 |       169 
             Ethiopia |         0         12 |        12 
              Finland |        29        355 |       384 
               France |     5,043    349,946 |   354,989 
        French Guiana |         7        725 |       732 
     French Polynesia |         8        413 |       421 
                Gabon |         4         74 |        78 
              Georgia |         1         18 |        19 
              Germany |       418      9,318 |     9,736 
                Ghana |         2          9 |        11 
               Greece |        10        165 |       175 
           Guadeloupe |        20      1,544 |     1,564 
                 Guam |         0         11 |        11 
             Guernsey |         1         12 |        13 
                Haiti |         0         11 |        11 
            Hong Kong |       122        829 |       951 
              Hungary |        23        299 |       322 
              Iceland |         1         45 |        46 
                India |       180      1,740 |     1,920 
            Indonesia |        48        396 |       444 
                 Iraq |         1         44 |        45 
              Ireland |        53        574 |       627 
               Israel |        87        543 |       630 
                Italy |        76      1,782 |     1,858 
              Jamaica |         2         12 |        14 
                Japan |       289      2,716 |     3,005 
               Jersey |         4         32 |        36 
               Jordan |         3         41 |        44 
           Kazakhstan |         8         78 |        86 
                Kenya |         5         65 |        70 
               Kuwait |        16        205 |       221 
                 Laos |        29        246 |       275 
               Latvia |         1         77 |        78 
              Lebanon |         5        157 |       162 
        Liechtenstein |         2         35 |        37 
            Lithuania |         1         99 |       100 
           Luxembourg |        19      1,226 |     1,245 
                Macau |         3         45 |        48 
    Macedonia (FYROM) |         0         91 |        91 
           Madagascar |        20      1,925 |     1,945 
             Malaysia |        60        540 |       600 
             Maldives |        63        885 |       948 
                 Mali |         0         29 |        29 
                Malta |         6        119 |       125 
           Martinique |        33      1,721 |     1,754 
            Mauritius |     1,686     26,448 |    28,134 
              Mayotte |       118      9,036 |     9,154 
               Mexico |        15        137 |       152 
              Moldova |         0         12 |        12 
               Monaco |         3        119 |       122 
             Mongolia |         2         11 |        13 
              Morocco |        10        415 |       425 
           Mozambique |         1         24 |        25 
      Myanmar (Burma) |        96        767 |       863 
              Namibia |         0         16 |        16 
                Nepal |        12         91 |       103 
          Netherlands |       134      1,775 |     1,909 
        New Caledonia |        10        451 |       461 
          New Zealand |        33        519 |       552 
            Nicaragua |         2         22 |        24 
              Nigeria |         2         45 |        47 
               Norway |        38        437 |       475 
                 Oman |        16        224 |       240 
             Pakistan |        11        299 |       310 
               Panama |         0         17 |        17 
     Papua New Guinea |         3         19 |        22 
                 Peru |         1         17 |        18 
          Philippines |        50        408 |       458 
               Poland |        19        746 |       765 
             Portugal |        15        478 |       493 
                Qatar |        91      1,052 |     1,143 
              Reunion |    13,700    498,806 |   512,506 
              Romania |        14        446 |       460 
               Russia |        37        593 |       630 
         Saudi Arabia |        42        576 |       618 
              Senegal |         4         78 |        82 
               Serbia |         0         55 |        55 
           Seychelles |         5        217 |       222 
            Singapore |       141      1,191 |     1,332 
         Sint Maarten |         0         18 |        18 
             Slovakia |         5        193 |       198 
             Slovenia |         4         83 |        87 
              Somalia |         2          9 |        11 
         South Africa |        67      1,195 |     1,262 
          South Korea |        37        415 |       452 
                Spain |       125      2,552 |     2,677 
            Sri Lanka |     2,107     40,753 |    42,860 
      St. BarthÂ‚lemy |         0         75 |        75 
           St. Martin |         0         57 |        57 
St. Pierre & Miquelon |         0         28 |        28 
               Sweden |        54        733 |       787 
          Switzerland |       239      4,943 |     5,182 
               Taiwan |        62        638 |       700 
             Tanzania |         5         47 |        52 
             Thailand |     2,647     23,345 |    25,992 
              Tunisia |         0         64 |        64 
               Turkey |        22        225 |       247 
               Uganda |         1         17 |        18 
              Ukraine |        14        408 |       422 
 United Arab Emirates |       126      1,668 |     1,794 
       United Kingdom |       513      7,212 |     7,725 
        United States |       471      4,961 |     5,432 
              Uruguay |         1         16 |        17 
           Uzbekistan |         5         13 |        18 
              Vietnam |        73        675 |       748 
               Zambia |         2         13 |        15 
             Zimbabwe |         2         19 |        21 
----------------------+----------------------+----------
                Total |    30,720  1,039,973 | 1,070,693 
