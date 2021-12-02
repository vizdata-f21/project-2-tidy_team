Write Up
================
Tidy Team
12/1/2021

# Introduction

Our team’s high level goal with this project was to create a Shiny app
in R that acts as an interactive spatio-temporal visualization of
worldwide deaths related to various risk factors, particularly air
pollution. Goals and Motivation

The goal of our Shiny App is to communicate the harmful effects of air
pollution on the world through time by visually displaying the deaths
caused by air pollution. Our interactive map will display the death rate
(deaths per 100,000) in countries across the world from 1990 to 2017
caused by different types of air pollution (e.g. household air pollution
from solid fuels and ambient particulate matter pollution) and other
risk factors (e.g. unsafe water source and sanitation). The motivation
to create such an app is to effectively show the deadly effects of air
pollution and other risk factors across the globe, potentially showing
the inequitable harm on countries that have less resources to protect
against air pollution. By consolidating the huge amount of data
available in a concise and informative way, the need to address air
pollution can be better visually understood by more people.

# Data Description

Our dataset involves five different imported csv files. The first csv
file includes the rate of death by air pollution type and by country
from 1990 to 2017 - 7 variables and 6468 observations. The second csv
file simply includes the rate of death by country from 1990 to 2017,
regardless of air pollution type - 4 variables and 6468 observations.
According to the data source, death rates are standardized to account
for the differences in distributions of ages of populations between
countries. so that countries can be directly compared. The third csv
file includes the number of deaths by risk factor (unsafe water, unsafe
sanitation, no access to hand wash, household air pollution,
Non-exclusive breast feeding, discontinued breast feeding and child
wasting etc.) and by country from 1990 to 2017 - 32 variables and 6468
observations. The fourth csv file includes the proportion of deaths
attributed to air pollution in countries from 1990 to 2017 - 7
variables. The fifth csv file includes the annual GDP per capita for
each country in current USD from 1990 to 2017 - 30 variables and 266
observations. There is some missing data for some countries in the 1960s
and 1970s but the vast majority of observations are complete so this
dataset will suffice; however, this limitation will be clearly noted in
the shiny model. Perhaps we will include a tab that details missing data
points so the user understands limitations.

# Shiny app

Our app will display a dashboard with 6 different tabs. The first tab
will be an introduction tab introducing the purpose of the app to the
user. The next 4 tabs will each represent the 4 main risk factors: Air
pollution, Substance use, Diet, Sanitation, health and post natal. Each
of these 4 tabs will contain a world map and a line chart. The world map
is a choropleth map highlighting the death rate for the chosen risk
factor tab. Furthermore, there will be a time slider below the map,
through which the user can look at the death rates for any year between
1990 to 2017. Each type of pollution is associated with a different
continuous color scale. The colors on the map will go from light to dark
according to the death rate in the country (deaths per 100,000 people).
On the map, the user can use their mouse to hover over each country,
displaying a small box over the country that shows the name, GDP per
capita, and death rate of the country. Below the map and time slider,
there is a line graph that indicates the changes in death rates for the
given risk factor over the period of time the data was collected. The
user will be able to choose up to 8 regions for which they can view how
the death rates per risk factor change from 1990 to 2017.

The sixth and last tab, labeled “Trends”, will display screenshots
comparing different ranges of years that our time found particularly
interesting to highlight. The Trends tab is meant to provide users an
idea of the overarching observations of our map.

Within the Map tab, the user will interact with a side menu, giving them
the ability to select the type of pollution the map will display. The
user will also have the option to choose a type of risk factor instead
of type of air pollution in the side menu. We included this option to
provide additional information about causes of death across the globe if
the user wants to observe how deaths by other causes vary across the
years and country. When selected, the map will instead show the number
of deaths in the country by the risk factor. The types of risk factors
are included in the appendix. After selecting the type of pollution/risk
factor, the user selects whether or not the user wants to see death
rates in an absolute scale or a log scale. After the map displays the
colors according to the user’s selection, the user can further interact
with the map by sliding the time slider located under the map to select
a specific year to display, ranging from 1990 to 2017. We are also
exploring animating the slider. On the map, the user can use their mouse
to hover over each country, displaying a small box over the country that
shows the name, GDP per capita, and death rate of the country.

# Approach

## Data cleaning and merging

We first created a data cleaning file to help separate all the data
cleaning from the rest of the code. Since the data was very large, we
converted the csv files into rds files to compress and later call them
into our R scripts. *Drew and Kathryn’s Data cleaning method*

# Discussion

In this section, we will discuss some of the critical findings from our
visualizations for each of the 6 risk factors:

## Air Pollution

Death rates attributable to pure air pollution have consistently fallen
throughout the 25 years. For instance, the US’ death rate due to air
pollution has dropped from 31.19 in 1990 to 19.95 in 2015. This was a
fairly surprising finding since our group’s intuition was that air
pollution has increased over the years and therefore so should air
pollution related deaths. However, this finding does not suggest that
air pollution has decreased, but perhaps rather the possibility that
people have developed better methods to prevent death from air
pollution.

Within the air pollution risk factor, another key result was that death
rates due to household pollution (contamination that is released during
the use of various products in daily life) is very low among all
countries and has continuously decreased throughout the 25 years.

## Substance use

## Second hand smoking

Within second hand smoking, the US and Canada reported results that were
very fascinating.For instance, from 1990 to 2015, death rates due to
second hand smoking in the US continuously decreased, from 1.14 to 0.87.
Similarly, Canada’s death rate due to second hand smoking also decreased
from 1.29 to 0.93 between 1990 and 2015. China and Russia faced the
highest death rates due to secondhand smoking, with the latter
experiencing continuously rising death rates until 2008, after which
death rates started to plateau.

## Alcohol use

Alcohol use painted a surprisingly different story. Canada and the US in
1990 started off with polar opposite deaths of 0.37 and 1.08
respectively. Surprisingly however, both countries faced continuously
rising death rates and by 2015, death rates due to alcohol use in Canada
and the US were 1.16 and 1.38. However, the region that has the highest
death rates due to alcohol is Eastern Europe, particularly Russia,
Romania and Ukraine, each having a death rate higher than 2.

## Drug use

Drug use was an interesting risk factor to look into since in 1990 the
African continent, apart from South Africa, was the only continent not
facing high death rates. Once again, during 1990, the US, China and
Russia had the highest death rates. Surprisingly, Greenland also had a
high death rate in 1990 of 1.19. After conducting some further research,
it seems that alcohol and drug use are a big problem in the country,
with the former even being outlawed in some cities.

Out of all the risk factors, however, drug usage seems to have increased
death rates along the years the most. By 2015, the continent of Africa
faced severely high death rates, with the US and Russia each having
death rates of 1.4.

## Smoking

Similar to Drug use, Smoking is another issue that seems to have
widespread death rates. Once again, Africa, with the exception of South
Africa, seems to be the only continent that does not have high death
across the entire continent.
