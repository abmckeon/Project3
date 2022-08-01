library(shiny)
library(tidyverse)
library(shinythemes)
library(shinyWidgets)
library(ggthemes)
library(mathjaxr)

wineMag <- read_csv("/Users/ashleebrookemckeon/Desktop/ST558_Databases/Project3/McKeonWineProject3/wineMag.csv") 
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
      width: 50%;
    }"
                                   )
                              )
                   ),

    # Application title
    titlePanel("WineEnthusiast Wine Reviews"),

    sidebarLayout(
      sidebarPanel(sliderInput("id_slider1", "Select Point Range",
                               min = 0, max = 100, value = c(90, 95), post = "%"),
                   
                   sliderInput("id_slider2", "Select Price Range",
                               min = 0, max = 500, value = c(100, 150), pre = "$"),
                   
                   radioGroupButtons("id_radio", "Select Country",
                                     choices= unique(wineMag$`country`),
                                     status = "success"),
                   selectInput("id_numeric", "Select the % of the full dataset to be used for the training set. Note: The remainder will be automatically used for the test set to ensure the test and training sets add to 1 or 100% of the full dataset.",
                               choices = c(0.25, 0.50, 0.75)),  
                   selectInput("id_x1", "Select Predictor Variable 1:",
                               choices = list("price", "country", "province"),
                               selected = "price"),
                   selectInput("id_x2", "Select Predictor Variable 2:",
                               choices = list("price", "country", "province"),
                               selected = "price")
                   ),
    
      mainPanel(tabsetPanel 
                (uiOutput("myrandom"),
                  
                  tabPanel("About",h4(div(p("The purpose of this app is to explore a dataset containing ~130k wine reviews published to WineEnthusiast."),
                                          br(),
                                          p("The dataset comes from Kaggle and contains information on taster name, wine price, variety, score, country, county, vineyard, etc."),
                                          br(),
                                          p(tags$a(href="https://www.kaggle.com/datasets/mysarahmadbhat/wine-tasting", "Click here for more information about the dataset!")),
                                          br(),
                                          p("The sliders on the right control the rating and price of the wine and the buttons control the country the wine is produced in. "),
                                          br(),
                                          p("Below is an image of the cover of the famous Wine Enthusiast Magazine."),
                                          br(),
                                          p("This tab tells you information about the data. The 'Data Exploraton' tab displays graphical and numeric summaries based on user input. The 'Modeling' tab fits 3 supervised models to the data. Finally, the 'Data' tab allows you to scroll through, subset, and download the data.  Click one of the tabs to begin."),
                                          br(),
                                          img(src = "wineMagCover.jpeg"),
                                          )
                                      )
                           ),
                  
                  tabPanel("Data Exploration",
                           br(),
                           h4(p("Here you can use the sliders and radio buttons to sort through the data by points, price, and country to create a different numerical summaries.")),
                           br(),
                           tableOutput(outputId="id_table"),
                           br(),
                           h4(p("With this scatterplot, you can visually examine the way the direction and strength of the relationship between points and price of wines changes as a function of the country the wine is from.")),
                           br(),
                           radioGroupButtons("change_plot", "Select a Visualization",
                             choices = c(
                               `<i class='fa fa-bar-chart'></i>` = "bar",
                               `<i class='fa fa-pie-chart'></i>` = "pie"
                             ),
                             justified = TRUE,
                             selected = "bar"
                             ),
                           br(),
                           plotOutput(outputId="id_data", height = 250)
                           ),
                  
                  tabPanel ("Modeling",
                            br(),
                            h4(p("Please click the 3 tabs to learn more about the modeling process used on the wineMag dataset.")),
                            
                            tabsetPanel(
                              tabPanel("Modeling Info",h4(div(p("Three models have been run on the wineMag data. Those models, their advantages and drawbacks are described below."),
                                                              br(),
                                                              h4(p("A multiple linear regression model models the linear relationship between a continuous response variable and two or more continuous predictors. This model is based on, and expanded from, the simpliest regression model individuals typically learned in beginners classes on of:")),
                                                              title = 'MathJax Examples',
                                                              withMathJax(),
                                                              helpText('$$y=mx+b$$'),
                                                              br(),
                                                              h4(p("Advantages of this model include the ability to determine the relative predictvie contributions of each predictor to the model and the ability to identify outliers. Disadvantages of this model include, but are not limited to, the need for continous variables and the potential for underfitting or the senstivity of the model to outliers.")),
                                                              br(),
                                                              h4(p("A boosted tree model is an ensemble method that models a response variable using multiple models and when combining those models into one combined model for greater prediction power. The booted tree model models tree sequentially. Advantages of this model include the enhanced prediction processing capability, when using a capable system and the increased predictive power compared to non-ensemble methods. Disadvantages of this model include, but are not limited to, the senstivity of the model to outliers and the computing power needed.")),
                                                              br(),
                                                              h4(p("A random forest model is another ensemble method that trains many decision trees at one time and then combines those training models into one combined model for testing on a test dataset for greater prediction power. Advantages of this model include the versatility for being used for both regression and classification, as well as decreased fear of overfitting your model as long as you have enough trees to work with. Disadvantages of this model include, but are not limited to, the computing power needed can make running these models quite slow and it also many be complex to interpret to those unfamilar with the method.")),
                                                              br(),
                              )
                              )
                              ),
                              
                              tabPanel("Model Fitting",h4(div(p("Model fitting results are below."),
                                                              br(),
                                                              tags$head(tags$script(src = "message-handler.js")),
                                                              actionButton("do", "Click to Run All Models", icon=icon("play")),
                                                              br(),
                                                              verbatimTextOutput("output$id_models")
                              )
                              )
                              ),
                              
                              tabPanel("Prediction",h4(div(p("Here you can use Model X for your own predictions. Select the values for the predictor variables below and see the prediction change"),
                                                           br(),
                                                           #plotOutput(outputId="id_model")
                              )
                              )
                              ),
                              
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
                           ),
                  )
                )
      )
    )
    )