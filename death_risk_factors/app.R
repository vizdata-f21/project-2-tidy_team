# Load packages ----------------------------------------------------------------

library(shiny)
library(shinythemes)
library(shinyBS)
library(ggiraph)
library(tidyverse)
library(here)
library(maps)
library(scales)
library(plotly)
library(readr)
library(mapproj)
library(rsconnect)
library(styler)


# Load pre-cleaned, compressed data --------------------------------------------

total_joined <- read_rds("data/compressed_final_data.rds")

air_pollution_regions <- read_rds("data/air_pollution_regions.rds")

substance_use_regions <- read_rds("data/substance_use_regions.rds")

sanitation_regions <- read_rds("data/sanitation_regions.rds")


# Define choices & random selection for regions lineplots ----------------------

# air pollution
regions_choices_air_pollution <- air_pollution_regions %>%
  distinct(entity) %>%
  arrange(entity) %>%
  pull(entity)

# substance
regions_choices_substance <- substance_use_regions %>%
  distinct(entity) %>%
  arrange(entity) %>%
  pull(entity)

# sanitation
regions_choices_sanitation <- sanitation_regions %>%
  distinct(entity) %>%
  arrange(entity) %>%
  pull(entity)

# Make Manual Okabe-Ito Palette for Line Plot ----------------------------------

cbPalette <- c("#0072B2", "#D55E00", "#CC79A7")

# we chose to do this manually because the colorblindr package was not loading

# Define UI --------------------------------------------------------------------

