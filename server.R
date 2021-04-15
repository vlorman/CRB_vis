library(datasets)
library(tidyverse)

# Define a server for the Shiny app
#setwd("./Boxes")
crbreviews<-read.csv("Data/CRB_Reviews.csv")

crbreviews_temp=select(crbreviews, Complaint_Type, Allegation_Type, PSS_Finding, CRB_Finding,Chief_Finding,Review_Year)
crbreviews_temp$count=1

crbreviews_all=crbreviews %>%
  group_by(Complaint_Type, Allegation_Type, PSS_Finding, CRB_Finding,Chief_Finding) %>%
  summarise(count=n())
crbreviews_all$Review_Year="All"
crbreviews_all<-as.data.frame(crbreviews_all[,c(1,2,3,4,5,7,6)])
crbreviews_plot_data=rbind(crbreviews_all,crbreviews_temp)

server<-function(input, output) {
  # Fill in the spot we created for a plot
  output$plot <- renderPlot({
    
    if (input$Allegation_Type=="All" & input$Complaint_Type=="All"){
        inputdata=filter(crbreviews_plot_data,
                         Review_Year==input$Review_Year)
    }else if (input$Allegation_Type=="All" & input$Complaint_Type!="All"){
        inputdata=filter(crbreviews_plot_data,
                         Review_Year==input$Review_Year, 
                         Complaint_Type==input$Complaint_Type)
    }else if (input$Allegation_Type!="All" & input$Complaint_Type=="All"){
        inputdata=filter(crbreviews_plot_data,
                         Review_Year==input$Review_Year, 
                         Allegation_Type==input$Allegation_Type)
    }else{
        inputdata=filter(crbreviews_plot_data,
                         Review_Year==input$Review_Year, 
                         Allegation_Type==input$Allegation_Type, 
                         Complaint_Type==input$Complaint_Type)
    }
        
    x <- rep("salmon",sum(as.numeric(inputdata$count)))
        
    if (input$Org=="CRB"){
        n.sustained=sum(as.numeric(filter(inputdata,CRB_Finding=="Sustained")$count))
    }else if (input$Org=="PSS"){
        n.sustained=sum(as.numeric(filter(inputdata,PSS_Finding=="Sustained")$count))
    }else{
        n.sustained=sum(as.numeric(filter(inputdata,Chief_Finding=="Sustained")$count))
    }
                 
    if (n.sustained!=0){
        x[(length(x)-n.sustained+1):(length(x))]="royalblue"}
        cols <- c("royalblue", "salmon","white")
        nr <- ceiling(sqrt(length(x)/3))
        nc <- ceiling(3*sqrt(length(x)/3))
        if (nr*nc>(length(x))){
          x[(length(x)+1):(nr*nc)]="white"
        }
        # create data.frame of positions and colors
        m <- matrix(factor(x), nc, nr)
        m=t(m)
        w<-matrix("white",17,50)
        if (length(x)>0){
          w[1:nr,1:nc]<-m
        }
        DF <- data.frame(row = c(row(w)[17:1,]), 
                         col = c(col(w)), 
                         value = c(w), 
                         stringsAsFactors = FALSE)
        
        #Plot squares
        pict<-plot(row ~ col, DF, col = DF$value, pch = 15, cex = 2, asp = 1,
             xlim = c(0, 50), ylim = c(0, 17),
             axes = FALSE, xlab = "", ylab = "")
        plotOutput(pict)
  })
  
  output$plot.ui <- renderUI({
      plotOutput("plot")
  })
  
  output$rate<-renderUI({
 
    if(input$Allegation_Type=="All" & input$Complaint_Type=="All"){
        inputdata=filter(crbreviews_plot_data,Review_Year==input$Review_Year)
    }else if (input$Allegation_Type!="All" & input$Complaint_Type=="All"){
        inputdata=filter(crbreviews_plot_data,Review_Year==input$Review_Year, Allegation_Type==input$Allegation_Type)
    }else if (input$Allegation_Type=="All" & input$Complaint_Type!="All"){
        inputdata=filter(crbreviews_plot_data,Review_Year==input$Review_Year, Complaint_Type==input$Complaint_Type)
    }else{
        inputdata=filter(crbreviews_plot_data,Review_Year==input$Review_Year, Allegation_Type==input$Allegation_Type, Complaint_Type==input$Complaint_Type)
    }
      

    if (input$Org=="Chief"){
        n.sustained=sum(as.numeric(filter(inputdata,Chief_Finding=="Sustained")$count))
    }else if (input$Org=="CRB"){
        n.sustained=sum(as.numeric(filter(inputdata,CRB_Finding=="Sustained")$count))
    }
    else{
        n.sustained=sum(as.numeric(filter(inputdata,PSS_Finding=="Sustained")$count))
    }
    
      HTML(paste("Number of complaints: ", sum(as.numeric(inputdata$count)), "<br>", "Number of sustained complaints: ", n.sustained, "<br>", "Sustain rate: ", round((n.sustained/sum(as.numeric(inputdata$count)))*100,1), "%"))
  })
}
