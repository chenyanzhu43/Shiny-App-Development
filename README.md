# Project 2: Shiny App Development Version 2.0

## Project Title: NYC Housing Litigation Analysis
Term: Fall 2019

+ Team: Group 3
+ Team members
	+ Chen, Yanzhu
	+ Haghpanah, Fateme Sadat
	+ Hao, Sixing
	+ Lu, Haotian
	+ Yang, Nan

+ Link to Shiny App: https://sh3799.shinyapps.io/HousingLitigations/

+ **Project summary**: 

This app contains three topics, including litigations overview, buildings details, and respondents search. The team uses [Housing Litigations](https://data.cityofnewyork.us/Housing-Development/Housing-Litigations/59kj-x8nc) dataset from NYC OpenData. The analysis covers NYC buildings ID, location information, and related respondent information between year 2000 and 2019. This topic is excluded from “suggested" list.

The first tab shows litigations overview by case types(i.e.Comprehensive) and open year(i.e.2019) selected. By choosing specific case type and status, a colored map is produced based on different zipcodes. The deeper the color, the higher frequency litigations exist in that area. Therefore, users could compare the difference in color directly from map to get information about litigations frequency.

The second tab exhibits detailed litigations information of each building. By setting number of litigations as condition for a building to show on map, user may click on the blue circle to detailed information of that building such as address, number of litigations, and most recent repondents. Addtionally, clicking on the See/Update Building Details bottom will display two graphs below; one is about trend of litigations amount through years and the other is proportion distribution of case types and status.

The third tab takes care of respondents. User might type in the name of respondent and then the location of related building would show on map. Besides, a histogram for number of building vs. number of litigations is generated.

The last two tabs are Appendix. Appendix A is about case development and Appendix B is housing litigation procedure, which illustrate structure of how litigation proceed further to help users better understand case types. 

+ **Contribution statement**: 

All team members contributed equally in all stages of this project. All team members approve our work presented in this GitHub repository including this contributions statement.

**The following are more explanations and details of our equally contribution.**

In our first meeting, we started to looking for finding the data sets. All of us had suggestion for that and participate in the brainstorming on choosing it. After finalizing the data set, we started brainstorming and discussing on the features that we can show and visualize in our project to be applicable and useful for its audience.
After that, we splitted to two subgroups based on the tabs and features. One subgroup included Hao and Haghpanah, and the other included Chen, Lu, and Yang. Each of these subgroups start working together. The first subgroup came up with ideas that they can show the information in two different tabs instead of one and in that case it would be better and more informative. The other subgroup splitted the work of data cleaning and doing the tab and providing the appendixes for the project. Also, we had some meeting which all the members were presented and feedback on the other works and ideas to improve the whole project and tie all the tabs together to make them consistent. At the end, Hao was responsible to deploy everything to the shiny app. However, all the people did change their code and variables and data path and ... in order to prevent the conflicts during the merge. And after that other, especially Haghpanah which was supposed to gave the presentation, checked the merged code and deployed on shiny app to debug and report any bug and issues. So, we believe that every one did their bests and we participate almost equally. (The itemized contribution of everyone's work is listed in below.)

+ Chen, Yanzhu: brainstorm, data cleaning, tab 1 litigation overview(20%), readme file editing
+ Haghpanah, Fateme Sadat: brainstorm, tab 3 respondent, debugging the final deployed code on shiny and check the consistency of every part of the app and report problems.
+ Hao, Sixing (leader): brainstorm, tab 2 building, merging all tabs together, upload and deploy shiny app
+ Lu, Haotian: brainstorm, Appendix A&B, tab 1 litigation overview(20%)
+ Yang, Nan: brainstorm, tab 1 litigation overview(60%)

 

Following [suggestions](http://nicercode.github.io/blog/2013-04-05-projects/) by [RICH FITZJOHN](http://nicercode.github.io/about/#Team) (@richfitz). This folder is orgarnized as follows.

```
proj/
├── app/
├── lib/
├── data/
├── doc/
└── output/
```

Please see each subfolder for a README file.

