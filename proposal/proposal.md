Project Proposal
================

## Load Data

``` r
# air pollution data
death_rates_total_air_pollution_csv <- read_csv(here("data", "death-rates-total-air-pollution.csv"), show_col_types = FALSE)
death_rates_from_air_pollution_csv <- read_csv(here("data", "death-rates-from-air-pollution.csv"), show_col_types = FALSE)
share_deaths_air_pollution_csv <- read_csv(here("data", "share-deaths-air-pollution.csv"), show_col_types = FALSE)
number_deaths_by_risk_factor_csv <- read_csv(here("data","number-of-deaths-by-risk-factor.csv"), show_col_types = FALSE)

# added _csv ending to eliminate need for naming later versions "clean"

# world map data 
world_map <- map_data("world") %>% as_tibble()
```

Using `show_col_types` to suppress the message because we do not need to
know what the column types are when we load the data.

``` r
death_rates_total_air_pollution <- death_rates_total_air_pollution_csv %>%
  clean_names() %>% 
  rename(death_rate_air_pollution = 
           deaths_air_pollution_sex_both_age_age_standardized_rate)

death_rates_from_air_pollution <- death_rates_from_air_pollution_csv %>%
  clean_names() %>% 
  rename(death_rate_air_pollution = 
           deaths_air_pollution_sex_both_age_age_standardized_rate, 
       death_rate_household_pollution = deaths_household_air_pollution_from_solid_fuels_sex_both_age_age_standardized_rate, 
       death_rate_ambient_matter_pollution = deaths_ambient_particulate_matter_pollution_sex_both_age_age_standardized_rate, 
       death_rate_ozone_pollution = 
         deaths_ambient_ozone_pollution_sex_both_age_age_standardized_rate)

#this looks messy but the column names are originally super long 

share_deaths_air_pollution <- share_deaths_air_pollution_csv %>% 
  clean_names() %>% 
  rename(share_death_air_pollution = air_pollution_total_ihme_2019)

number_deaths_by_risk_factor <- number_deaths_by_risk_factor_csv %>% 
  clean_names()
```

``` r
glimpse(death_rates_total_air_pollution)
```

    ## Rows: 6,468
    ## Columns: 4
    ## $ entity                   <chr> "Afghanistan", "Afghanistan", "Afghanistan", …
    ## $ code                     <chr> "AFG", "AFG", "AFG", "AFG", "AFG", "AFG", "AF…
    ## $ year                     <dbl> 1990, 1991, 1992, 1993, 1994, 1995, 1996, 199…
    ## $ death_rate_air_pollution <dbl> 299.4773, 291.2780, 278.9631, 278.7908, 287.1…

``` r
glimpse(death_rates_from_air_pollution)
```

    ## Rows: 6,468
    ## Columns: 7
    ## $ entity                              <chr> "Afghanistan", "Afghanistan", "Afg…
    ## $ code                                <chr> "AFG", "AFG", "AFG", "AFG", "AFG",…
    ## $ year                                <dbl> 1990, 1991, 1992, 1993, 1994, 1995…
    ## $ death_rate_air_pollution            <dbl> 299.4773, 291.2780, 278.9631, 278.…
    ## $ death_rate_household_pollution      <dbl> 250.3629, 242.5751, 232.0439, 231.…
    ## $ death_rate_ambient_matter_pollution <dbl> 46.44659, 46.03384, 44.24377, 44.4…
    ## $ death_rate_ozone_pollution          <dbl> 5.616442, 5.603960, 5.611822, 5.65…

``` r
glimpse(share_deaths_air_pollution)
```

    ## Rows: 6,412
    ## Columns: 4
    ## $ entity                    <chr> "Afghanistan", "Afghanistan", "Afghanistan",…
    ## $ code                      <chr> "AFG", "AFG", "AFG", "AFG", "AFG", "AFG", "A…
    ## $ year                      <dbl> 1990, 1991, 1992, 1993, 1994, 1995, 1996, 19…
    ## $ share_death_air_pollution <dbl> 13.56, 13.19, 13.05, 12.88, 12.80, 12.98, 12…

