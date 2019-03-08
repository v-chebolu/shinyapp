#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Prediction Models for Wisconsin Breast Cancer Data"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       helpText("Click on the Help tab to view help text."),
       checkboxGroupInput("feat", "Features",
            choiceValues=c("Cl.thickness",
                          "Cell.size",
                          "Cell.shape",
                          "Marg.adhesion",
                          "Epith.c.size",
                          "Bl.cromatin",
                          "Normal.nucleoli",
                          "Mitoses"),
            choiceNames=c("Clump Thickness",
                           "Cell Size",
                           "Cell Shape",
                           "Marginal Adhesion",
                           "Single Epithelial Cell Size",
                           "Bland Cromatin",
                           "Normal Nucleoli",
                           "Mitoses")
            ),
       radioButtons("model.type", "Model Type", 
                    choices=c('Logistic Regression', 'Random Forest')),
       sliderInput("ntree",
                   "Number of trees:",
                   min = 1,
                   max = 500,
                   value = 30),
       actionButton("fitModel", "Fit Model")
       ),    
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(id="inTabset",
        tabPanel("Model Statistics", value="tab1", pre(textOutput('msg'))),
        tabPanel("Help", value="tab2", htmlOutput('help') )
      )
    )
  )
))
