#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)

PPM <- read.csv("PPM.csv", stringsAsFactors=FALSE)

navbarPage("AggXtream Rule Finder",
   tabPanel("PPM Explorer",
        sidebarLayout(
            sidebarPanel(
                h3("How would you like to slice the data?"),
                br(),
                selectInput("css_2", "CSS Secondary:",
                            choices = unique(PPM$css_2)),
                checkboxInput("bica", "Producing base material"),
                checkboxInput("brita2", "Producing -32+22mm"),
                checkboxInput("xaxis", "CSS Tertiary is x-axis", 
                              value = TRUE),
                br(),
                radioButtons("response", "Desired response", 
                             choices = c("Circ. 2/Circ. 3 cap. ratio"="capC2_capC3",
                                         "Quaternary in/outflow ratio"="capBT4_alimPP4",
                                         "Total thruput"="tph_total",
                                         "TPH Base material"="tph_bica",
                                         "TPH -32+22mm"="tph_brita2",
                                         "TPH -22+14mm"="tph_brita1",
                                         "TPH -14+12mm"="tph_bmeia",
                                         "TPH -12+5.5mm"="tph_pedrisco",
                                         "TPH Dust"="tph_po"))
            ),
            mainPanel(
                plotlyOutput("ppm"),
                br(),
                h3("Remarks:"),
                textOutput("info")
            )
        )
   ),
   tabPanel("Summary",
        fluidRow(
            verbatimTextOutput("summary")
        )
    ),
   tabPanel("Operating Rules",
        h3("Operating Rules for response = f(css_2, css_3, css_4, 
                   right_bica, right_brita2)"),
        fluidRow(
            column(6,
                plotOutput("perfPlot"),
                h4("Metrics:"),
                p("Coeff. of determination: "),
                textOutput("R2"),
                p("Mean absolute error:"),
                textOutput("MAE")
            ),
            column(6,
                br(),
                h4("Model Rules:"),
                verbatimTextOutput("rules")
            )
        )
    ),
   tabPanel("Process Flow Diagram",
            div(img(src="PFD.jpg"), style="text-align: center;")
    )
)