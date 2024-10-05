#Setting the working directory    
setwd("C:\\Users\\Administrator\\Desktop\\Hackbio Cancer Internship")
getwd()

#Loading the readr library
library(readr)

#Reading the dataset
amr_data<-read_tsv("wHO_AMR_PRODUCTS_DATA.tsv")

# Load ggplot
library(ggplot2)
#Pie Chart
# Create a data frame with counts of each product type
product_types <- as.data.frame(table(amr_data$`Product type`))

# Calculate the percentage for each product type
product_types$Percentage <- round((product_types$Freq / sum(product_types$Freq)) * 100, 1)

# Create labels with both product type and percentage
product_types$Label <- paste(product_types$Var1, "(", product_types$Percentage, "%)", sep = "")

# Plot the pie chart
ggplot(product_types, aes(x = "", y = Freq, fill = Var1)) +
  geom_bar(width = 1, stat = "identity") +
  coord_polar("y") +
  labs(title = "Proportion of Product Types", fill = "Product Type") +
  theme_void() +  # Removes unnecessary background elements for a cleaner pie chart
  geom_text(aes(label = Label), position = position_stack(vjust = 0.5))  # Add percentage labels


#Stacked Bar Chart
#Load dplyr
library(dplyr)
# Summarizing products by R&D phase
phase_data <- amr_data %>%
  group_by(`R&D phase`) %>%
  summarise(Num_Products = n())

# Creating bar plot
ggplot(phase_data, aes(x = reorder(`R&D phase`, Num_Products), y = Num_Products)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() +
  labs(title = "Number of Products by R&D Phase",
       x = "R&D Phase", y = "Number of Products") +
  theme_minimal()

# Data Cleaning: Remove rows with missing Developer values
cleaned_data <- amr_data %>%
  filter(!is.na(Developer))

# Summarize the number of products by developer
developer_counts <- cleaned_data %>%
  group_by(Developer) %>%
  summarise(product_count = n()) %>%
  arrange(desc(product_count)) %>%
  slice(1:10) # Select top 10 developers

# Plot the top 10 developers by number of products
ggplot(developer_counts, aes(x = reorder(Developer, -product_count), y = product_count)) +
  geom_bar(stat = "identity", fill = "mediumpurple") +
  coord_flip() + # Flip coordinates to make the bar chart horizontal
  labs(title = "Top 10 Developers Contributing to AMR Products", x = "Developer", y = "Number of Products") +
  theme_minimal()

#Bar Plot Showing no.of products by pathogen category and R&D Phase
# Create the counts data frame
pathogen_rd_phase_counts <- amr_data %>%
  group_by(`Pathogen category`, `R&D phase`) %>%
  summarize(count = n(), .groups = 'drop')

# Create a faceted bar plot
ggplot(pathogen_rd_phase_counts, aes(x = reorder(`Pathogen category`, count), y = count, fill = `Pathogen category`)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = count), vjust = -0.5, color = "black") +  # Add counts on bars
  facet_wrap(~ `R&D phase`) +  # Create separate plots for each R&D phase
  coord_flip() +  # Flip coordinates for better readability
  theme_minimal() +
  labs(title = "Number of Products by Pathogen Category and R&D Phase",
       x = "Pathogen Category",
       y = "Number of Products") +
  theme(legend.title = element_blank())  # Remove legend title


#Barplot showing innovation status of products
# Load necessary libraries
library(ggplot2)
library(dplyr)

# Filter out rows where 'Innovative?' is NA
cleaned_amr_data <- amr_data %>%
  filter(!is.na(`Innovative?`))

# Create a summarized dataset showing counts of innovative and non-innovative products
innovation_summary <- cleaned_amr_data %>%
  group_by(`Innovative?`) %>%
  summarise(Count = n())

# Create a bar plot to show the innovation status of products with count labels inside the bars
ggplot(innovation_summary, aes(x = `Innovative?`, y = Count, fill = `Innovative?`)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = Count), vjust = -0.5, size = 5) +  # Add count labels
  labs(title = "Innovation Status of Products", x = "Innovative?", y = "Number of Products") +
  theme_minimal() +
  theme(legend.position = "none")  # Remove legend since it's redundant with the x-axis


