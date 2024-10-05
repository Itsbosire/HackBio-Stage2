# Implementation of AMR Products Data Visualization in R

This task focuses on visualizing data related to Antimicrobial Resistance (AMR) products using the WHO AMR Products dataset. The analysis includes data visualizations such as pie charts, bar charts, stacked bar charts, donut charts, and an interactive Shiny dashboard for visualizing key parameters of AMR products.

---

## Prerequisites

To run this code, ensure you have the following software and libraries installed:

1. **R**: The project requires R.
2. **RStudio**: A powerful IDE for R.
3. **Libraries**: Install the following R packages if they are not already installed:
   ```r
   install.packages(c("readr", "ggplot2", "dplyr", "ggrepel", "shiny"))
   ```

---

## Instructions for Implementation

1. **Download and Set Up the Dataset**

   Download the `WHO_AMR_PRODUCTS_DATA.tsv` dataset and save it in your working directory (e.g., `C:\\Users\\Administrator\\Desktop\\Hackbio Cancer Internship`). The code is set up to work with a tab-separated values (TSV) file.

   To verify that the file path is correct, run the following commands:

   ```r
   setwd("C:\\Users\\Administrator\\Desktop\\Hackbio Cancer Internship")  # Set the working directory
   getwd()  # Check the current working directory
   ```

2. **Load Required Libraries**

   The script uses multiple libraries for reading data and plotting graphs. Ensure these libraries are loaded:

   ```r
   library(readr)
   library(ggplot2)
   library(dplyr)
   library(ggrepel)
   library(shiny)
   ```

3. **Read the Dataset**

   To read the dataset, the script uses the `read_tsv` function from the `readr` package:

   ```r
   amr_data <- read_tsv("WHO_AMR_PRODUCTS_DATA.tsv")
   ```

---

## Visualizations

### 1. **Pie Chart for Product Types**

This visualization shows the proportion of product types in the dataset using a pie chart. It uses `ggplot2` to create a pie chart with percentage labels.

```r
ggplot(product_types, aes(x = "", y = Freq, fill = Var1)) +
  geom_bar(width = 1, stat = "identity") +
  coord_polar("y") +
  theme_void() +
  geom_text(aes(label = Label), position = position_stack(vjust = 0.5))
```

---

### 2. **Stacked Bar Chart for Products by R&D Phase**

This bar chart shows the number of products by R&D phase using `ggplot2` and data summarized by `dplyr`.

```r
ggplot(phase_data, aes(x = reorder(`R&D phase`, Num_Products), y = Num_Products)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() +
  theme_minimal()
```

---

### 3. **Top 10 Developers by Number of Products**

A horizontal bar plot showing the top 10 developers contributing to AMR products.

```r
ggplot(developer_counts, aes(x = reorder(Developer, -product_count), y = product_count)) +
  geom_bar(stat = "identity", fill = "mediumpurple") +
  coord_flip() +
  theme_minimal()
```

---

### 4. **Bar Plot for Innovation Status of Products (Updated)**

The scatter plot for innovative products has been replaced by a **bar plot** that visualizes the innovation status of products in the dataset. The `Innovative?` column shows whether each product is innovative or not.

1. **Data Filtering**: The script filters out rows with missing values in the `Innovative?` column.
2. **Data Summarization**: It groups data by `Innovative?` status and counts the number of products in each group.

```r
# Load necessary libraries
library(ggplot2)
library(dplyr)

# Filter out rows where 'Innovative?' is NA
cleaned_amr_data <- amr_data %>%
  filter(!is.na(`Innovative?`))

# Summarize data
innovation_summary <- cleaned_amr_data %>%
  group_by(`Innovative?`) %>%
  summarise(Count = n())

# Create bar plot with count labels
ggplot(innovation_summary, aes(x = `Innovative?`, y = Count, fill = `Innovative?`)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = Count), vjust = -0.5, size = 5) +  # Add count labels
  labs(title = "Innovation Status of Products", x = "Innovative?", y = "Number of Products") +
  theme_minimal() +
  theme(legend.position = "none")  # Remove legend since it's redundant with the x-axis
```

This updated bar plot displays the number of innovative and non-innovative products, with the exact counts labeled inside the bars.

---

### 5. **Bar Plot for Products by Pathogen Category and R&D Phase**

A faceted bar plot showing the number of products by pathogen category and R&D phase.

```r
ggplot(pathogen_rd_phase_counts, aes(x = reorder(`Pathogen category`, count), y = count, fill = `Pathogen category`)) +
  geom_bar(stat = "identity") +
  facet_wrap(~ `R&D phase`) +
  coord_flip() +
  theme_minimal()
```

---

### 6. **Interactive Donut Charts Using Shiny**

The Shiny app visualizes donut charts for `Innovative`, `NCE`, and `Route of Administration`.

```r
shinyApp(ui = ui, server = server)
```

---

### 7. **Bar Plots for Critical and Other Priority Pathogens**

Bar plots visualizing critical and other priority pathogens and their count.

```r
ggplot(critical_pathogens, aes(x = `Pathogen name`, y = Count, fill = `Active against priority pathogens?`)) +
  geom_bar(stat = "identity") +
  theme_minimal()
```

---

## Running the Script

1. Ensure the dataset is correctly placed in the working directory.
2. Run the script step by step to generate the visualizations. If needed, modify file paths or column names to fit your dataset structure.

