Write Up
================
Tidy Team
12/1/2021

# Introduction

Our team’s high level goal with this project was to create a Shiny app
in R that acts as an interactive spatio-temporal visualization of
worldwide deaths related to various risk factors, specifically air
pollution, substance use, and lack of sanitation.

The goal of our Shiny App is to communicate the harmful effects of
certain risk factors (i.e., air pollution, substance use, and
sanitation) on the world through time by visually displaying the deaths
caused by these risk factors. Our interactive map will display the death
rate (deaths per 100,000) in countries across the world from 1990 to
2017 caused by different types of air pollution (e.g., household air
pollution from solid fuels and ambient particulate matter pollution) and
substance use (e.g., alcohol and drugs), and sanitation (e.g. unsafe
water). The motivation to create such an app is to effectively show the
deadly effects of these factors across the globe, and how they compare
by country and change over time. By consolidating the huge amount of
data available in a concise, memorable, and informative way, our Shiny
App could address global deadly factors that can be better understood by
more people. The intended users for this application are the general
public who are curious about death rates, but also researchers and
policy makers who would like to get a perspective on their country’s
death rates for certain categories compared to other countries and
through time.

# Data Description

We utilized three different datasets:

The first dataset is The World Pollution Data from Kaggle, which
contains two separate csv files: (i) the death rate (i.e., number of
deaths per 100,000 people) by air pollution type and by country from
1990 to 2017 - 7 variables and 6468 observations, and (ii) the number of
deaths by risk factor (e.g., unsafe water, unsafe sanitation, no access
to hand wash, household air pollution, Non-exclusive breast feeding,
discontinued breast feeding and child wasting etc.) and by country from
1990 to 2017 - 32 variables and 6468 observations. The second dataset is
The World Map Data from Maps Package, which includes 6 different
variables (e.g., longitude, latitude, and region), and xxx observations.
The third dataset is Pollution Data from Our World in Data, which
includes 4 different variables: entity (country name), country code,
year, and population size.

# Shiny app

Our app displays a dashboard with 3 different tabs, each displaying a
world map and a line chart according to the three main categories of
risk factors: Air pollution, Substance Use, and Sanitation. The world
map is a plotly map highlighting the death rate for the chosen risk
factor tab. Furthermore, there will be a time slider below the map,
through which the user can look at the death rates for between 1990 to
2017, in intervals of 3 years. Each type of pollution is associated with
a different continuous color scale. The colors on the map will go from
light to dark according to the death rate in the country (deaths per
100,000 people). On the map, the user can use their mouse to hover over
each country, displaying a small box over the country that shows the
name of the country and death rate by the chosen category.

Within the three tabs, the user will interact with a side menu, giving
them the ability to select the subcategory within the big three risk
factor categories for the map to display. For instance, within the
Substance Use tab, the side menu will give the user the option to
display death rates from second smoking, alcohol use, drug use, or
smoking. All subcategories of risk factors are listed in the
data\_dictionary.md file. After the map displays the colors according to
the user’s selection, the user can further interact with the map by
sliding the time slider located under the map to select a specific year
to display, ranging from 1990 to 2017. Additionally, the user can click
the play button near the time slider to automatically see the changes
from 1990 to 2017 like an animation. On the map, the user can use their
mouse to hover over each country, displaying a small box over the
country that shows the name and death rate of the country.

Below the map and time slider, there is a line graph that indicates the
changes in number of deaths for the given risk factor over the period of
time the data was collected. The user will be able to choose up to 3
regions for which they can view how the death rates per risk factor
changed from 1990 to 2017. There are a total of xxx regions the user can
choose from.

If the user would like to explore our general findings and conclusions,
they can click on our hyperlink that is located at the bottom of each
side bar. This hyperlink brings the user to our GitHub Write up where
they can find our data sources, approach, and discussion.

# Approach

## Data cleaning and merging

RDS files