``` r
glimpse(number_deaths_by_risk_factor)
```

    ## Rows: 6,468
    ## Columns: 32
    ## $ entity                                   <chr> "Afghanistan", "Afghanistan",…
    ## $ code                                     <chr> "AFG", "AFG", "AFG", "AFG", "…
    ## $ year                                     <dbl> 1990, 1991, 1992, 1993, 1994,…
    ## $ unsafe_water_source                      <dbl> 7554.050, 7359.677, 7650.438,…
    ## $ unsafe_sanitation                        <dbl> 5887.748, 5732.770, 5954.805,…
    ## $ no_access_to_handwashing_facility        <dbl> 5412.315, 5287.891, 5506.657,…
    ## $ household_air_pollution_from_solid_fuels <dbl> 22388.50, 22128.76, 22873.77,…
    ## $ non_exclusive_breastfeeding              <dbl> 3221.139, 3150.560, 3331.349,…
    ## $ discontinued_breastfeeding               <dbl> 156.09755, 151.53985, 156.609…
    ## $ child_wasting                            <dbl> 22778.85, 22292.69, 23102.20,…
    ## $ child_stunting                           <dbl> 10408.439, 10271.976, 10618.8…
    ## $ low_birth_weight_for_gestation           <dbl> 12168.56, 12360.64, 13459.59,…
    ## $ secondhand_smoke                         <dbl> 4234.808, 4219.597, 4371.908,…
    ## $ alcohol_use                              <dbl> 356.5293, 320.5985, 293.2570,…
    ## $ drug_use                                 <dbl> 208.3254, 217.7697, 247.8333,…
    ## $ diet_low_in_fruits                       <dbl> 8538.964, 8642.847, 8961.526,…
    ## $ diet_low_in_vegetables                   <dbl> 7678.718, 7789.773, 8083.235,…
    ## $ unsafe_sex                               <dbl> 387.1676, 394.4483, 422.4533,…
    ## $ low_physical_activity                    <dbl> 4221.303, 4252.630, 4347.331,…
    ## $ high_fasting_plasma_glucose              <dbl> 21610.07, 21824.94, 22418.70,…
    ## $ high_total_cholesterol                   <dbl> 9505.532, NA, NA, NA, NA, 146…
    ## $ high_body_mass_index                     <dbl> 7701.581, 7747.775, 7991.019,…
    ## $ high_systolic_blood_pressure             <dbl> 28183.98, 28435.40, 29173.61,…
    ## $ smoking                                  <dbl> 6393.667, 6429.253, 6561.055,…
    ## $ iron_deficiency                          <dbl> 726.4313, 739.2458, 873.4853,…
    ## $ vitamin_a_deficiency                     <dbl> 9344.132, 9330.182, 9769.845,…
    ## $ low_bone_mineral_density                 <dbl> 374.8441, 379.8542, 388.1304,…
    ## $ air_pollution                            <dbl> 26598.01, 26379.53, 27263.13,…
    ## $ outdoor_air_pollution                    <dbl> 4383.83, 4426.36, 4568.91, 50…
    ## $ diet_high_in_sodium                      <dbl> 2737.198, 2741.185, 2798.560,…
    ## $ diet_low_in_whole_grains                 <dbl> 11381.38, 11487.83, 11866.24,…
    ## $ diet_low_in_nuts_and_seeds               <dbl> 7299.867, 7386.764, 7640.629,…

``` r
glimpse(world_map)
```

    ## Rows: 99,338
    ## Columns: 6
    ## $ long      <dbl> -69.89912, -69.89571, -69.94219, -70.00415, -70.06612, -70.0…
    ## $ lat       <dbl> 12.45200, 12.42300, 12.43853, 12.50049, 12.54697, 12.59707, …
    ## $ group     <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, …
    ## $ order     <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 13, 14, 15, 16, 17, 18, 1…
    ## $ region    <chr> "Aruba", "Aruba", "Aruba", "Aruba", "Aruba", "Aruba", "Aruba…
    ## $ subregion <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …

