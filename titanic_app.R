library(shiny)
library(tidyverse)
library(plyr)
library(caret)
library(titanic)
library(DT)
ui <- fluidPage(
  fluidRow(
    column(2, selectInput("dataset", "Select dataset", 
                choices = c("titanic_train", "titanic_test"))),
    column(2, selectInput("impute", "Imputation", 
                          choices = c("None", "Mean of Groups",
                                      "Mean", "MICE:Predictive Mean Matching"))),
    column(2,selectInput("histchoices", "Variables for Histogram", choices = "")),
    column(6,plotOutput("histogram")),
    dataTableOutput("input_data")
  )
)

server <- function(input, output, session){
  data <- reactive({
    data <- eval(parse(text = input$dataset))
    data$Sex <- as.factor(data$Sex)
    updateSelectInput(session, "histchoices", choices = colnames(data))
    if(input$impute == "Mean of Groups"){
      not_na_age <- data[!is.na(data$Age), ]
      na_age <- data[is.na(data$Age), ]
      by_sc <- group_by(data, Sex, Pclass)
      by_sc_sum <- dplyr::summarise(
        by_sc,
        number = n(),
        average_age = mean(Age, na.rm= T)
      )
      for(i in 1:3){
        na_age[na_age$Pclass==i& na_age$Sex == "female","Age"] =
          by_sc_sum[by_sc_sum$Pclass==i& by_sc_sum$Sex == "female","average_age"]
        na_age[na_age$Pclass==i& na_age$Sex == "male","Age"] =
          by_sc_sum[by_sc_sum$Pclass==i& by_sc_sum$Sex == "male","average_age"]
      }
      data <- rbind(not_na_age, na_age)
    } else if(input$impute == "Mean"){
      data[is.na(data$Age), "Age"] = mean(data$Age, na.rm = T)
    } else if (input$impute == "MICE:Predictive Mean Matching"){
      temp <- mice(titanic_train, maxit = 50, m = 5, meth = "pmm", seed = 500)
      data <- complete(temp , 1)
    } 
    data
  })
  output$input_data <- renderDataTable({
    data <- data()
  },
  filter = "top",
  extensions = "Buttons", 
  options = list(
    dom = 'Bfrtipl',
    buttons = c('excel','colvis'),
    lengthMenu = list (c(10, 25,50,-1), c(10, 25, 50,"All")))
  )
  output$histogram <- renderPlot({
    data <- data()
    ggplot(data, aes(x = data[[input$histchoices]]))+
      geom_bar(aes(fill = as.factor(Survived)))+
      xlab(eval(input$histchoices))+
      guides(fill = guide_legend(title = "Survived"))
  })
}

shinyApp(ui = ui, server = server)