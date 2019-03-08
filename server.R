#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(caret)
library(randomForest)
library(mlbench)
library(e1071)

data(BreastCancer)
set.seed(12321)
inTrain <- createDataPartition(y=BreastCancer$Class, p=0.8, list=F)
bctrn <- BreastCancer[inTrain,]
bctst <- BreastCancer[-inTrain,]

help <- paste(
    "<h4>Prediction Models for Wisconsin Breast Cancer Data</h4>",
    "<p>This application allows one to experiment with feature and model selection for predicting breast cancer outcome from a set of features. The left side of the screen contains user inputs, and the right side shows the results.</p>",
    "<p>The data comes from the Wisconsin Breast Cancer dataset of the mlbench library. It has 699 observations of 11 variables, including the outcome Class variable. You may select one or more of 8 features to be used for training the model. 80% of the data rows are used for training the model, and 20% are used for testing it.</p>",
    "<p>Select one or more of the features by clicking on their checkboxes. Choose between Logistic Regression and Random Forest by clicking on the appropriate radio button. If selecting Random Forest, adjust the number of trees using the slider. Then click on the Fit Model button.</p>",
    "<p>The program takes in your inputs, fits a model to training data based on them, and evaluates the model performance on test data. Then it displays the following items:</p>",
    "<ul>",
    "<li>the Confusion Matrix</li>",
    "<li>the formula used, and</li>",
    "<li>the details of the fitted model.</li>",
    "</ul>",
    "<p>If you click on Fit Model button without selecting any features, an error message is printed directing you to select a feature."
)


# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  logistic <- function(form) {
    s0 <- paste0("Formula:\n", form, "\n")
    form <- as.formula(form)
    set.seed(12321)
    mod <- train(form, 
                 data=bctrn, method="glm", family="binomial")
    cm <- confusionMatrix(predict(mod, newdata=bctst), bctst$Class)

    s1 <- capture.output(cm)
    s2 <- capture.output(mod)
    s1 <- paste0(s1, collapse="\n")
    s2 <- paste0(s2, collapse="\n")
    s <- paste0(c(s1,s0,s2),"\n")
    s
  }
  randomf <- function(form, ntree) {
    s0 <- paste0("Formula:\n", form, "\n")
    form <- as.formula(form)
    set.seed(12321)
    mod <- randomForest(form, data=bctrn, ntree=ntree)
    cm <- confusionMatrix(predict(mod, newdata=bctst), bctst$Class)
    s1 <- capture.output(cm)
    s2 <- capture.output(mod)
    s1 <- paste0(s1, collapse="\n")
    s2 <- paste0(s2, collapse="\n")
    s <- paste0(c(s1,s0,s2),"\n")
    s
  }
  
  observeEvent(input$fitModel,{
    msg <- {
      features <- input$feat
      if(length(features) == 0) 
        "Please select at least one feature, and click on Fit Model"
      else {
        f <- paste0(features, collapse="+")
        f <- paste0("Class~", f)
        if(input$model.type == "Logistic Regression")
          logistic(f)
        else
          randomf(f, input$ntree)
      }  
    }
    output$msg <- renderText(msg)
    updateTabsetPanel(session, "inTabset", selected="tab1")
  })

  output$help <- renderUI(HTML(help))
  

  
})
