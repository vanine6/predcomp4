## Coursera - Developing Data Products - Peer Assessment
## Marcos Vanine P. de Nader
## 
## User Interface 

library(shiny)
library(ggplot2)


fluidPage(
  
  titlePanel("Comparison of prediction algorithms and parameters for the Iris dataset "),
  
  sidebarPanel(
    
    sliderInput('trainSize', 'Training File Size (%)', min=50, max=90,
                value=70),
    
    selectInput ("trainFeatures", label="Features", choices=
                          list("all"=".", "Sepal.Length+Sepal.Width"="sl+sw",
                               "Petal.length+Petal.Width"="pl+pw"),
                        selected=1),
    
    selectInput('trainMethod', 'Training Control Method',
                choices = list("Bootstrap"= 1, "5-Fold CV" = 2, "10-Fold CV" = 3), 
                selected=1),
    
    selectInput ("trainAlgorithm", "Training Algorithm",
                 choices = list("Random Forest (rf)"= "rf", "Boosting with trees (gbm)" =  "gbm",
                                "Tree Bag (treebag)" = "treebag", "Model Based Predict (lda)" = "lda"),
                 selected=1)
  ),
  
  mainPanel(
    
    tabsetPanel(
      tabPanel("Doc", uiOutput("doc")),
      tabPanel("Application", tableOutput("confusionMat"),
      textOutput("accuracy"),
      plotOutput("plot", width="70%")
  )))
)