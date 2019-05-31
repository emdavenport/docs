
***************************************************************************
* Section 0: Preamble
***************************************************************************

* This do-file is used in Session 2. Author: Edward Davenport.

version 13
set more off
clear all

cd "/Users/Davenpoe/Dropbox (Marshall Research)/B&E/ED Miscellany/Zambia 2019/Stata Training/Datasets/Session 2"

***************************************************************************
* Section 1: Warming up - calculating some summary information
***************************************************************************

use "SessionTwoDataset", clear

* First, let's recap some of the things we covered last time


/* Your turn:
How many pupils are female? What proportion of the dataset is this?
What is the mean maths score for girls? For boys?
*/





/*
Create a dummy that is equal to 1 when a pupil scores above 80 in all three subjects.
How many pupils managed to achieve this?
Is the likelihood of achieving this different by gender?
Does this seem more likely to happen at some types of schools than others?
*/





/* 
Create a variable equal to the average score of maths and science
Summarize this variable to find the quartiles. Hint: you should use the "detail" option.
Create a categorical variable that is equal to:
	1 for students scoring below the 25th percentile
	2 for students scoring between the 25th and 50th percentile
	3 for students scoring between the 50th and 75th percentile
	4 for students scoring above the 75th percentile

Label the values of this variable to be something sensible.
Tabulate the variable to see what the distribution looks like.
Which group is the most frequent?
*/





* briefly introducing tabstat, a flexible command to produce tables of summary statistics
* tabstat can do lots of things -- the main objective here is for you to know that it exists
* so if want to produce a table like this in the future: take a look at help tabstat

tabstat mathsScore englishScore scienceScore, stat(mean sd min p25 p50 p75 max count) col(stat)

tabstat mathsScore, by(province) stat(mean sd min p25 p50 p75 max count)



* Introducing collapse, a command to "collapse" the data to a higher level
* We will use it here to make a table that shows the average scores in each province

collapse ///
		(count) person ///
		(mean) mathsScore ///
		(mean) englishScore ///
		(mean) scienceScore, ///
		by(province)

export excel "ProvincialSummaryTable", firstrow(var) replace

* Collapse gave us a nice table, but it destroyed our dataset!

* Have to re-open the dataset...
use "SessionTwoDataset", clear

/*
For our purposes, re-opening the dataset isn't really harmful. 
But for large datasets this can take several minutes (so better to avoid re-opening unless we have to)
Also, if we had done any cleaning work (e.g., labelling, making new variables), we would have lost it
*/

* preserve and restore are designed to work with temporary changes to the dataset
* You will need to execute all of this code (from preserve to restore) in one go		
		
preserve

collapse ///
		(count) person ///
		(mean) mathsScore ///
		(mean) englishScore ///
		(mean) scienceScore, ///
		by(province)

export excel "ProvincialSummaryTable", firstrow(var) replace
	
restore

* We got the same table in excel, but we got our dataset back again this time!


* Your turn: export a similar excel table, but at the district level instead











/*
Your turn: export a similar excel table at the province level, but also
include the number of girls in each province
Hint: use collapse (sum) combined with the fact that "girl" is a dummy
*/
























* Solution:

preserve

collapse ///
		(count) person ///
		(sum) girl ///
		(mean) mathsScore ///
		(mean) englishScore ///
		(mean) scienceScore, ///
		by(province)

export excel "ProvincialSummaryTable", firstrow(var) replace
	
restore





***************************************************************************
* Section 2: Graphs Part 1 - Introduction via Histograms and Kdensity
***************************************************************************
			
				
* Create a very basic graph:		
hist mathsScore

* Add a bit of formatting...		
hist mathsScore, ///
	title(Distribution of Maths Scores) ///
	note(Scores are standardized.)

* Get rid of the blue background:	
hist mathsScore, ///
	title(Distribution of Maths Scores) ///
	note(Scores are standardized.) ///	
	graphregion(color(white)) bgcolor(white) plotregion(fcolor(white))
	
* kdensity works well for continuous variables, like our exam score	
kdensity mathsScore, ///
	title(Distribution of Maths Scores) ///
	note(Scores are standardized.) ///	
	graphregion(color(white)) bgcolor(white) plotregion(fcolor(white))

	
