
library(shiny)
library(tidyverse)
library(scales)


regions_choices <- substance_use_regions %>%
    distinct(entity) %>%
    arrange(entity) %>%
    pull(entity)

selected_regions_choices <- sample(regions_choices, 3)

# Define UI for application that draws a histogram
ui <- fluidPage(

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

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("substance_plot")
        )
    )
)

# Define server logic required to draw a histogram
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
                                 y = input$risk_factor)) +
            theme_minimal() +
            theme(legend.position = "bottom") +
            scale_y_continuous(labels = comma) +
            labs(
                x = "Year",
                y = "Number of Deaths",
                color = "Regions",
                title = "Number of Deaths by [Risk Factor]")
    })
}

# Run the application
shinyApp(ui = ui, server = server)