ui <- fluidPage(

  # set theme for shiny app
  theme = shinytheme("cosmo"),

  # make title for shiny app
  titlePanel(strong("Global Deaths by Risk Factors")),

  # air pollution tab set up
  tabsetPanel(
    tabPanel(
      "Air Pollution",
      sidebarLayout(
        sidebarPanel(
          # select input for map
          selectInput(
            inputId = "air_pollution_type",
            label = "Select Type of Air Pollution for Map",
            choices = c(
              "Household Pollution Death Rate" =
                "death_rate_household_pollution",
              "Ambient Matter Pollution Death Rate" =
                "death_rate_ambient_matter_pollution",
              "Ozone Pollution Death Rate" =
                "death_rate_ozone_pollution",
              "Air Pollution Death Rate (Total)" =
                "death_rate_air_pollution"
            )
          ),
          # adding line breaks so side bar aligns with plots
          br(), br(), br(), br(), br(), br(), br(), br(), br(), br(),
          br(), br(), br(), br(), br(), br(), br(), br(), br(), br(),
          br(), br(), br(), br(), br(), br(), br(), br(), br(), br(),
          # select input for line plot
          selectInput(
            inputId = "air_pollution_line",
            label = "Select Type of Air Pollution for Line Plot",
            choices = c(
              "Air Pollution" = "air_pollution",
              "Outdoor Air Pollution" = "outdoor_air_pollution"
            )
          ),
          # check box input for regions on line plot
          checkboxGroupInput(
            inputId = "entity_air",
            label = "Select Up to 3 Regions for Line Plot",
            choices = regions_choices_substance
          ),
          # adding data source and hyperlink to write up
          p("Data Source: Our World in Data"),
          a(
            href = "https://vizdata-f21.github.io/project-2-tidy_team/",
            "Click Here to View Write Up"
          )
        ),

        # user interface for main panel
        mainPanel(
          fluidPage(
            verticalLayout(
              # title and subtitle for map plot
              h3(strong("Death Rate of Selected Air Pollution Type by Country",
                align = "left"
              )),
              h4("As measured by the number of deaths per 100,000 people (Age-standardized)",
                align = "left"
              ),

              # bsTooltip allows us to have alt text appear below the plot when a user hovers
              bsTooltip(
                id = "plot_air", title = "The figure is a world map visualization titled \\'Death Rate of Selected Air Pollution Type by Country\\' that displays the death rate, as measured by the number of deaths per a 100,000 person age standardized population, due to the selected air pollution type. The four possible air pollution types  that can be selected are \\’Household Pollution Death Rate,\\’ \\’Ambient Matter Pollution Death Rate,\\’ and \\’Ozone Pollution Death Rate,\\’ \\’Air Pollution Death Rate (Total).\\’ Each country on the map is assigned a color on a gradient scale based on the value of the death rate. The user can view the exact death rate for a specific country by hovering over the country of interest. Moreover, the user can use a timeline slider below the map to select a year of interest in order to see what the death rate is in that year. The range of years is is every yearsfrom 1990 to 2015. For more details on specific trends observed from the map over time, please see the analysis section of the write up.",
                placement = "bottom",
                trigger = "hover",
                options = NULL
              ),
              plotlyOutput(
                outputId = "plot_air",
                height = "600px"
              ),
              h3(strong("Number of Deaths from Selected Air Pollution Type by Region",
                align = "left"
              )),
              h4("As measured by the raw number of deaths",
                align = "left"
              ),
              bsTooltip(
                id = "plot_air_pollution_line", title = "The figure is a line chart titled \\'Number of Deaths from Selected Air Pollution Type by Region\\' that displays the raw number of death due to the selected air pollution type by region of the world over time. The two possible types of air pollution that can be selected are \\’Air Pollution\\’ and \\’Outdoor Air Pollution.\\’ The range of years is is every year from 1990 to 2015. The user can select up to 3 regions, each of which is its own line, to compare from, including \\'Central Asia,\\' \\'Central Europe,\\' \\'Central Latin America,\\' \\'Central Sub-Saharan Africa,\\' \\'Eastern Europe,\\' \\'Eastern Sub-Saharan Africa,\\'“ \\'Latin America and Caribbean,\\' \\'North Africa and Middle East,\\' \\'North America,\\' \\'South Asia,\\' \\'Southeast Asia,\\' \\'Southern Latin America,\\' \\'Southern Sub-Saharan Africa,\\' \\'Sub-Saharan Africa,\\' \\'Tropical Latin America,\\' \\'Western Europe,\\' and \\'Western Sub-Saharan Africa.\\'",
                placement = "bottom",
                trigger = "hover",
                options = NULL
              ),
              plotOutput(outputId = "plot_air_pollution_line")
            )
          )
        )
      )
    ),

    # substance tab
    tabPanel(
      "Substance Use",
      sidebarLayout(
        sidebarPanel(
          selectInput(
            inputId = "risk_factor_substance_map",
            label = "Select Type of Substance for Map",
            choices = c(
              "Secondhand Smoking" = "secondhand_smoke_rate",
              "Alcohol Use" = "alcohol_use_rate",
              "Drug Use" = "drug_use_rate",
              "Smoking" = "smoking_rate"
            )
          ),
          br(), br(), br(), br(), br(), br(), br(), br(), br(), br(),
          br(), br(), br(), br(), br(), br(), br(), br(), br(), br(),
          br(), br(), br(), br(), br(), br(), br(), br(), br(), br(),
          selectInput(
            inputId = "risk_factor_substance_line",
            label = "Select Type of Substance for Line Plot",
            choices = c(
              "Secondhand Smoking" = "secondhand_smoke",
              "Alcohol Use" = "alcohol_use",
              "Drug Use" = "drug_use",
              "Smoking" = "smoking"
            )
          ),
          checkboxGroupInput(
            inputId = "entity_sub",
            label = "Select Up to 3 Regions for Line Plot",
            choices = regions_choices_substance
          ),
          p("Data Source: Our World in Data"),
          a(
            href = "https://vizdata-f21.github.io/project-2-tidy_team/",
            "Click Here to View Write Up"
          )
        ),
        mainPanel(fluidPage(
          verticalLayout(
            h3(strong("Death Rate of Selected Substance Type by Country",
              align = "left"
            )),
            h4("As measured by the number of deaths per 100,000 people",
              align = "left"
            ),
            bsTooltip(
              id = "plot_substance", title = "The figure is a world map visualization titled \\'Death Rate of Selected Substance Type by Country\\' that displays the death rate, as measured by the number of deaths per 100,000 people, due to the selected type of substance issue. The four possible types of substances that can be selected are \\'Secondhand Smoking,\\' \\'Alcohol Use,\\' \\'Drug Use,\\' and \\'Smoking.\\' Each country on the map is assigned a color on a gradient scale based on the value of the death rate. The user can view the exact death rate for a specific country by hovering over the country of interest. Moreover, the user can use a timeline slider below the map to select a year of interest in order to see what the death rate is in that year. The range of years is is every three years from 1990 to 2015. For more details on specific trends observed from the map over time, please see the analysis section of the write up.",
              placement = "bottom",
              trigger = "hover",
              options = NULL
            ),
            plotlyOutput(
              outputId = "plot_substance",
              height = "600px"
            ),
            h3(strong("Number of Deaths from Selected Substance Type by Region",
              align = "left"
            )),
            h4("As measured by the raw number of deaths",
              align = "left"
            ),
            bsTooltip(
              id = "plot_substance_line", title = "The figure is a line chart titled \\'Number of Deaths from Selected Substance Type by Region\\' that displays the raw number of death due to the selected substance type by region of the world over time. The four possible types of substances that can be selected are \\'Secondhand Smoking,\\' \\'Alcohol Use,\\' \\'Drug Use,\\' and \\'Smoking.\\' The range of years is is every year from 1990 to 2015. The user can select up to 3 regions, each of which is its own line, to compare from, including \\'Central Asia,\\' \\'Central Europe,\\' \\'Central Latin America,\\' \\'Central Sub-Saharan Africa,\\' \\'Eastern Europe,\\' \\'Eastern Sub-Saharan Africa,\\'“ \\'Latin America and Caribbean,\\' \\'North Africa and Middle East,\\' \\'North America,\\' \\'South Asia,\\' \\'Southeast Asia,\\' \\'Southern Latin America,\\' \\'Southern Sub-Saharan Africa,\\' \\'Sub-Saharan Africa,\\' \\'Tropical Latin America,\\' \\'Western Europe,\\' and \\'Western Sub-Saharan Africa.\\'",
              placement = "bottom",
              trigger = "hover",
              options = NULL
            ),
            plotOutput(outputId = "plot_substance_line")
          )
        ))
      )
    ),

    # sanitation tab
    tabPanel(
      "Sanitation",
      sidebarLayout(
        sidebarPanel(
          selectInput(
            inputId = "risk_factor_sanitation_map",
            label = "Select Type of Sanitation Issue for Map",
            choices = c(
              "Unsafe Water Source" = "unsafe_water_source_rate",
              "Unsafe Sanitation" = "unsafe_sanitation_rate",
              "No Hand Wash" =
                "no_access_to_handwashing_facility_rate"
            )
          ),
          br(), br(), br(), br(), br(), br(), br(), br(), br(), br(),
          br(), br(), br(), br(), br(), br(), br(), br(), br(), br(),
          br(), br(), br(), br(), br(), br(), br(), br(), br(), br(),
          selectInput(
            inputId = "risk_factor_sanitation_line",
            label = "Select Type of Sanitation Issue for Line Plot",
            choices = c(
              "Unsafe Water Source" = "unsafe_water_source",
              "Unsafe Sanitation" = "unsafe_sanitation",
              "No Hand Wash" =
                "no_access_to_handwashing_facility"
            )
          ),
          checkboxGroupInput(
            inputId = "entity_san",
            label = "Select Up to 3 Regions for Line Plot",
            choices = regions_choices_sanitation
          ),
          p("Data Source: Our World in Data"),
          a(
            href = "https://vizdata-f21.github.io/project-2-tidy_team/",
            "Click Here to View Write Up"
          )
        ),
        mainPanel(fluidPage(
          verticalLayout(
            h3(strong("Death Rate of Selected Sanitation Issue by Country",
              align = "left"
            )),
            h4("As measured by the number of deaths per 100,000 people",
              align = "left"
            ),
            bsTooltip(
              id = "plot_sanitation", title = "The figure is a world map visualization titled \\'Death Rate of Selected Sanitation Issue by Country\\' that displays the death rate, as measured by the number of deaths per 100,000 people, due to the selected sanitation issue. The three possible sanitation issues that can be selected are \\'Unsafe Water Source,\\' \\'Unsafe Sanitation,\\' and \\'No Hand Wash.\\' Each country on the map is assigned a color on a gradient scale based on the value of the death rate. The user can view the exact death rate for a specific country by hovering over the country of interest. Moreover, the user can use a timeline slider below the map to select a year of interest in order to see what the death rate is in that year. The range of years is is every three years from 1990 to 2015. For more details on specific trends observed from the map over time, please see the analysis section of the write up.",
              placement = "bottom",
              trigger = "hover",
              options = NULL
            ),
            plotlyOutput(
              outputId = "plot_sanitation",
              height = "600px"
            ),
            h3(strong("Number of Deaths from Selected Sanitation Issue by Region",
              align = "left"
            )),
            h4("As measured by the raw number of deaths",
              align = "left"
            ),
            bsTooltip("plot_sanitation_line", "The figure is a line chart titled \\'Number of Deaths from Selected Sanitation Issue by Region\\' that displays the raw number of death due to the selected sanitation issue by region of the world over time. The three possible sanitation issues that can be selected are \\'Unsafe Water Source,\\' \\'Unsafe Sanitation,\\' and \\'No Hand Wash.\\' The range of years is is every year from 1990 to 2015. The user can select up to 3 regions, each of which is its own line, to compare from, including \\'Central Asia,\\' \\'Central Europe,\\' \\'Central Latin America,\\' \\'Central Sub-Saharan Africa,\\' \\'Eastern Europe,\\' \\'Eastern Sub-Saharan Africa,\\'“ \\'Latin America and Caribbean,\\' \\'North Africa and Middle East,\\' \\'North America,\\' \\'South Asia,\\' \\'Southeast Asia,\\' \\'Southern Latin America,\\' \\'Southern Sub-Saharan Africa,\\' \\'Sub-Saharan Africa,\\' \\'Tropical Latin America,\\' \\'Western Europe,\\' and \\'Western Sub-Saharan Africa.\\'",
              placement = "bottom",
              trigger = "hover",
              options = NULL
            ),
            plotOutput(outputId = "plot_sanitation_line")
          )
        ))
      )
    )
  )
)


