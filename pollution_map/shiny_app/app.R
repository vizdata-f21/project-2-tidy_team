library(shiny)
library(tidyverse)
library(spData) # For getting spatial data
library(sf) # For preserving spatial data
library(leaflet) # For making maps
library(DT) # For making fancy tables

df = subset(total_joined, select = -c(long,lat,group,order,subregion,code))

df2<-df %>%
  pivot_longer(
    cols = -c(year,region),
    names_to = "pollution_type",
    values_to = "death_rate"
  )

mapData <- world[c(2,11)]

# Clean review data
df2<-df2 %>%
  drop_na(death_rate)
df2$death_rate <- as.numeric(as.character(df2$death_rate))

# Clean country data


# Define UI for application
ui <- fluidPage(

  # CSS
  tags$head(
    tags$style(HTML("
      body { background-color: #f2efe9; }
      .container-fluid { background-color: #fff; width: 1100px; padding: 60px; }
      .topimg { width: 120px; display: block; margin: 0px auto 40px auto; }
      .title { text-align: center; }
      .toprow { margin: 60px 0px; padding: 30px; background-color: #fae8bb; }
      .filters { margin: 0px auto; }
      .shiny-input-container { width:100% !important; }
      .table { padding: 30px; margin-top: 30px; }
      .leaflet-top { z-index:999 !important; }
      "))
  ),


  # Application title
  h1("Air Pollution Stats", class = "title"),

  fluidRow(class = "toprow",
           fluidRow (class = "filters",

                     column(6,
                            # Style Menu
                            selectInput("style", "Style", c("All",
                                                            "Bowl",
                                                            "Box",
                                                            "Cup",
                                                            "Pack",
                                                            "Tray"))
                     ),

                     column(6,
                            # Country menu
                            selectInput("country", "Country", levels(ratings$Country) %>%
                                          append("All") %>% # Add "All" option
                                          sort()) # Sort options alphabetically

                     )
           )
  ),

  fluidRow (

    column(6, class = "map",
           # Map
           leafletOutput("map")
    )

  )
)

# Define server logic
server <- function(input, output) {

  # Create world map
  output$map <- renderLeaflet({

    # Filter data based on selected Style
    if (input$style != "All") {
      ratings <- filter(ratings, Style == input$style)
    }

    # Filter data based on selected Country
    if (input$country != "All") {
      ratings <- filter(ratings, Country == input$country)
    }

    # Hide map when user has filtered out all data
    validate (
      need(nrow(ratings) > 0, "")
    )

    # Get average rating by country
    countries <- group_by(ratings, Country) %>%
      summarise(avgRating = mean(Stars))

    # Add spatial data to countries dataframe
    countries <- left_join(countries, mapData, c("Country" = "name_long"))

    # Create color palette for map
    pal <- colorNumeric(palette = "YlOrRd", domain = countries$avgRating)

    # Create label text for map
    map_labels <- paste("Ramen from",
                        countries$Country,
                        "has an average rating of",
                        round(countries$avgRating, 1))

    # Generate basemap
    map <- leaflet() %>%
      addTiles() %>%
      setView(0, 0, 1)

    # Add polygons to map
    map %>% addPolygons(data = countries$geom,
                        fillColor = pal(countries$avgRating),
                        fillOpacity = .7,
                        color = "grey",
                        weight = 1,
                        label = map_labels,
                        labelOptions = labelOptions(textsize = "12px")) %>%

      # Add legend to map
      addLegend(pal = pal,
                values = countries$avgRating,
                position = "bottomleft")

  })

  # Create data table
  output$table <- renderDataTable({

    # Filter data based on selected Style
    if (input$style != "All") {
      ratings <- filter(ratings, Style == input$style)
    }

    # Filter data based on selected Country
    if (input$country != "All") {
      ratings <- filter(ratings, Country == input$country)
    }

    # Hide table when user has filtered out all data
    validate (
      need(nrow(ratings) > 0, "")
    )

    ratings[,2:6]

  })

}

# Run the application
shinyApp(ui = ui, server = server)

