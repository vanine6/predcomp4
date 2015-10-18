## Coursera - Developing Data Products - Peer Assessment
## Marcos Vanine P. de Nader
## 
## Server


library(shiny)
library(ggplot2)
library(caret)
library(e1071)
library(randomForest)
library(ipred)
library(gbm)
require(PerformanceAnalytics)
data("iris")

## Note: we defined this new table because there was a strange error in prediction function  

new_iris<-data.frame(iris)
colnames(new_iris)<-c("sl","sw", "pl", "pw", "Species")

## Server Function

function(input, output) {
  
## When the training size input is changed, the partitions for training is created and the indexes for
## this partition is returned 
  
  itrain <- reactive ({
    
    itrain<-createDataPartition(y=new_iris$Species, p=input$trainSize/100, list=FALSE)
  })  

## Create the training data set
    
  train_ds <- reactive ({
    
    new_iris[itrain(),]
  })
  
## Create the testing data set

    test_ds <- reactive ({
    
    new_iris[-itrain(),]
  })
  
## When the training data set is modifies or the training method or training algrithm, the train
## function is executed again to generated a new Model Fit    
    
    modFit <- reactive ({
    
    if (input$trainMethod==1) {
      modFit<-train(eval(parse(text=paste("Species~", input$trainFeatures,sep=""))),
                    data=train_ds(), method=input$trainAlgorithm, verbose=FALSE)
    } else 
      if (input$trainMethod ==2) {
        modFit<-train(eval(parse(text=paste("Species~", input$trainFeatures,sep=""))),
                      data=train_ds(), method=input$trainAlgorithm, trControl=trainControl(method="cv",5), verbose=FALSE)
      } else {
        modFit<-train(eval(parse(text=paste("Species~", input$trainFeatures,sep=""))),
                      data=train_ds(), method=input$trainAlgorithm, trControl=trainControl(method="cv",10), verbose=FALSE)
      }
  })

## When the model fit is generated or the testing data set is modefied, the prediction runs.    
     
  pred <- reactive ({
    
    pred<-predict(modFit(), test_ds())
  })
  

## Determine the prediction accuracy and return a text with that value. 
  
    output$accuracy<- renderText({
  
    paste("Accuracy is", format(sum(pred()==test_ds()$Species)/length(pred()), digits=4), sep=" ")
  })

## Generate the confusion matrix and return as a table. 
    
  output$confusionMat <- renderTable({
  
    table(pred(), test_ds()$Species)
  })   
  
## Plot the prediction correctness in function of the petal width and length.
  
  output$plot <- renderPlot ({
  
    predRight<-pred()==test_ds()$Species
    plot<- qplot(pw, pl, data=test_ds() ,colour=predRight, xlab="Petal Width", ylab="Petal Length", 
          main = "Predition Accuracy in function of Petal Length and Width")
    print(plot)
  }) 
  
  output$doc <- renderUI ({
    doc<- includeHTML("doc.html")
  }) 
} 