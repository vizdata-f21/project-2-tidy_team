
library(shiny)
library(shinythemes)
library(tidyverse)
library(scales)

# defining choices & random selection
regions_choices <- substance_use_regions %>%
    distinct(entity) %>%
    arrange(entity) %>%
    pull(entity)

selected_regions_choices <- sample(regions_choices, 3)

# Define UI -----------------------------------------------------------
ui <- fluidPage(
    theme = shinytheme("cosmo"),

    # Application title
    titlePanel("LinePlotTest"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            checkboxGroupInput(inputId = "entity",
                                label = "Select up to 8 regions:",
                                choices = regions_choices,
                                selected = selected_regions_choices),
            selectInput(
                inputId = "risk_factor",
                label = "Risk Factor",
                choices = c(
                    "Second Hand Smoke" = "secondhand_smoke",
                    "Alcohol Use" = "alcohol_use",
                    "Drug Use" = "drug_use",
                    "Smoking" = "smoking"
                )
            )
        ),
        mainPanel(
           plotOutput("substance_plot")
        )
    )
)

# Define server------------------------------------------------------
server <- function(input, output, session) {

    output$selected_regions <- reactive({
        paste("You've selected", length(input$entity), "regions.")
    })

    substance_use_regions_filtered <- reactive({
        substance_use_regions %>%
            filter(entity %in% input$entity)
    })

    output$substance_plot <- renderPlot({

        validate(
            need(length(input$entity) <= 8, "Please select a maxiumum of 8 regions")
        )

        ggplot(data = substance_use_regions_filtered()) +
            geom_line(aes_string(group = "entity",
                                 color = "entity",
                                 x = "year",
                                 y = input$risk_factor), size = 1) +
            theme_gray(base_size = 16) +
            theme(legend.position = "bottom",
                  panel.grid.minor.x = element_blank()) +
            scale_y_continuous(labels = comma) +
            scale_x_continuous(breaks = seq(from = 1990, to = 2017, by = 3),
                                 limits = c(1990, 2017)) +
            scale_color_viridis_d(option = "inferno", begin = 0.1) +
            labs(
                x = "Year",
                y = "Number of Deaths",
                color = "Regions",
                title = paste("Number of Deaths by", input$risk_factor))
    })
}

# Run the application--------------------------------------
shinyApp(ui = ui, server = server)