/*
Your turn: create kdensity plots for englishScore and scienceScore.
Make sure you change the titles.
*/	
		
		
		
		
		
		
		
	
* twoway allows us to overlay multiple plots
twoway 	kdensity mathsScore if daySchool == 0 || /// put the first thing to plot here, followed by ||
		kdensity mathsScore if daySchool == 1, /// after the final thing to plot, we put the comma (then we can do options)
		title(Distribution of Maths Scores) ///
		note(Scores are standardized.) ///	
		graphregion(color(white)) bgcolor(white) plotregion(fcolor(white)) ///
		ytitle(Density) xtitle(Grade 9 Maths Exam Score out of 100) ///
		legend( label(1 "Boarding School") label(2 "Day School") )

* we can do twoway with hist too...		
twoway 	hist mathsScore if daySchool == 0, color(blue%50) || ///
		hist mathsScore if daySchool == 1, color(red%50) ///
		title(Distribution of Maths Scores) ///
		note(Scores are standardized.) ///	
		graphregion(color(white)) bgcolor(white) plotregion(fcolor(white)) ///
		ytitle(Density) xtitle(Grade 9 Maths Exam Score out of 100) ///
		legend( label(1 "Boarding School") label(2 "Day School") )

		
/*
Your turn: create a graph that overlays 3 kdensity's: 
	1. mathematics score in basic day school
	2. mathematics score in secondary day school
	3. mathematics score in secondary boarding school	
Feel free to copy some of the above code - it should need relatively few modifications...
Do the distributions look different?
*/		
		


		
		
		
		
		
		
		
/*
Your turn: create a graph that overlays 3 histograms: 
	1. mathematics score
	2. english score
	3. science score
Make sure all 3 are visible (you may need to change the colours!)
Do the distributions look different?
*/










		

* Combining two graphs using graph combine:
		
twoway 	kdensity mathsScore if daySchool == 0 & girl == 0 || ///
		kdensity mathsScore if daySchool == 1 & girl == 0, ///
		title(Boys) ///
		graphregion(color(white)) bgcolor(white) plotregion(fcolor(white)) ///
		ytitle(Density) xtitle(Grade 9 Maths Exam Score out of 100) ///
		legend( label(1 "Boarding") label(2 "Day") )	///
		name(g1, replace)
		
twoway 	kdensity mathsScore if daySchool == 0 & girl == 1 || ///
		kdensity mathsScore if daySchool == 1 & girl == 1, ///
		title(Girls) ///
		graphregion(color(white)) bgcolor(white) plotregion(fcolor(white)) ///
		ytitle(Density) xtitle(Grade 9 Maths Exam Score out of 100) ///
		legend( label(1 "Boarding") label(2 "Day") )	///
		name(g2, replace)		

graph combine g1 g2, ///
	graphregion(color(white)) plotregion(fcolor(white)) ///
	title(Distribution of Maths Score by School Type and Gender)

/*
Exercise: 
Create a variable for average score across all three subjects
Then, we have four subjects: maths, english, science, average
For each subject, create a combined graph that compares the kdensity between basic and secondary school
You should end up with four panels: top-left is mathematics, top-right is english, etc.
Each panel should have two kdensity plots (one for basic and one for secondary)
Make sure that the formatting is done in a sensible way, so that the whole thing is readable!
*/	










	
	
	
	
***************************************************************************
* Section 3: Graphs Part 2 - Bars and other graph types
***************************************************************************		

* by(province) produces separate graphs for each province (just like graph combine!)		
graph bar mathsScore, by(province)

* over(province) produces one graph where each province is one bar
graph bar mathsScore, over(province)

* For our purposes, over is probably better

* Produces a nice-looking bar chart	
graph bar mathsScore, over(province) ///
	yscale(range(50 62)) ylabel(50(5)60) ///
	asyvars exclude0 ///
	title(Mean Grade 9 Maths Score by Province) ///
	ytitle(Mean Grade 9 Maths Score) ///
	graphregion(color(white)) bgcolor(white) plotregion(fcolor(white)) ///
	note(Scores are standardised.)