install.packages("shiny")

##create donut charts for Innovative. , NCE. and route of administration with the percentage labels outside the slices of the donuts
# Install and load necessary packages
library(shiny)
library(ggplot2)
library(dplyr)
library(ggrepel)

# create data frame

WHO_AMR_PRODUCTS_DATA.tsv <- data.frame(
  Innovative = sample(c("Yes", "No"), 100, replace = TRUE),
  NCE = sample(c("Yes", "No"), 100, replace = TRUE),
  Route.of.administration = sample(c("Oral", "IV", "Topical", "Inhalation"), 100, replace = TRUE)
)

# Summarize data for the donut charts
innovative_data <- WHO_AMR_PRODUCTS_DATA.tsv %>%
  count(Innovative)

nce_data <- WHO_AMR_PRODUCTS_DATA.tsv %>%
  count(NCE)

route_data <- WHO_AMR_PRODUCTS_DATA.tsv %>%
  count(Route.of.administration)

# Function to create a donut chart with labels outside the slices
create_donut_chart <- function(data, column, title) {
  
  # Calculate the positions for the labels
  data <- data %>%
    mutate(percentage = n / sum(n) * 100,
           ypos = cumsum(percentage) - 0.5 * percentage)  # Position for labels
  
  ggplot(data, aes(x = 2, y = n, fill = !!sym(column))) +
    geom_bar(width = 1, stat = "identity") +
    coord_polar("y", start = 0) +
    xlim(0.5, 2.5) +  # Adjust the x-limits to make space for labels
    theme_void() +
    labs(fill = column, title = title) +
    theme(legend.position = "bottom") +
    # Use geom_label_repel to place labels outside
    geom_label_repel(aes(y = ypos, label = paste0(round(percentage, 1), "%")),
                     size = 4, nudge_x = 0.5, show.legend = FALSE)
}

# Define the UI
ui <- fluidPage(
  titlePanel("Product Dashboard: Donut Charts"),
  fluidRow(
    column(4, plotOutput("innovative_chart")),
    column(4, plotOutput("nce_chart")),
    column(4, plotOutput("route_chart"))
  )
)

# Define the server logic
server <- function(input, output) {
  
  # Donut chart for Innovative column
  output$innovative_chart <- renderPlot({
    create_donut_chart(innovative_data, "Innovative", "Innovative Products")
  })
  
  # Donut chart for NCE column
  output$nce_chart <- renderPlot({
    create_donut_chart(nce_data, "NCE", "New Chemical Entities (NCE)")
  })
  
  # Donut chart for Route of Administration column
  output$route_chart <- renderPlot({
    create_donut_chart(route_data, "Route.of.administration", "Route of Administration")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)


#Creating bar plots for critical priority pathogens and other priority pathogens for expected activity against priority pathogens 
#Creating the tables
# Creating the tables for critical priority pathogens
critical_pathogens <- amr_data %>%
  filter(`Pathogen activity` == "Critical priority pathogens") %>%
  group_by(`Pathogen name`, `Active against priority pathogens?`) %>%
  summarise(Count = n(), .groups = 'drop')

# Filter for Other Priority Pathogens
other_pathogens <- amr_data %>%
  filter(`Pathogen activity` == "Other priority pathogens") %>%
  group_by(`Pathogen name`, `Active against priority pathogens?`) %>%
  summarise(Count = n(), .groups = 'drop')
# Display the resulting tables
print("Critical Priority Pathogens Table:")
print(critical_pathogens)
# Creating bar plots for Critical Priority Pathogens
critical_plot <- ggplot(critical_pathogens, aes(x = `Pathogen name`, y = Count, fill = `Active against priority pathogens?`)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  labs(title = "Critical Priority Pathogens", x = "Pathogen Name", y = "Count") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Creating bar plots for Other Priority Pathogens
other_plot <- ggplot(other_pathogens, aes(x = `Pathogen name`, y = Count, fill = `Active against priority pathogens?`)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  labs(title = "Other Priority Pathogens", x = "Pathogen Name", y = "Count") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Printing the plots
print(critical_plot)
print(other_plot)

