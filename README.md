Write Up
================
Tidy Team
12/1/2021

# Write up 

## Introduction

Our high-level goal was to create an R Shiny app that acts as an interactive 
spatio-temporal visualization of worldwide deaths related to various risk 
factors, specifically air pollution, substance use, and lack of sanitation.  

### Goals and Motivation

The goal of our Shiny App is to communicate the harmful effects of certain risk 
factors (i.e., air pollution, substance use, and sanitation) on the world 
through time by visually displaying the deaths caused by these risk factors. 
Our interactive maps display the death rate (deaths per 100,000) in countries 
across the world from 1990 to 2015 caused by different types of air pollution 
(e.g., household air pollution from solid fuels) and substance use (e.g., 
alcohol and drugs), and sanitation (e.g., unsafe water). The motivation to 
create such an app is to effectively show the deadly effects of these factors 
across the globe and how they compare by country and change over time. By 
consolidating the vast amount of data in a concise, memorable, and informative 
way, our Shiny App could address deadly global factors to a greater population. 
The intended users for this application are the general public who are curious 
about death rates, as well as researchers and policymakers who are interested in 
gaining a perspective on their region’s death rates from specific risk factors 
compared to other countries and through time. 

### Data Description

We utilize three different datasets. 

The first dataset is The World Pollution Data from Our World in Data via Kaggle. 
This dataset contains two separate CSV files. The first includes the death rate 
(i.e., number of deaths per 100,000 people, age-standardized) by air pollution 
type and country from 1990 to 2017 - `r ncol(death_rates_from_air_pollution)` 
variables and `r nrow(death_rates_from_air_pollution)` observations. The second 
CSV has the raw number of deaths by risk factor (e.g., unsafe water, unsafe 
sanitation, no access to hand wash, household air pollution, non-exclusive 
breastfeeding, discontinued breastfeeding and child wasting, etc.) and by 
country from 1990 to 2017 - `r ncol(number_deaths_by_risk_factor)` variables and 
`r nrow(number_deaths_by_risk_factor)` observations. The second dataset is The 
World Map Data from Maps Package, which includes `r ncol(world_data)` variables (e.g., longitude, latitude, and region) and `r nrow(world_data)` observations. The third dataset is Population Data from Our World in Data, which includes `r ncol(population_data)` different variables: entity (country name), country code, year, and estimated historical population size, and `r nrow(population_data)` observations.

### Shiny App
Our app displays a dashboard with three different tabs, each displaying a world map and a line chart according to the three main categories of risk factors: Air pollution, Substance Use, and Sanitation. The world map is a plotly map highlighting the death rates for the chosen risk factor tab. Furthermore, there is a time slider below the map, where the user can look at the death rates between 1990 to 2015, in intervals of 3 years. Each type of pollution is associated with a different continuous color scale. The colors on the map will go from light to dark according to the death rate in the country (deaths per 100,000 people). On the map, the user can use their mouse to hover over each country, displaying a small box that shows the country’s name and death rate by the chosen category. 

Within the three tabs, the user will interact with a side menu, allowing them to select the subcategory within the big three risk factor categories for the map to display. For instance, within the Substance Use tab, the side menu will allow the user to display death rates from second- hand smoking, alcohol use, drug use, or smoking. All subcategories of risk factors are listed in `data_dictionary.md` file in the data folder. After the map displays the colors according to the user’s selection, the user can further interact with the map by sliding the time slider located under the map to select a specific year to display, ranging from 1990 to 2017. Additionally, the user can click the play button near the time slider to automatically see the changes from 1990 to 2017 like an animation. On the map, the user can use their mouse to hover over each country, displaying a small box over the country that shows the name and death rate of the country.

Below the map and time slider, a line graph indicates the changes in the number of deaths for the given risk factor over the time the data was collected. The user will be able to choose up to 3 regions to view how the death rates per risk factor changed from 1990 to 2017. There are a total of 17 regions the user can select from. 
 
If the user wants to explore our general findings and conclusions, they can click on our hyperlink located at the bottom of each side bar. This hyperlink brings the user to our GitHub Write-up to find our data sources, approach, and discussion.


## Justification of Approach 

### Data cleaning and merging
#### RDS files

We first created a data cleaning file to help separate all the data cleaning from the rest of the code. Due to the large size of these datasets, we compressed the .csv files into rds files and combined and separated components of the datasets to create our visualizations. Specifically, we created `compressed_final_data.rds` by combining all the datasets above so each region has information about the different death rates by various risk factors. However, we needed to organize death rates by different risk factors for each country for the map. Therefore, we created three rds files for each risk factor category (death by air pollution, substance use, and sanitation). We chose only three categories (when there are six categories available) because the Shiny App rendered too slowly with more than three interactive maps. Also, we selected air pollution, substance use, and sanitation because those categories had the most significant effect on the death rate worldwide. 

