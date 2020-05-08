# Load packages
library(shiny)
library(shinythemes)
library(dplyr)
library(readxl)

# Load data
Inoc.data <- read_xlsx("C:\\Users\\dixie\\Documents\\GitHub\\TidyTuesday_BPP\\2020_05_12\\submissions\\Hazel", sheet=1)
Inoc.data$Log_ID <- as.factor(Inoc.data$Log_ID)

# Define UI
ui <- fluidPage(theme = shinytheme("readable"),
                titlePanel("Artificial Inoculation Trends"),
                sidebarLayout(
                  sidebarPanel(
                    
                    # Select type of trend to plot
                    selectInput(inputId = "Species", label = strong("Host Species"),
                                choices = unique(Inoc.data$Species),
                                selected = "Nden")
                    ),
                  
                  # Output: Description, lineplot, and reference
                  mainPanel(
                    plotOutput(outputId = "lineplot", height = "300px"),
                    textOutput(outputId = "desc")
                  )
                )
)

# Define server function
server <- function(input, output) {
  # Subset data
  selected_trends <- reactive({
    req(input$Species)
    Inoc.data %>%
      filter(
        Species == input$Species
        )
  })
  # Create scatterplot object the plotOutput function is expecting
  output$lineplot <- renderPlot({
    color = "#434343"
    par(mar = c(4, 4, 1, 1))
    plot(x = selected_trends()$Log_ID, y = selected_trends()$Inoc_1_avg,
         xlab = "Log ID tag", ylab = "Lesion Length (cm)", col = color, fg = color, col.lab = color, col.axis = color)
  })
}

# Create Shiny object
shinyApp(ui = ui, server = server)