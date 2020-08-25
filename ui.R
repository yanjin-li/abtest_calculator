#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
# Shiny Initializations --------------------------------------------------------
library(shiny)
options(shiny.sanitize.errors = FALSE)


# UI Designs -------------------------------------------------------------------
shinyUI(
  fluidPage(
    # Title
    navbarPage("A/B Test Sample Size Calculator",  
               
               # Tab 1: Proportion Test (page 1)
               tabPanel(
                 "Proportion Test (CTR, etc.)", 
                 fluid = TRUE, 
                 icon = icon("percent"),
                 titlePanel("Proportion Test (CTR, etc.)"),
                 h3("Input variables:"),
                 
                 fluidRow(
                   column(6,
                          h4("1. Baseline Conversion Rate and Estimated Life %"), 
                          br(), 
                          # step 1
                          helpText("Step 1: Enter the baseline conversion rate for 
                               the page, experience, and audience you hope to 
                               impact (e.g., enter “5” for “5%”):"),
                          numericInput(
                            inputId = "prop_test_baseline",
                            label = "Baseline converstion rate (%):",
                            value = 15.0
                          ),
                          # step 2
                          helpText("Step 2: Enter the estimated lift percentage you 
                               would need to see in order to make a decision 
                               (positive or negative):"),
                          numericInput(
                            inputId = "prop_test_min_effect",
                            label = "Expected lift percentage (%):",
                            value = 1.0
                          )
                   ),
                   
                   column(6,
                          h4("2. Traffic Volume and # of Variations (Groups)"), 
                          br(), 
                          # step 3
                          helpText("How many visit(or)s do you get to the experience
                      , on average, over the course of 30 days?"),
                          numericInput(
                            inputId = "prop_test_traffic",
                            label = "Traffic (Two Weeks User Count):",
                            value = 10000
                          ),
                          # step 4
                          helpText("How many total variations are you testing, 
                               including the control (e.g., a standard A/B test 
                               would be “2”)?"),
                          numericInput(
                            inputId = "prop_test_variations",
                            label = "Number of Variations:",
                            value = 2
                          )
                   )
                 ),
                 
                 # Page 1 Row #2 
                 fluidRow(
                   # 3. Tail Options 
                   column(4,
                          h4("3. Select 1-Tailed vs. 2-Tailed"), 
                          br(), 
                          # step 1
                          helpText("Is your hypothesis directional (e.g., you expect 
                          the conversion rate to increase) or non-directional (e.g., 
                          you expect the challenger to be different, but you have no 
                          evidence to support the challenger as better)?"),
                          selectInput(
                            inputId = "prop_test_tail_option",
                            label = "Test Tail Option:",
                            choices = c(
                              "Two-side (A non-directional hypothesis: B = A)" = "two.sided",
                              "One-side (A directional hypothesis: B > or < A)" = "one.sided"
                            )
                          )
                   ),
                   
                   # 4. Alpha Options 
                   column(4,
                          h4("4. Select Confidence (1-\u03B1)"), 
                          br(), 
                          helpText("How important is it that you do not erroneously 
                          report a difference when, in reality, the variations are the
                                   same?"), 
                          sliderInput(
                            inputId = "prop_test_alpha",
                            label = div(style='width:350px;',
                                        div(style='float:left;', 'Not Important'),
                                        div(style='float:right;', 'Very Important')),
                            min = 50,
                            max = 99,
                            value = 95,
                            post = "%"
                          )
                   ),
                   
                   # 5. Beta Options 
                   column(4,
                          h4("5. Select Confidence (1-\u03B2)"), 
                          br(), 
                          # step 1
                          helpText("How important is it that you do not erroneously 
                          report NO difference when, in reality, there is a difference 
                                   between the variations?"),
                          sliderInput(
                            inputId = "prop_test_beta", 
                            label = div(style='width:350px;',
                                        div(style='float:left;', 'Not Important'),
                                        div(style='float:right;', 'Very Important')),
                            min = 50,
                            max = 99,
                            value = 80,
                            post = "%"
                          )
                   )
                 ),
                 
                 # Page 1 Row 3 
                 fluidRow(
                   column(
                     12, 
                     h3("Output results: the Minimum Sample Size"), 
                     br(), 
                     h4("The number of visit(or)s should be at least:"),
                     h1(
                       style = "text-align: center;",
                       textOutput("propTestSampleSizeBox", inline=TRUE),
                       span(style="display: inline-block; font-size:40px;", "per variation")
                     ),
                     h2(
                       style = "text-align: center;", 
                       textOutput("propTestTotalVisitors", inline=TRUE)
                     ),
                     h4("This is the number of visitors required to detect a change in the
                          conversion rate from the baseline (%) to (1+lift) x basline (%).")
                   )
                 ),
                 # Page 1 Row 4 
                 fluidRow(
                   downloadButton(
                     "downloadDataProp",
                     label = "Download the proportion test result"
                   )
                 )
               ),
               
               
               
               # Tab 2: t-Test (page 2)
               tabPanel(
                 "t-Test (FQ28, etc.)", 
                 fluid = TRUE, 
                 icon = icon("hourglass-half"),
                 titlePanel("t-Test (FQ28, etc.)"),
                 h3("Input variables:"),
                 
                 fluidRow(
                   column(6,
                          h4("1. Baseline Metrics Information"), 
                          br(), 
                          # step 1
                          helpText("Step 1: Enter the number of active users 
                                   (usually in two weeks periods):"),
                          numericInput(
                            inputId = "t_test_user_count",
                            label = "Number of active users:",
                            value = 9566078
                          ),
                          
                          # step 2
                          helpText("Step 2: Enter the mean of the metric of 
                                   interest:"),
                          numericInput(
                            inputId = "t_test_mean",
                            label = "Mean value of the metric:",
                            value = 3.614
                          ),
                          
                          # step 3
                          helpText("Step 3: Enter the standard deviation of the 
                                   metric:"),
                          numericInput(
                            inputId = "t_test_sd",
                            label = "Standard deviation value of the metric:",
                            value = 2.743
                          )
                   ),
                   
                   column(6,
                          h4("2. Expected Life % and # of Variations (Groups)"), 
                          br(), 
                          # step 4
                          helpText("Step 4: Enter the estimated lift percentage 
                          you would need to see in order to make a decision 
                                   (positive or negative):"),
                          numericInput(
                            inputId = "t_test_min_effect",
                            label = "Expected lift (%):",
                            value = 1
                          ),
                          # step 5
                          helpText("Step 5: Enter the number of total variations 
                          are you testing, including the control (e.g., a standard 
                                   A/B test would be “2”)?"),
                          numericInput(
                            inputId = "t_test_variations",
                            label = "Number of Variations:",
                            value = 2
                          )
                   )
                 ),
                 
                 # Page 2 Row #2 
                 fluidRow(
                   # 3. Tail Options 
                   column(4,
                          h4("3. Select 1-Tailed vs. 2-Tailed"), 
                          br(), 
                          # step 1
                          helpText("Is your hypothesis directional (e.g., you expect 
                          the conversion rate to increase) or non-directional (e.g., 
                          you expect the challenger to be different, but you have no 
                          evidence to support the challenger as better)?"),
                          selectInput(
                            inputId = "t_test_tail_option",
                            label = "Test Tail Option:",
                            choices = c(
                              "Two-side (A non-directional hypothesis: B = A)" = "two.sided",
                              "One-side (A directional hypothesis: B > or < A)" = "one.sided"
                            )
                          )
                   ),
                   
                   # 4. Alpha Options 
                   column(4,
                          h4("4. Select Confidence (1-\u03B1)"), 
                          br(), 
                          helpText("How important is it that you do not erroneously 
                          report a difference when, in reality, the variations are the
                                   same?"), 
                          sliderInput(
                            inputId = "t_test_alpha",
                            label = div(style='width:350px;',
                                        div(style='float:left;', 'Not Important'),
                                        div(style='float:right;', 'Very Important')),
                            min = 50,
                            max = 99,
                            value = 95,
                            post = "%"
                          )
                   ),
                   
                   # 5. Beta Options 
                   column(4,
                          h4("5. Select Confidence (1-\u03B2)"), 
                          br(), 
                          # step 1
                          helpText("How important is it that you do not erroneously 
                          report NO difference when, in reality, there is a difference 
                                   between the variations?"),
                          sliderInput(
                            inputId = "t_test_beta",
                            label = div(style='width:350px;',
                                        div(style='float:left;', 'Not Important'),
                                        div(style='float:right;', 'Very Important')),
                            min = 50,
                            max = 99,
                            value = 80,
                            post = "%"
                          )
                   )
                 ),
                 
                 # Page 2 Row 3 
                 fluidRow(
                   column(
                     12, 
                     h3("Output results: the Minimum Sample Size"), 
                     br(), 
                     h4("The number of visit(or)s should be at least:"),
                     h1(
                       style = "text-align: center;",
                       textOutput("tTestSampleSizeBox", inline=TRUE),
                       span(style="display: inline-block; font-size:40px;", "per variation")
                     ),
                     h2(
                       style = "text-align: center;",
                       textOutput("tTestTotalVisitors", inline=TRUE)
                     ),
                     h4("This is the number of visitors required to detect a change in the
                          conversion rate from the baseline (%) to (1+lift) x basline (%).")
                   )
                 ),
                 
                 # Page 2 Row 4 
                 fluidRow(
                   downloadButton(
                     "downloadDataT",
                     label = "Download the t test result"
                   )
                 )
               )
    )
  )
) 