### Map Dataset
To create the map, we used a series of `case_when` functions to resolve inconsistencies between the map dataset and the World Pollution Dataset, like with entity (country name). However, a limitation was that we could fix all the country names, especially those we could not identify on the map due to their small size. Additionally, we aimed to make all three maps show death rate- not total death count- to account for varying population sizes. However, only the air pollution category had the death rate in the original dataset, while substance use and sanitation had the death population in the original dataset. Therefore, we used Population Data to find the total population of each country between 1990 and 2017. Then we mutated a new column for the death rate and calculated it by dividing the total number of deaths by total population, then multiplied by 100,000 to show the number of deaths per 100,000 people. However, a limitation is that we did not age-standardize the death rate as we did not learn how to do so.

### Time
We filtered for every three years between 1990 and 2017 instead of plotting every year to enhance loading speed on the app. Also, plotting only every three years shows more meaningful change when playing the animation. However, we chose to keep data for every year for the line graphs for the integrity of the chart. This decision did not slow down the Shiny app since it is plotted in a line graph and not a plotly map. 

## Shiny App
### General Structure
We chose to separate all the risk factors into three tabs to keep the Shiny App organized and easy to search through, especially if users are looking to answer a specific question. For example, a researcher for public policy with a particular background in China’s sanitation could easily navigate to sanitation and look into subcategories (like unsafe water source) through the tab and side panel. We also included a link to the write-up to provide users with general observations. This link would be helpful either for users who do not come into the app with a specific goal or question or users who want to learn our approach to the app for replication. 

## Visualizations: Maps & Line Plots
### Plotly
Initially, our group attempted to utilize Leaflet. However, this method did not work because it required spatial data that we could not join with the World Pollution datasets. Next, we tried using `geom_polygon,` which worked visually but limited the interaction we aimed to have. We were determined to include hover and zoom-in features to provide adequate information for users to learn about death rates by risk factor, as the color scale would not be detailed enough to compare across countries and time. Therefore, we finally chose the plotly package to zoom in and out and hover to see for more information.

### Line Plots
We also implemented line graphs under each map pertaining to the chosen risk factor category. Instead of the death rate, we used the total number of deaths for the y-axis because this graph focuses more on the change over time for each region, not direct comparisons between regions. This graph is intended for users investigating a specific region, like South Asia, and how the number of deaths from a particular risk factor has changed between 1990 and 2017. We set the maximum number of regions to three, so the plot displays trends and comparisons with meaningful color differences, time loading, and clarity. 

### Accessibility
All the color scales chosen are color-blind friendly. Each map shows a different Viridis palette, so comparing death rates between different countries is more accessible. We used a different, yet consistent Viridis palette for the line graphs. Each color corresponds with a region instead of corresponding with the death rate. Additionally, we added Alt Text to our app, specifically when the user hovers over the map and the line plot. This way, users who can not see the plots clearly can use their computer’s text reader to listen to our descriptions.


## Discussion

In this section, we will discuss critical findings from our visualizations for each of the three risk factors.

### Air Pollution

Death rates attributable to air pollution in total have consistently fallen throughout the 25 years on the time slider. For instance, the US death rate due to air pollution (total) has dropped from 31.19 in 1990 to 19.95 in 2015. This was a surprising finding since our group’s intuition was that air pollution has increased over the years due to industrialization; therefore, air pollution-related deaths would also increase. However, this finding does not suggest that air pollution has necessarily decreased, but rather the possibility that people have developed better methods to prevent death from air pollution. 

Regarding the line plots, our group wanted to compare the raw death rates in North America, Eastern Europe, and Latin America and the Caribbean since we wanted to compare two well-developed regions with a less developed one. For instance, in 2017, North America had 115000 deaths attributed to air pollution, whereas Eastern Europe and Latin America and the Caribbean had approximately 150000 and 200000, respectively. This finding is surprising given that Latin America and the Caribbean have a much smaller population than the other two regions. 

### Substance Use

Alcohol use and secondhand smoking provided fascinating insights within the substance use risk factor. Within secondhand smoking, the US and Canada reported intriguing results. For instance, from 1990 to 2015, death rates due to secondhand smoking in the US continuously decreased, from 1.14 to 0.87. Similarly, Canada’s death rate due to secondhand smoking decreased from 1.29 to 0.93 between 1990 and 2015. China and Russia faced the highest death rates due to secondhand smoking, with the latter experiencing continuously rising death rates until 2008, after which death rates started to plateau. 

Alcohol use death rates painted a surprisingly different story. Canada and the US in 1990 started with polar opposite deaths of 0.37 and 1.08 respectively. However, both countries faced continuously rising death rates, and by 2015, death rates due to alcohol use in Canada and the US were 1.16 and 1.38. However, the region with the highest death rates due to alcohol is Eastern Europe, particularly Russia, Romania, and Ukraine, each with a death rate higher than two.  

Comparing the three regions mentioned, we can see that Eastern Europe continuously has a more significant number of deaths for alcohol use-related deaths, followed by Latin America and the Caribbean and North America. Interestingly, the number of alcohol-related deaths for Eastern Europe and Latin America and the Caribbean were roughly the same in 1990; however, by 2017, the disparity was vast (100,000 deaths). 