# Define Server ----------------------------------------------------------------
server <- function(input, output) {

  # air pollution map
  output$plot_air <- renderPlotly({
    air_plotly <- (total_joined %>%
      ggplot(aes(long, lat)) +
      geom_polygon(
        aes_string(
          group = "group",
          fill = input$air_pollution_type,
          label = "region",
          frame = "year"
        ),
        color = "white",
        size = 0.1
      ) +
      coord_map(
        projection = "mercator",
        xlim = c(-180, 180),
        clip = "off"
      ) +
      scale_fill_viridis_c(
        limits = c(0, 350),
        begin = 0.3,
        option = "turbo",
        # turbo pallet coordinates with AQI colors
        name = "Death Rate",
        labels = scales::comma,
        na.value = "lightgray"
      ) +
      theme_void() +
      theme(
        text = element_text(color = "black"),
        legend.direction = "vertical",
        legend.position = "left",
        legend.key.height = unit(2, "cm"),
        plot.background = element_rect(
          fill = "white",
          color = "white"
        )
      ))

    ggplotly(
      p = air_plotly,
      width = 900,
      height = 600
    ) %>%
      animation_opts(frame = 9) %>%
      # removing axis lines
      layout(
        yaxis = list(showline = F),
        xaxis = list(showline = F)
      ) %>%
      # remove plotly logo
      config(displaylogo = FALSE)
  })


  # interactivity for air pollution line plot

  output$selected_regions_air <- reactive({
    paste("You've selected", length(input$entity_air), "regions.")
  })

  air_pollution_regions_filtered <- reactive({
    air_pollution_regions %>%
      filter(entity %in% input$entity_air)
  })

  # air pollution line plot

  output$plot_air_pollution_line <- renderPlot({
    validate(
      need(
        length(input$entity_air) <= 3,
        "Please select a maximum of 3 regions."
      )
    )
    ggplot(
      data = air_pollution_regions_filtered(),
      aes_string(
        x = "year",
        y = input$air_pollution_line,
        group = "entity",
        color = "entity"
      )
    ) +
      geom_line(size = 1) +
      theme_minimal(base_size = 16) +
      theme(
        legend.position = "bottom",
        aspect.ratio = 0.4,
        axis.ticks.x = element_blank(),
        axis.ticks.y = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        text = element_text(family = "sans")
      ) +
      scale_y_continuous(labels = comma) +
      scale_x_continuous(
        breaks = seq(from = 1990, to = 2017, by = 3),
        limits = c(1990, 2017),
        expand = c(0, 0)
      ) +
      scale_color_manual(values = cbPalette) +
      labs(
        x = "Year",
        y = "Number of Deaths",
        color = "Regions",
        title = paste("Selected:", input$air_pollution_line)
      )
  })


  # substance
  output$plot_substance <- renderPlotly({
    substance_plotly <- (total_joined %>%
      ggplot(aes(long, lat)) +
      geom_polygon(
        aes_string(
          group = "group",
          fill = input$risk_factor_substance_map,
          label = "region",
          frame = "year"
        ),
        color = "white",
        size = 0.1
      ) +
      coord_map(
        projection = "mercator",
        xlim = c(-180, 180),
        clip = "off"
      ) +
      scale_fill_viridis_c(
        trans = "log10",
        option = "inferno",
        direction = -1,
        begin = 0.2,
        end = 0.9,
        name = "Log of Death Rate",
        labels = label_number(big.mark = ","),
        na.value = "lightgray"
      ) +
      theme_void() +
      theme(
        text = element_text(color = "black"),
        legend.direction = "vertical",
        legend.position = "left",
        legend.key.height = unit(2, "cm"),
        plot.background = element_rect(
          fill = "white",
          color = "white"
        ),
        plot.title = element_blank(),
        plot.subtitle = element_blank()
      ))

    ggplotly(
      p = substance_plotly,
      width = 900,
      height = 600
    ) %>%
      animation_opts(frame = 9) %>%
      layout(
        yaxis = list(showline = F),
        xaxis = list(showline = F)
      ) %>% # removing axis lines: https://plotly.com/r/axes/
      config(displaylogo = FALSE) # remove plotly logo https://cran.r-project.org/web/packages/plotly/plotly.pdf
  })

  # interactivity for substance line plot

  output$selected_regions_sub <- reactive({
    paste("You've selected", length(input$entity_sub), "regions.")
  })

  substance_use_regions_filtered <- reactive({
    substance_use_regions %>%
      filter(entity %in% input$entity_sub)
  })

  # substance line plot

  output$plot_substance_line <- renderPlot({
    validate(
      need(
        length(input$entity_sub) <= 3,
        "Please select a maximum of 3 regions."
      )
    )
    ggplot(
      data = substance_use_regions_filtered(),
      aes_string(
        x = "year",
        y = input$risk_factor_substance_line,
        group = "entity",
        color = "entity"
      )
    ) +
      geom_line(size = 1) +
      theme_minimal(base_size = 16) +
      theme(
        legend.position = "bottom",
        aspect.ratio = 0.4,
        axis.ticks.x = element_blank(),
        axis.ticks.y = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        text = element_text(family = "sans")
      ) +
      scale_y_continuous(labels = comma) +
      scale_x_continuous(
        breaks = seq(from = 1990, to = 2017, by = 3),
        limits = c(1990, 2017),
        expand = c(0, 0)
      ) +
      scale_color_manual(values = cbPalette) +
      labs(
        x = "Year",
        y = "Number of Deaths",
        color = "Regions",
        title = paste("Selected:", input$risk_factor_substance_line)
      )
  })


  # sanitation map
  output$plot_sanitation <- renderPlotly({
    sanitation_plotly <- (total_joined %>%
      ggplot(aes(long, lat)) +
      geom_polygon(
        aes_string(
          group = "group",
          fill = input$risk_factor_sanitation_map,
          label = "region",
          frame = "year"
        ),
        color = "white",
        size = 0.1
      ) +
      coord_map(
        projection = "mercator",
        xlim = c(-180, 180),
        clip = "off"
      ) +
      scale_fill_viridis_c(
        trans = "log10",
        option = "magma",
        direction = -1,
        end = 0.9,
        name = "Log of Death Rate",
        labels = label_number(big.mark = ","),
        na.value = "lightgray"
      ) +
      theme_void() +
      theme(
        text = element_text(color = "black"),
        legend.direction = "vertical",
        legend.position = "left",
        legend.key.height = unit(2, "cm"),
        plot.background = element_rect(
          fill = "white",
          color = "white"
        ),
        plot.title = element_blank(),
        plot.subtitle = element_blank()
      ))

    ggplotly(
      p = sanitation_plotly,
      width = 900,
      height = 600
    ) %>%
      animation_opts(frame = 9) %>%
      layout(
        yaxis = list(showline = F),
        xaxis = list(showline = F)
      ) %>% # removing axis lines: https://plotly.com/r/axes/
      config(displaylogo = FALSE) # remove plotly logo https://cran.r-project.org/web/packages/plotly/plotly.pdf
  })

  # sanitation line plot

  # interactivity for sanitation line plot
  output$selected_regions_san <- reactive({
    paste("You've selected", length(input$entity_san), "regions.")
  })

  sanitation_regions_filtered <- ({
    reactive({
      sanitation_regions %>%
        filter(entity %in% input$entity_san)
    })
  })

  output$plot_sanitation_line <- renderPlot({
    validate(
      need(
        length(input$entity_san) <= 3,
        "Please select a maxiumum of 3 regions"
      )
    )
    ggplot(data = sanitation_regions_filtered()) +
      geom_line(aes_string(
        group = "entity",
        color = "entity",
        x = "year",
        y = input$risk_factor_sanitation_line
      ), size = 1) +
      theme_minimal(base_size = 16) +
      theme(
        legend.position = "bottom",
        aspect.ratio = 0.4,
        axis.ticks.x = element_blank(),
        axis.ticks.y = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        text = element_text(family = "sans")
      ) +
      scale_y_continuous(labels = comma) +
      scale_x_continuous(
        breaks = seq(from = 1990, to = 2017, by = 3),
        limits = c(1990, 2017)
      ) +
      scale_color_manual(values = cbPalette) +
      labs(
        x = "Year",
        y = "Number of Deaths",
        color = "Regions",
        title = paste("Selected:", input$risk_factor_sanitation_line)
      )
  })
}


# Run the application ----------------------------------------------------------
shinyApp(ui = ui, server = server)