We first created a data cleaning file to help separate all the data
cleaning from the rest of the code. Due to the large size of these
datasets, we compressed the csv files into rds files as well as combined
and separated components of the datasets to create our visualizations.
Specifically, we created compressed\_final\_data.rds by combining all
the datasets above so each region has information about the different
death rates by different risk factors. This dataset has xxx variables
(e.g., region, year, death rate by air pollution, etc.), and xxx
observations. However, for the map, we needed to organize death rates by
different risk factors for each country. Therefore, we created 3
different rds files for each category of risk factor (death by air
pollution, substance use, and sanitation). We chose only 3 categories
(when there are 6 categories available) because the Shiny App became too
slow with more than 3 interactive maps. Also, we chose air pollution,
substance Use, and sanitation because those categories had the greatest
effects and changes on the death rate worldwide.

Map Dataset

To create the map, we used a series of `case_when` functions to resolve
inconsistencies between the map dataset and the World Pollution Dataset,
like with entity (country name). However, a limitation was that we
didn’t fix all the country names, especially the ones that could not be
identified on the map due to their small size. Additionally, we aimed to
make all three maps show death rate, not total death count to show more
meaningful information (as countries with greater populations would
logically have a greater number of deaths). However, only the air
pollution category had the death rate in the original dataset, while
substance use and sanitation had the death population in the original
dataset. Therefore, we used the Pollution Data to find the total
population of each country between 1990 and 2017. Then we mutated a new
column for the death rate and calculated it by dividing the total number
of deaths by total population, then multiplied by 100,000 to show the
number of deaths per 100,000 people. However, a limitation is that we
did not age standardize the death rate as we did not learn how to do so.

Time

Additionally, for the years, we filtered for every three years between
1990 and 2017 instead of every year for the sake of loading speed on the
app for the time slider input on the plotly. Also, showing every three
years shows more meaningful change, with sufficient data to see trends
over time. However, we chose to keep data for every year for the line
graphs for the integrity of the graph. Doing this did not slow down the
Shiny app since it’s plotted in a line graph and not a plotly map.

## Shiny app

We chose to separate all the risk factors into three tabs to keep the
Shiny App organized and easy to search through, especially if users are
looking to answer a specific question. For example, a researcher for
public policy with a specific background in China’s sanitation could
easily find sanitation and look into subcategories of sanitation (like
clean water) through the tab. We also included a link to the writeup to
provide users with some general observations as the app displays
numerous amounts of information including time, country, deaths, and
types of risk factors. This link would be helpful for users who don’t
come into the app with a specific goal or question, or users who want to
learn our approach to the app for replication.

\#\#Visualizations: Maps & Line Plots

Plotly

Initially, our group attempted to utilize Leaflet as it is well known
for creating interactive maps. However, this method did not work for us
because it required spatial data that we could not join with the World
Pollution datasets. Next, we tried using `geom_polygon` which worked
visually but limited the amount of interaction we aimed to have. We were
determined to include hover and zoom in features to provide adequate
information for users to learn about death rates by risk factor, as the
color scale would not be detailed enough to compare across countries and
time. Therefore, we finally chose plotly to be able to zoom in and out
as well as have a hover feature for more information in the
visualization and increased user interaction.

Line plots

We also implemented line graphs under each map pertaining to the chosen
risk factor category. Instead of the death rate, we used the total
number of deaths for the y-axis because this graph focuses more on the
change over time for each region, not direct comparisons between
regions. This graph is intended for users who are investigating a
specific region, like South Asia, and how its number of deaths from a
certain risk factor has changed between 1990 and 2017. We chose a
maximum of three regions to be shown on the graph at a time to better
display trends and comparisons with meaningful color differences, time
loading, and clarity. Additionally, we chose to display regions instead
of countries because there would be too many options for the users to
choose from in a check list for the sidebar.

Accessibility

All of the color scales chosen are color blind friendly. Each map shows
a different viridis palette so observing comparisons of death rates
between different countries is more accessible. For the line graphs, we
use one consistent viridis palette to show the line graph is showing
different information from the map. Instead of corresponding with the
death rate, each color corresponds with a region. Additionally, we added
Alt Text to our app, specifically showing when the user hovers over the
map and the line plot. This way, users who can not see the plots clearly
can use their computer’s text reader to listen to our descriptions.

# Discussion

In this section, we will discuss some of the critical findings from our
visualizations for each of the 3 risk factors:

Air Pollution

