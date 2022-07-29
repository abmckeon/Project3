library(shiny)
library(tidyverse)
library(shinythemes)
library(shinyWidgets)
library(ggthemes)

wineMag <- read_csv("/Users/ashleebrookemckeon/Desktop/ST558_Databases/Project3/wineMag.csv") 
                           col_types = cols(`id` = col_double(),
                                            `country` = col_character(), 
                                            `description` = col_character(), 
                                            `designation` = col_character(), 
                                            `points`= col_double(),
                                            `price` = col_double(),
                                            `province`= col_character(), 
                                            `region_1` = col_character(), 
                                            `region_2`= col_character(), 
                                            `taster_name`= col_character(), 
                                            `taster_twitter_handle` = col_character(), 
                                            `title`= col_character(), 
                                            `variety`= col_character(), 
                                            `winery` = col_character()
                                            )

#Filter dataset to only include wines from US, France, and Italy and only wines <= $500
                           
wineMag <- filter(wineMag, (`country` %in% c("Italy", "France", "US")) & (`price`<=500))

# Define UI for application 
shinyUI(fluidPage(theme = shinytheme("sandstone"),
                   tags$head(
                   tags$style(HTML("img {
      display: block;
      height: auto;
      margin: 0;
      margin-bottom: 1rem;
      padding: 0;
      width: 100%;
    }"
                                   )
                              )
                   ),

    # Application title
    titlePanel("Wine Enthusiast Wine Reviews"),

    sidebarLayout(
      sidebarPanel(sliderInput("id_slider1", "Select Score Range",
                               min = 0, max = 100, value = c(50, 70), pre = "%"),
                   
                   sliderInput("id_slider2", "Select Price Range",
                               min = 0, max = 500, value = c(100, 150), pre = "$"),
                   
                   radioGroupButtons("id_radio", "Select Country", 
                                     choices= unique(wineMag$`country`),
                                     status = "success")
                   ),
    
      mainPanel(tabsetPanel 
                (uiOutput("myrandom"),
                  
                  tabPanel("About",h5(div(p("The purpose of this app is to explore a dataset containing ~130k wine reviews published to WineEnthusiast."),
                                          br(),
                                          p("The dataset comes from Kaggle and contains information on taster name, wine price, variety, score, country, county, vineyard, etc."),
                                          br(),
                                          p("You can visit this link for more informaton about the dataset [WineEnthusiast] < https://www.kaggle.com/datasets/mysarahmadbhat/wine-tasting>."),
                                          br(),
                                          p("The sliders on the right control the rating and price of the wine and the buttons control the country the wine is produced in. "),
                                          br(),
                                          p("Below is an image of the cover of the famous Wine Enthusiast Magazine."),
                                          br(),
                                          img(src = "wineMagCover.jpeg"),
                                          br(),
                                          p("This tab tells you information about the data. The 'Data Exploraton' tab displays graphical and numeric summaries based on user input. The 'Modeling' tab fits 3 supervised models to the data. Finally, the 'Data' tab allows you to scroll through, subset, and download the data.  Click one of the tabs to begin."),
                                          br(),
                                          )
                                      )
                           ),
                  
                  tabPanel("Data",
                           br(),
                           h5(p("View the entire dataset and download here")),
                           downloadBttn('downloadData',
                                        label = "Download",
                                        style = "stretch",
                                        color = "success",
                                        size = "md",
                                        block = FALSE,
                                        no_outline = TRUE),
                           br(),

                           dataTableOutput("wineMag"),
                           br()
                           )
                  )
                )
      )
    )
    )

                
                  #tabPanel("Data Exploration", 
                           #br(),
                           #h4(p("Here you can use the sliders and radio buttons to sort through the data by score, price, and country.")),
                           #br(),
                           #tableOutput(outputId="id_table")),
                           #h4(p("With this histogram, you can sort through the data by looking at the distribution of countries as a function of score and price.")), 
                           #br(),
                           #plotOutput(outputId="id_explore")),
                  
                  #tabPanel ("Modeling",
                            #br(),
                            #h4(p("Please click the 3 tabs to learn more about the modeling process used on the wineMag dataset."))),
                            
                            #tabPanel("Modeling Info",h3(div(p("Three models have been run on the wineMag data. Those models, their advantages and drawbacks are described below."),
                                                            #br(),
                                                            #p("Model 1: "),
                                                            #br(),
                                                            #p("Model 2: "),
                                                            #br(),
                                                            #br(),
                                                            #p("Model 3: ")
                                                            #))),
                                                            
                            #tabPanel("Model Fitting",h4(div(p("Model fitting results are below."),
                                                            #br()
                                                            #))),
                                                            
                            #tabPanel("Prediction",h4(div(p("Here you can use Model X for your own predictions. Select the values for the predictor variables below and see the prediction change"),
                                                            #br(),
                            #br(),
                            #plotOutput(outputId="id_model")),
                  