### Sanitation
This risk factor indicates the most significant difference between developed and less developed countries. For instance, in 1990, the regions with the highest death rates due to unsafe water sources were Africa, South America, and South/South East Asia. Countries in this region would be considered less developed countries; therefore, this aligns with our group’s initial hypothesis. A similar trend can also be seen for death rates attributable to unsafe sanitation and a lack of access to handwashing facilities.
	
However, one caveat is that quite a few countries have a negative death rate for this risk factor. For instance, in 1990, the death rate in the US attributable to a lack of handwashing facilities was -0.735. Negative death rates seem to be an issue with the more developed countries, but this was how Our World in Data presented the original data set. Therefore, this risk factor may not be suitable when comparing more developed and less developed countries.

Latin America and the Caribbean have far greater deaths attributed to unsafe water sources than Eastern Europe or North America. In 2017, Eastern Europe and North America had around 300 deaths due to unsafe water sources, whereas Latin America and the Caribbean had around 12,000 deaths. For our group, this is the most intuitive finding of the three line plot comparisons. Although Latin America and the Caribbean have a much smaller population, they are less economically developed than the other two. 

## Conclusion and limitations

We hope this tool will be helpful to policy analysts when they are analyzing where policy interventions are required and tracking the progression of risk factors on countries over time.

One significant limitation regards the sanitation tab, which includes a few negative death rates. This must be taken into account when analyzing and comparing countries. 

Similarly, the death rates attributable to sanitation and substance use are not age-standardized, so our results cannot be used to compare populations with dramatically different age structures.

Another limitation we faced is the hover feature on the map presents the risk factor as a variable name and the death rate in scientific notation. 

The speed of our shiny app is not optimal. 

All these factors would require a large time investment towards technical troubleshooting, and we thought our time was better spent focusing on the visualizations. 

# Shiny App

# Presentation Slides

# References

## Packages:

Winston Chang, Joe Cheng, JJ Allaire, Carson Sievert, Barret Schloerke, Yihui Xie, Jeff Allen, Jonathan McPherson, Alan Dipert and Barbara Borges
  (2021). shiny: Web Application Framework for R. R package version 1.7.1. https://shiny.rstudio.com/

Winston Chang (2021). shinythemes: Themes for Shiny. R package version 1.2.0. https://rstudio.github.io/shinythemes/

Eric Bailey (2015). shinyBS: Twitter Bootstrap Components for Shiny. R package version 0.61. https://ebailey78.github.io/shinyBS

David Gohel and Panagiotis Skintzos (2021). ggiraph: Make 'ggplot2' Graphics Interactive. R package version 0.7.10.
  https://davidgohel.github.io/ggiraph/

Wickham et al., (2019). Welcome to the tidyverse. Journal of Open Source Software, 4(43), 1686, https://doi.org/10.21105/joss.01686

Kirill Müller (2020). here: A Simpler Way to Find Your Files. https://here.r-lib.org/, https://github.com/r-lib/here.

Original S code by Richard A. Becker, Allan R. Wilks. R version by Ray Brownrigg. Enhancements by Thomas P Minka and Alex Deckmyn. (2021). maps: Draw
  Geographical Maps. R package version 3.4.0.


Hadley Wickham and Dana Seidel (2020). scales: Scale Functions for Visualization. https://scales.r-lib.org, https://github.com/r-lib/scales.

C. Sievert. Interactive Web-Based Data Visualization with R, plotly, and shiny. Chapman and Hall/CRC Florida, 2020.

Hadley Wickham and Jim Hester (2021). readr: Read Rectangular Text Data. https://readr.tidyverse.org, https://github.com/tidyverse/readr.

Doug McIlroy. Packaged for R by Ray Brownrigg, Thomas P Minka and transition to Plan 9 codebase by Roger Bivand. (2020). mapproj: Map Projections. R
  package version 1.2.7.

Aron Atkins, Jonathan McPherson and JJ Allaire (2021). rsconnect: Deployment Interface for R Markdown Documents and Shiny Applications. R package
  version 0.8.25. https://github.com/rstudio/rsconnect

Kirill Müller and Lorenz Walthert (2021). styler: Non-Invasive Pretty Printing of R Code. https://github.com/r-lib/styler, https://styler.r-lib.org.

Sam Firke (2021). janitor: Simple Tools for Examining and Cleaning Dirty Data. R package version 2.1.0. https://github.com/sfirke/janitor

Hadley Wickham and Jennifer Bryan (2019). readxl: Read Excel Files. https://readxl.tidyverse.org, https://github.com/tidyverse/readxl.

## Presentation Images:

- https://en.wikipedia.org/wiki/Air_pollution
- https://www.vecteezy.com/video/2019067-dark-world-map-animate-background
- https://www.itprotoday.com/devops-and-software-development/programming-evolution-how-coding-has-grown-easier-past-decade