## One Sentence High-Level Goal

Create an interactive spatio-temporal visualization of worldwide deaths
related to air pollution.

## Description of our Goals and Motivation

The goal of our Shiny App is to communicate the harmful effects of air
pollution on the world through time by visually displaying the deaths
caused by air pollution. Our interactive map will display the death rate
(deaths per 100,000) in countries across the world from 1990 to 2017
caused by different types of air pollution (e.g. household air pollution
from solid fuels and ambient particulate matter pollution). The
motivation to create such an app is to effectively show the deadly
effects of air pollution across the globe, potentially showing the
inequitable harm on countries that have less resources to protect
against air pollution. By consolidating the huge amount of data
available in a concise and informative way, the need to address air
pollution can be better understood by more people.

#### Shiny App User Interaction

The app will first display the map page, which is set as the first tab
of the page, labeled “Map”. The second tab will be labeled “Info”, which
will display a paragraph description of the summary of the data, where
we got the data from, and the goals of the app. The third tab, labeled
“Trends”, will display screenshots comparing different ranges of years
that our time found particularly interesting to highlight. The Trends
tab is meant to provide users an idea of the overarching observations of
our map. See the appendix for the sketch of our interface and choices
available for the user. Within the Map tab, the user will interact with
a side menu, giving them the ability to select the type of pollution the
map will display. Each type of pollution is associated with a different
continuous color scale. The colors on the map will go from light to dark
according to the death rate in the country (deaths per 100,000 people).
The user will also have the option to choose a type of risk factor
instead of type of air pollution in the side menu. When selected, the
map will instead show the number of deaths in the country by the risk
factor. The types of risk factors are included in the appendix. After
selecting the type of pollution/risk factor, the user selects whether or
not the user wants to see death rates in an absolute scale or a log
scale. After the map displays the colors according to the user’s
selection, the user can further interact with the map by sliding the
time slider located under the map to select a specific year to display,
ranging from 1990 to 2017. On the map, the user can use their mouse to
hover over each country, displaying a small box over the country that
shows the name, GDP, and death rate of the country.

#### Tools

We will be using the leaflet package to create our interactive map.
Although we could geom\_polygon for this process, we wanted to explore a
new package and look into something that we have not learned in class
yet. The leaflet package will enable us to make the map interactive in
the sense that not only will the user be able to zoom and view country
labels, but we can also add markers for locations of importance and add
various other layers to our map.

Our dataset involves four different imported csv files. The first csv
file includes the rate of death by air pollution type and by country
from 1990 to 2017 - 7 variables and 6468 observations. The 2nd csv file
simply includes the rate of death by country from 1990 to 2017,
regardless of air pollution type - 4 variables and 6468 observations.
The 3rd csv file includes the number of deaths by risk factor (unsafe
water, unsafe sanitation, no access to hand wash, household air
pollution, Non-exclusive breast feeding, discontinued breast feeding and
child wasting etc.) and by country from 1990 to 2017 - 32 variables and
6468 observations. The 4th csv file includes the proportion of deaths
attributed to air pollution in countries from 1990 to 2017 - 7 variables
and 6412 observations. Visual draft of our map can be found in the
appendix.

## Weekly Plan of Attack

1.  Week 1 of project (week of Mon, Oct 18): Pick a focus for your
    project.

-   Brainstormed project ideas and pick data (All during Lab).
-   Ran project idea by Vittorio (All during Lab).

2.  Week 2 of project (week of Mon, Oct 25): Work on developing your
    project proposal and setting up the structure for your repository.

-   Set up repo structure (Courtney).
-   Start working on proposal (All assigned out own parts).

3.  Week 3 of project (week of Mon, Nov 1): Finalize your project
    proposal.