Death rates attributable to air pollution in total have consistently
fallen throughout the 25 years on the time slider. For instance, the US’
death rate due to air pollution (total) has dropped from 31.19 in 1990
to 19.95 in 2015. This was a fairly surprising finding since our group’s
intuition was that air pollution has increased over the years and
therefore so should air pollution related deaths. However, this finding
does not suggest that air pollution has necessarily decreased, but
rather the possibility that people have developed better methods to
prevent death from air pollution.

Regarding the line plots, our group wanted to compare the absolute death
rates in North America, Eastern Europe and Latin America and Caribbean
since we wanted to compare two well developed regions with a less
developed one. For instance, in 2017, North America had 115000 deaths
attributable to air pollution, whereas Eastern Europe and Latin America
and Caribbean had approximately 150000 and 200000 respectively. This is
very surprising given that Latin America and the Caribbean has a much
smaller population compared to the other 2 regions.

Substance Use

Within the substance use risk factor, Alcohol use and Second hand
smoking proved to provide the most fascinating insights. Within second
hand smoking, the US and Canada reported results that were very
fascinating. For instance, from 1990 to 2015, death rates due to second
hand smoking in the US continuously decreased, from 1.14 to 0.87.
Similarly, Canada’s death rate due to second hand smoking also decreased
from 1.29 to 0.93 between 1990 and 2015. China and Russia faced the
highest death rates due to secondhand smoking, with the latter
experiencing continuously rising death rates until 2008, after which
death rates started to plateau.

Alcohol use death rates painted a surprisingly different story. Canada
and the US in 1990 started off with polar opposite deaths of 0.37 and
1.08 respectively. Surprisingly however, both countries faced
continuously rising death rates and by 2015, death rates due to alcohol
use in Canada and the US were 1.16 and 1.38. However, the region that
has the highest death rates due to alcohol is Eastern Europe,
particularly Russia, Romania and Ukraine, each having a death rate
higher than 2.

Comparing the 3 regions mentioned in the earlier risk factor in the line
plots, we can see that in terms of deaths attributable to alcohol use,
Eastern Europe continuously has a greater number of deaths, followed by
Latin America and Caribbean and North America. It is interesting to note
that number of death due to alcohol for Eastern Europe and Latin America
and Caribbean were roughly the same in 1990, however by 2017, the
disparity was very large (100000 deaths)

Sanitation

This risk factor perhaps indicates the biggest difference between what
would be considered developed vs less developed countries. For instance,
in 1990, the regions with the highest death rates due to unsafe water
sources are Africa, South America and South/South East Asia. Countries
in this region would be considered as less developed countries and
therefore this aligns with our groups’ initial hypothesis. A similar
trend can also be seen for death rates attributable to unsafe sanitation
and a lack of access to handwashing facilities.

However, there is a caveat to the analysis in the sense that quite a few
countries have a negative death rate for this risk factor. For instance,
in 1990 the death rate in the US attributable to a lack of handwashing
facilities was -0.735. This seems to be an issue with the more developed
countries. This was how the original data set was presented and
therefore, this risk factor may not be suitable when making comparisons
between more developed and less developed countries.

For the line plot comparison, Latin America and Caribbean have far
greater deaths attributable to unsafe water sources than Eastern Europe
or North America. In 2017, Eastern Europe and North America had around
only 300 deaths due to unsafe water sources, whereas Latin America and
the Caribbean had around 12000 deaths. This is the most intuitive
finding of the three line plot comparisons so far, since although Latin
America and the Caribbean have a much smaller population, it is a far
less developed region than the other two.

\#\#Conclusion and limitations

We hope that this tool will be helpful to people such as policy analysts
to analyze where interventions are required and track progression of
impact of risk factors on countries over a long period of time.

In terms of limitations, one big limitation is regarding the sanitation
tab which includes a few negative death rates, and therefore this must
be taken into account when analyzing and comparing countries. Similarly,
the death rates attributable to sanitation and substance use are not age
standardized and so our results cannot be used to compare populations
that differ with respect to age structures. Another limitation we faced
with our map was more so an aesthetic one. The hover feature presents
the risk factor as a variable name and also presents the death rate in
scientific notation. Furthermore, the speed of our shiny app is not
optimal. All these factors would require a lot of time in technical
troubleshooting, which we thought we could better use focusing on the
content of our app.
