library(datasets)
library(shiny)
library(dplyr)


# Use a fluid Bootstrap layout
fluidPage(    
  
  # Give the page a title
  titlePanel("What happens to complains made against the Rochester Police Department?"),
  
  # Generate a row with a sidebar
  sidebarLayout(      
    
    # Define the sidebar with one input
    sidebarPanel(
      selectInput("Review_Year", "Year:", 
                  choices=c("All","2013","2014","2015","2016")),
                 #   unique(crbreviews_plot_data$Review_Year)),
      selectInput("Allegation_Type", "Allegation Type:", 
                  choices=c("All", levels(crbreviews_plot_data$Allegation_Type))),
      selectInput("Complaint_Type", "Complaint initiated by:", 
                  choices=c("All", levels(crbreviews_plot_data$Complaint_Type))),
      selectInput("Org", "Organization:", 
                  choices=c("CRB","Chief", "PSS")),
      hr(),
      helpText("One square represents one RPD action in a complaint filed with the Civilian Review Board."),
      helpText("Complaints are adjudicated by the Civilian Review Board (CRB), Professional Standards Section (RPD internal affairs, PSS), and by the Chief of RPD"),
      helpText("Blue squares represent those complaints that were sustained (i.e. upheld) by the indicated organization (CRB, PSS, or the Chief)"),
      helpText("(Each incident may have several allegations, and each allegation may have several actions associated to it.)"),
      helpText("Ultimately, final disciplinary authority rests with the Chief of Police."),
      helpText("Source: RPD-OBI dataset, available at: http://data-rpdny.opendata.arcgis.com/datasets/crb-reviews"),
      helpText("Version 1, 12/4/2017")
    ),
    
    # Create a spot for the barplot
    mainPanel(
      uiOutput("plot.ui"),
      htmlOutput("rate")
      
     
    )
    
  )
)