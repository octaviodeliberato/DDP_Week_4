#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(ggplot2)
library(dplyr)
library(tidyr)
library(RWeka)
library(Metrics)

PPM <- read.csv("PPM.csv", stringsAsFactors=FALSE)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
    mydata.ppm <- reactive({
        bica <- ifelse(input$bica == TRUE, 0, 100)
        brita2 <- ifelse(input$brita2 == TRUE, 100, 0)
        data <- filter(PPM, css_2 == input$css_2, right_bica == bica, 
                       right_brita2 == brita2) %>% select(css_3, css_4, input$response)
        if(input$xaxis == TRUE)
            data <- spread(data, css_3, input$response)
        else data <- spread(data, css_4, input$response)
        data <- as.matrix(data)
    })
    
    mydata.summ <- reactive({
        bica <- ifelse(input$bica == TRUE, 0, 100)
        brita2 <- ifelse(input$brita2 == TRUE, 100, 0)
        data <- filter(PPM, css_2 == input$css_2, right_bica == bica, 
                       right_brita2 == brita2)
    })
    
    mydata.train <- reactive({
        
        data <- select(PPM, css_2, css_3, css_4, right_bica, right_brita2, 
                       input$response)
    })
    
    output$ppm <- renderPlotly({
        m <- nrow(mydata.ppm())
        n <- ncol(mydata.ppm())
        x <- ifelse(input$xaxis, unique(PPM$css_3), unique(PPM$css_4))
        y <- ifelse(input$xaxis, unique(PPM$css_4), unique(PPM$css_3))
        z <- mydata.ppm()[2:m, 2:n]
        xaxis <- list(title = "CSS Tertiary, mm")
        yaxis <- list(title = "CSS Quaternary, mm")
        plot_ly(x=x, y=y, z=z, type = "contour", 
                contours = list(showlabels = TRUE)) %>% 
            layout(title=paste("Plant Performance Map - ", input$response),
                   scene=list(xaxis, yaxis))
    })
    
    output$summary <- renderPrint({
        summary(mydata.summ())
    })
    
    output$info <- renderText({
        ifelse(input$xaxis == TRUE, 
               "CSS Tertiary (mm) is x-axis and CSS Quaternary (mm) is y-axis",
               "CSS Quaternary (mm) is x-axis and CSS Tertiary (mm) is y-axis")
    })
    
    output$rules <- renderPrint({
        formula <- paste(input$response, paste(c("css_2", "css_3", "css_4", 
                                                 "right_bica", "right_brita2"), 
                                               collapse = " + "), sep = " ~ ")
        withProgress(message = 'Modeling in progress',
                     detail = 'This may take a while...', value = 0, {
                         for (i in 1:15) {
                             incProgress(1/15)
                             Sys.sleep(0.1)
                         }
                     })
        m5r <- M5Rules(formula, data = mydata.train())
        print(m5r)
        
    })
    
    output$perfPlot <- renderPlot({
        formula <- paste(input$response, paste(c("css_2", "css_3", "css_4", 
                                                 "right_bica", "right_brita2"), 
                                               collapse = " + "), sep = " ~ ")
        m5r <- M5Rules(formula, data = mydata.train())
        m5r.pred <- predict(m5r, mydata.train())
        true.values <- mydata.train()[, input$response]
        plot(true.values ~ m5r.pred, xlab = "True Values", ylab = "Predicted Values",
             main = "Model Performance")
        abline(lm(true.values ~ m5r.pred), col="blue", lwd=2)
        output$R2 <- renderText({
            cor(true.values, m5r.pred)**2
        })
        output$MAE <- renderText({
            mae(true.values, m5r.pred)
        })
    })
})