* We can do this for several variables at a time (does it look like scores are correlated?)	
graph bar mathsScore englishScore scienceScore, over(province) ///
	yscale(range(50 62)) ylabel(50(5)60) ///
	asyvars exclude0 ///
	title(Mean Grade 9 Exam Scores by Province) ///
	ytitle(Mean Grade 9 Exam Score) ///
	graphregion(color(white)) bgcolor(white) plotregion(fcolor(white)) ///
	note(Scores are standardised.) ///
	legend( label(1 "Maths") label(2 "English")  label(3 "Science"))

* Using two overs: it seems like boarding schools perform better everywhere (i.e., not just driven by a few provinces)	
graph bar mathsScore, over(daySchool) over(province) ///
	yscale(range(50 62)) ylabel(50(5)60) ///
	asyvars exclude0 ///
	title(Mean Grade 9 Maths Score by Province) ///
	ytitle(Mean Grade 9 Maths Score) ///
	graphregion(color(white)) bgcolor(white) plotregion(fcolor(white)) ///
	note(Scores are standardised.)

* We can stack bars (though not sure if this really helps interpretation much)	
graph bar mathsScore englishScore, over(province) ///
	yscale(range(0 130)) ylabel(0(20)120) ///
	asyvars stack ///
	title(Mean Grade 9 Exam Scores by Province) ///
	ytitle(Mean Grade 9 Exam Score) ///
	graphregion(color(white)) bgcolor(white) plotregion(fcolor(white)) ///
	note(Scores are standardised.) ///
	legend( label(1 "Maths") label(2 "English") )

/*
Your turn!
Create a bar chart that stacks all 3 subjects (make sure you format it properly!)
Next, generate a variable equal to the total across all 3 subjects
Then, do a bar chart of this
Finally, graph combine these two bar charts so we can compare them. Do they look similar?
*/




















/*

* Solution: 

graph bar mathsScore englishScore scienceScore, over(province) ///
	yscale(range(0 180)) ylabel(0(20)180) ///
	asyvars stack ///
	title(Mean Grade 9 Exam Scores by Province) ///
	ytitle(Mean Grade 9 Exam Score) ///
	graphregion(color(white)) bgcolor(white) plotregion(fcolor(white)) ///
	note(Scores are standardised.) ///
	legend( label(1 "Maths") label(2 "English") label(3 "Science")) ///
	name(g1, replace)
	
gen totalScore = mathsScore + englishScore + scienceScore	

graph bar totalScore, over(province) ///
	yscale(range(0 180)) ylabel(0(20)180) ///
	asyvars exclude0 ///
	title(Mean Grade 9 Total Score by Province) ///
	ytitle(Mean Grade 9 Total Score) ///
	graphregion(color(white)) bgcolor(white) plotregion(fcolor(white)) ///
	note(Scores are standardised.) ///
	name(g2, replace)
	
graph combine g1 g2	

drop totalScore

* They are the same because the mean is a linear operator!
	
*/	
	
	
	
	
* Other graph types - cibar
cibar mathsScore, over1(province) ///
	graphopts( ytitle("Maths Score") xtitle("Province Number") ///
	title("Average Maths Score in Different Provinces") ///
	graphregion(color(white)) bgcolor(white) plotregion(fcolor(white)))	

* What's the CI used here? 
* Hint: type mean mathsScore
		
* Other graph types - dot	
graph dot mathsScore, over(province) ///
	yscale(range(50 62)) ylabel(50(5)60) ///
	asyvars exclude0 ///
	title(Mean Grade 9 Maths Score by Province) ///
	ytitle(Mean Grade 9 Maths Score) ///
	graphregion(color(white)) bgcolor(white) plotregion(fcolor(white)) ///
	note(Scores are standardised.) ///
	legend( rows(2) cols(5))
	
graph dot mathsScore, over(daySchool) over(province) ///
	yscale(range(50 70)) ylabel(50(5)70) ///
	asyvars exclude0 ///
	title(Mean Grade 9 Maths Score by Province) ///
	ytitle(Mean Grade 9 Maths Score) ///
	graphregion(color(white)) bgcolor(white) plotregion(fcolor(white)) ///
	note(Scores are standardised.)		

	