-   **Proposals for peer review: due Fri, Nov 5 at 5pm.**
-   Talk with Professor Cetinkaya-Rundel during office hours to receive
    semi-approval to begin working on the project. We hope to get
    started early in anticipation of challenges, and we do not want to
    be doing this project last minute. (Whoever is available during
    office hours time).
-   Ideally, start working on framework for project. Picking which
    variables to use for the visualization and brainstorming a “draft”
    visualization (All of us during weekly meeting).

4.  Week 4 of project (week of Mon, Nov 8): Conduct peer review on
    project proposals, and optionally, submit in an updated version of
    your proposal.

-   **Revised proposals for instructor review: due Fri, Nov 12 at 5pm**
-   Update proposal (All during weekly meeting)
-   Research information about creating interactive spatio-temporal
    visualizations on Shiny. (All)
-   Organize notes in the Google Doc. (All, while doing research)
-   Ideally, this step will help us from jumping in blind to the project
    and will provide us a solid foundation to begin our work on.

5.  Week 5 of project (week of Mon, Nov 15): Continue working on your
    project.

-   Start coding the spatio-temporal visualization of worldwide deaths
    related to air pollution.
-   At this point, we would like to decide if we will need to introduce
    any other data to our visualization.

6  Week 6 of project (week of Mon, Nov 22): Continue working on your
project. + Continue working on the visualization. + If necessary,
introduce outside/additional data.

7  Week 7 of project (week of Mon, Nov 29): Conduct another round of
peer review. + Ideally, we would like to have the coding part of our
project done by the end of this week. That would give us the following
week to reflect, make any final touches, and plan for the presentation.

8.  Write-up and presentation: due Fri, Dec 3 at noon (beginning of
    class).

-   Make any final touches.
-   Craft presentation. Prepare for in-class presentation on LDOC.

### Weekly Meeting Date and Time

We plan to have our scheduled meetings weekly on Wednesdays before
lecture. We will decide how early to start before class based on how
much work we anticipate needed to get through for the day.

## Repo Organization

The project is organized into 6 main folders:

-   `data`: includes our world air pollution datasets and the data
    dictionary.
-   `images`: includes any images, logos, and gifs for our Shiny App.
-   `proposal`: includes our Project 2 proposal files.
-   `pollution_map`: contains our files that build to the Shiny App.
    This includes data wrangling and visualization steps, as well as the
    final shiny app files. We will include more sub folders into this
    folder as we build the app as needed.
-   `presentation`: includes our presentation files.
-   `exploratory_work` : includes any initial exploratory data analysis,
    visualizations, or other attempts at our project. We intend to
    delete this folder before the project is complete, but are using it
    now as a workspace.

## Appendix

![Map Brainstorm](../images/map_appendix.jpg)

## References

Below is a list of references we plan to use when creating our project.

-   <https://stackoverflow.com/questions/52087675/interactive-shiny-app-with-r-hovering-over-points-and-displaying-info>
-   <https://rviews.rstudio.com/2019/10/09/building-interactive-world-maps-in-shiny/>
-   <https://stackoverflow.com/questions/52087675/interactive-shiny-app-with-r-hovering-over-points-and-displaying-info>

## Data Reference

Although accessed via
[Kaggle](https://www.kaggle.com/pavan9065/air-pollution), the data’s
original source is [Our World in Data](https://ourworldindata.org/),
which is a public data collection initiative led by the nonprofit Global
Change Data Lab. The nonprofit shares knowledge (and data) about the
world’s most pressing issues so that anyone has the tools and
information they need to work toward combating a particular global
problem. The data was posted to Kaggle about a month ago and includes
data spanning the years 1990 to 2017.

Hi Drew — that’s no problem as long as you’re creating the app from
scratch yourself. If you’re inspired by it you should cite it in your
project, and describe how you were inspired and how yours is different.
ADD INSPIRATION – we designed it first but were insprided by

<https://ourworldindata.org/air-pollution>
