# Load required libraries
library(shiny)
library(ggplot2)
library(dplyr)
library(arules)
library(reader)

# Define UI
ui <- fluidPage(
  titlePanel("Data Analysis Tool"),
  sidebarLayout(
    sidebarPanel(
      fileInput("dataset_path", "Choose CSV File"),
      actionButton("clean", "Clean Data"),
      actionButton("data_cleaned_summary", "Data cleaned summary"),
      actionButton("visualize", "Visualize"),      
      numericInput("clusters", "Number of Clusters (2-4):", min = 2, max = 4, value = 2),
      actionButton("cluster", "Cluster"),
      numericInput("min_support", "Enter minimum support (between 0.001 and 1):", min = .001, max = 1, value = .001),
      numericInput("min_confidence", "Enter minimum confidence (between 0.001 and 1):", min = .001, max = 1, value = .001),
      actionButton("mine_rules", "Mine Association Rules")      
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Cleaned Data", dataTableOutput("cleaned_data")),
        tabPanel("Data cleaned Summary", dataTableOutput("summary")),
        tabPanel("Visualizations", 
                 fluidRow(
                   column(6, plotOutput("plot1")),
                   column(6, plotOutput("plot2")),
                   column(6, plotOutput("plot3")),
                   column(6, plotOutput("plot4")))
        ),
        tabPanel("Clustering",dataTableOutput("cluster_summary_table")),
        tabPanel("Association Rules",dataTableOutput("association_rules"))
      )
    )
  )
)

# Define server
server <- function(input, output) {
  data_cleaned <- reactiveVal(NULL)  # Reactive conductor to store the cleaned data
  
  observeEvent(input$dataset_path, {
    req(input$dataset_path)
    data_cleaned_val <- read.csv(input$dataset_path$datapath)
    data_cleaned_val <- na.omit(data_cleaned_val)  # Remove rows with missing values
    data_cleaned_val <- distinct(data_cleaned_val)  # Remove duplicate rows
    data_cleaned(data_cleaned_val)
  })
  
  output$cleaned_data <- renderDataTable({
    req(input$clean)
    data_cleaned()
  })
  
  output$summary <- renderDataTable({
    req(input$clean)
    summary(data_cleaned())
  })
  
  observeEvent(input$visualize, {
    req(data_cleaned())
    comparison <- table(data_cleaned()$paymentType)
    percent <- round(100 * comparison / sum(comparison), 1) # Round to 1 decimal place
    
    summarized_data <- data_cleaned() %>%
      group_by(age) %>%
      summarize(total = sum(total))
    
    summarized <- data_cleaned() %>%
      group_by(city) %>%
      summarize(total = sum(total)) %>%
      arrange(desc(total))
    
    # Format percentage to display one digit after the decimal point
    percent_labels <- paste0(names(comparison), ": ", sprintf("%.1f", percent), "%")
    
    # Plot 1: Pie chart
    output$plot1 <- renderPlot({
      pie(comparison, labels = percent_labels, col = c("skyblue", "pink"), main = "Payment Type Distribution")
      legend("bottomright", legend = names(comparison), fill = c("skyblue", "pink"))
    })
    
    # Plot 2: Scatter plot
    output$plot2 <- renderPlot({
      ggplot(data = summarized_data, aes(x = age, y = total)) +
        geom_point(color = "navy") +
        labs(title = "Compare each age and sum of total spending", x = "Age", y = "Total Spending")
    })
    
    # Plot 3: Bar plot
    output$plot3 <- renderPlot({
      barplot(summarized$total, names.arg = summarized$city, 
              main = "City Total Spending", xlab = "City", ylab = "Total Spending", col = c("skyblue", "pink"))
    })
    
    # Plot 4: Box plot
    output$plot4 <- renderPlot({
      boxplot(data_cleaned()$total, main = "Distribution of Total Spending", xlab = "Total", col = c("skyblue", "pink"))
    })
  })
  
  observeEvent(input$cluster, {
    req(data_cleaned())
    my_data <- data_cleaned()  # Retrieve the cleaned data
    kmeans_model <- kmeans(my_data[, c("age", "total")], centers = input$clusters)
    df <- data.frame(
      customer = my_data$customer,
      age = my_data$age,
      total = my_data$total,
      cluster = kmeans_model$cluster
    )
    
    output$cluster_summary_table <- renderDataTable({
      summary <- df %>%
        group_by(customer) %>%
        summarize(
          age = mean(age),
          total = sum(total),
          cluster = first(cluster)
        )
      summary
    })
  })
  
  output$association_rules <- renderDataTable({
    req(input$mine_rules)
    req(data())
    # Extract items as a list for each transaction
    transactions <- strsplit(as.character(data_cleaned()$items), ",")
    # Mine association rules
    rules <- apriori(transactions, parameter = list(support = input$min_support, confidence = input$min_confidence), minlen = 2)
    # Convert rules object to data frame
    rules_df <- as(rules, "data.frame")
    # Output the rules data frame
    return(rules_df)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