* Other graph types - pie
egen schoolTag = tag(school) // we will cover this command later in the session

graph pie if schoolTag == 1, over(daySchool) ///
		title("Proportions of Types of School") ///
		graphregion(color(white)) bgcolor(white) plotregion(fcolor(white)) ///
		plabel (1 percent) plabel(2 percent) 

* Other graph types - catplot

* Generate a variable that is equal to the total number of pupils in each school 
* (We will use this to sort the lines in the catplot)		
bysort school: gen numPupils = _N	

catplot girl school if district == 1, stack asyvars ///
	var2opts(label(labsize(*0.7)) sort(numPupils school) descending) ///
	graphregion(color(white)) bgcolor(white) plotregion(fcolor(white)) ///
	ytitle(Number of Boys and Girls) /// 
	title(Number of Girls in Different Schools in District 1)

	
* Other graph types - scatter
twoway 	scatter mathsScore englishScore || ///
		lfit mathsScore englishScore || ///
		line mathsScore mathsScore, ///
		ytitle(Grade 9 Maths Score) xtitle(Grade 9 English Score) ///
		graphregion(color(white)) bgcolor(white) plotregion(fcolor(white)) ///
		legend( order(2 "Line of Best Fit" 3 "45 Degree Line") ) ///
		title(Scatter Plot of English vs Maths Score) ///
		note(Scores are standardised.)

* Other graph types - box and whisper

graph hbox *Score, ///
	legend( size(small)) ///
	title(Distributions of Different Grade 9 Exam Scores) ///
	graphregion(color(white)) bgcolor(white) plotregion(fcolor(white)) ///
	ytitle(Exam Score)

				

* Exercise (after you have done egen tag): what does this code do?

preserve

	cap egen schoolTag = tag(school) // cap forces the code to continue even if Stata throws an error

	gen schoolCat = .
		replace schoolCat = 0 if basicSchool == 1
		replace schoolCat = 1 if basicSchool == 0 & daySchool == 1
		replace schoolCat = 2 if basicSchool == 0 & daySchool == 0
	
	lab define tempLab 0 "Basic, Day" 1 "Secondary, Day" 2 "Secondary, Boarding"
	
	lab values schoolCat tempLab
	
	graph pie if schoolTag == 1, over(schoolCat) ///
		title("Proportions of Types of School") ///
		graphregion(color(white)) bgcolor(white) plotregion(fcolor(white)) ///
		plabel (1 percent) plabel(2 percent) plabel(3 percent)
		
restore		



* Exercise (after doing merge): see if you can figure out how the below code works:

preserve

collapse ///
		(mean) mathsScore, ///
		by(province)

merge 1:1 province using "SessionTwoForMerge.dta"

scatter mathsScore province [weight=popdensity], ///
	ytitle(Average Maths Score) xtitle(Province) ///
	xlabel(1(1)10)  ///
	graphregion(color(white)) bgcolor(white) plotregion(fcolor(white)) ///
	title(Avg Maths Score per Province (weighted by Pop Density))
		
restore











***** THE BELOW HAS BEEN MOVED TO SESSION FIVE


***************************************************************************
* Section 4: Working with levels of data
***************************************************************************					

* Let's re-open the original dataset to get rid of any silly variables we created in the last sections
use "SessionTwoDataset", clear

* Introducing egen!

* First let's use egen to calculate the average maths score within each school
bysort school: egen schoolAvgMaths = mean(mathsScore)

/*
Your turn: use egen mean to creates variables equal to:
	1. the average english score within each district
	2. the average science score within each province
	3. the average maths score in the whole population
*/







/* 
Your turn: 
In many regression uses, we want to work with "de-meaned" data
This is what many "fixed effects" estimators are effectively doing
Create a variable for the school average english and science scores
Then, use these variables to create de-meaned versions of maths, english, and science scores
*/












