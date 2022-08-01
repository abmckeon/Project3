library(shiny)

shinyServer(function(input, output, session) {
  output$myrandom <- renderUI(
    plotOutput("id_data")
  )
  explore_filtered <- reactive({
    wineMag %>%
      filter(`points` <= input$id_slider1[2],
             `points` >= input$id_slider1[1],
             `price` <= input$id_slider2[2],
             `price` >= input$id_slider2[1],
             `country` == input$id_radio)
    })
   
  wholeData <- reactive({
    wineMag})
  
  output$id_data <- renderPlot(
    if (input$change_plot == "bar") {
      explore_filtered() %>%
      ggplot(aes_string(x= 'province', y='price', fill='province')) +
        geom_bar(stat = "identity")+
        theme(aspect.ratio=1)
    } else {
      explore_filtered() %>%
      ggplot(aes_string(x = "", y='price', fill = 'province')) +
        geom_bar(stat = "identity", width = 1) +
        coord_polar("y", start=0)
      }
    )
  
#   output$id_models <- observeEvent(input$do, input$id_numeric, input$id_x1, input$id_x2 {
#     set.seed(1106)
#     trainIndex <- createDataPartition(wineMag, input$id_numeric, list = FALSE)
#     wineMagTrain <- wineMag[trainIndex, ]
#     wineMagTest <- wineMag[-trainIndex, ]
# 
#     ## set up trainControl using 5-fold cross validation
#     trnCntrl <- trainControl(method = "cv", number=5)
# 
#     ## NewtrnCntrl for ENSEMBLE METHODS
#     NewtrnCntrl <- trainControl(method = "cv", number=5, repeats=3)
#     
#     glmFit <- train(wineMag$price ~ (input$id_x1, input$id_x2,
#                               data = wineMagTrain,
#                               method = "glm",
#                               preProcess = c("center", "scale"),
#                               trControl = trnCntrl))
# 
#     rfFit <- train(wineMag$price ~ input$id_x1, input$id_x2,
#                    data = wineMagTrain,
#                    method = "rf",
#                    trControl = NewtrnCntrl,
#                    preProcess = c("center", "scale"),
#                    tuneGrid = data.frame(mtry= 1:7))
# 
#     gbmGrid <-  expand.grid(interaction.depth = c(1,2,3,4),
#                             n.trees = c(25,50,100,150,200),
#                             shrinkage = 0.1,
#                             n.minobsinnode = 10)
# 
#     boostFit <- train(wineMag$price ~ input$id_x1, input$id_x2,
#                       data = wineMagTrain,
#                       method = "gbm",
#                       trControl = NewtrnCntrl,
#                       preProcess = c("center", "scale"),
#                       tuneGrid = gbmGrid,
#                       verbose = FALSE)
# 
#     #Compare model performance on training set and print summaries
#     rmse(glmFit, wineMagTrain)
#     summary(glmFit)
# 
#     rfFit.pred <- predict(rfFit, newdata = wineMagTrain)
#     print(rfFit.pred)
# 
#     rmse(boostFit, wineMagTrain)
#     print(boostFitPred)
#     
#     #Apply models to test set
#     rmse(glmFit, wineMagTest)
#     summary(glmFit)
#     
#     rfFit.pred <- predict(rfFit, wineMagTest)
#     print(rfFit.pred)
#     
#     boostFit.pred <- predict(boostFitFit, wineMagTest)
#     print(boostFit.pred)
# })
# 

  output$id_table <- renderTable(explore_filtered())
  
  output$wineMag <- renderDataTable(wholeData())
  
  output$downloadData<- downloadHandler(
    filename = function(){paste ("wineMag", "csv", sep = ",")},
    
    content = function(file){
      write.csv(wholeData(), file)
      
    }
    
  )
  
}

)

# Run the application through github 
  
