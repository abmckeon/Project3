library(shiny)

shinyServer(function(input, output, session) {
  output$myrandom <- renderUI(
    plotOutput("id_data")
  )
  data_filtered <- reactive({
    wineMag %>%
      filter(`score` < input$id_slider1[2],
             `score` > input$id_slider1[1],
             `price` < input$id_slider2[2],
             `price` > input$id_slider2[1],
             `country` == input$id_radio)
  })
  
  wholeData <- reactive({
    wineMag})
  
  output$id_table <- renderTable(data_filtered())

  #output$id_explore <- renderPlot(
    #explore_filtered()%>%
      #ggplot(aes(`explore`))+
      #geom_histogram()+
      #theme_solarized())
  
  #output$id_model <- renderPlot(
    #model_filtered()%>%
      #ggplot(aes(`model`))+
      #geom_histogram()+
      #theme_solarized())
  
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
  