/*

Solution for mathematics: 

gen mathsDemeaned = mathsScore - schoolAvgMaths

* More advanced: 

* To run the regression, we should demean girl too:
bysort school: egen schoolAvgGirl = mean(girl)
gen girlDemeaned = girl - schoolAvgGirl

* Let's run the regular fixed-effect regression:
areg mathsScore girl, absorb(school) // you could also do reg mathsScore girl i.school to include all the dummies

* And now let's regress the two demeaned variables on each other
reg mathsDemeaned girlDemeaned

* As expected, we get the same coefficient!

*/




* Now that we know the school-level mean, what is this number in the average school?
summarize schoolAvgMaths

* ... but this is wrong - why?
* Hint: not all schools have the same number of pupils...

* Ideally, we would just have a dataset where each school shows up once - then we can average

* egen tag can do this for us!

egen schoolTag = tag(school)

* It sets one observation per school equal to 1, and all the others to 0.
* Take a look:
tabulate school schoolTag

* Now, so long as we do "if schoolTag == 1" we effectively have a school-level dataset

* So let's try our summarize again
summarize schoolAvgMaths if schoolTag == 1

* Is this different to what we got before? Why?

* We could also use schoolTag as a weight (but it's kind of wierd)
summarize schoolAvgMaths [weight=schoolTag]


/*
These averages are not very useful in this huge dataset.
Let's see if we can get a nice province-level table, where we can read each province's average.
Have a go at this: 
First, use egen mean to get province-level averages of mathematics
Next, use egen tag to tag each province once
Then, use "keep" combined with our new tag to drop to a province-level dataset
Finally, keep only the variables that we care about (the province IDs and your averages)
Export that to excel!
*/


















* Solution:

bysort province: egen provinceAvgMaths = mean(mathsScore)

egen provinceTag = tag(province)

* Drop to a dataset with one observation per province
keep if provinceTag == 1

* We only care about these variables
keep province provinceAvgMaths

* Take a look at the data: it's just a table now!
* browse

export excel "provinceAverages", firstrow(var) replace


* But now all our data is gone! We'll have to re-open the dataset...
use "SessionTwoDataset", clear

* collapse does the same thing in one step, and allows us to do it on many variables

collapse ///
		(count) person ///
		(mean) mathsScore ///
		(mean) englishScore ///
		(mean) scienceScore, ///
		by(province)

export excel "ProvincialSummaryTable", firstrow(var) replace

* Have to re-open the dataset again...
use "SessionTwoDataset", clear

/*
For our purposes, re-opening the dataset isn't really harmful. 
But for large datasets this can take several minutes (so better to avoid re-opening unless we have to)
Also, if we had done any cleaning work (e.g., labelling, making new variables), we would have lost it
*/

* preserve and restore are designed to work with temporary changes to the dataset
* You will need to execute all of this code (from preserve to restore) in one go		
		
preserve

collapse ///
		(count) person ///
		(mean) mathsScore ///
		(mean) englishScore ///
		(mean) scienceScore, ///
		by(province)

export excel "ProvincialSummaryTable", firstrow(var) replace
	
restore

* We got the same table in excel, but we got our dataset back again this time!


* Your turn: export a similar excel table, but at the district level instead











/*
Your turn: export a similar excel table at the province level, but also
include the number of girls in each province
Hint: use collapse (sum) combined with the fact that "girl" is a dummy
*/
























* Solution:

preserve

collapse ///
		(count) person ///
		(sum) girl ///
		(mean) mathsScore ///
		(mean) englishScore ///
		(mean) scienceScore, ///
		by(province)

export excel "ProvincialSummaryTable", firstrow(var) replace
	
restore




***************************************************************************
* Section 5: Reshaping data
***************************************************************************	

* Let's re-open the original dataset to get rid of any silly variables we created in the last sections
use "SessionTwoDataset", clear

bysort school: gen jVar = _n

reshape wide person mathsScore englishScore scienceScore girl, i(school) j(jVar)

* We need to calculate the mean maths score per school
* rowmean calculates along a row, rather than column
* mathsScore* means all variables that begin with "mathsScore"
egen schoolAvgMaths = rowmean(mathsScore*)

summarize schoolAvgMaths

* we can then reshape to long again - we need to provide a name for the new pupil identifier
reshape long person mathsScore englishScore scienceScore girl, i(school) j(newVar)

drop newVar	
	
	
	
	
	
