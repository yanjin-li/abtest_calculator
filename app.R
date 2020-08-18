# Shiny Initializations --------------------------------------------------------
setwd("/data") 

# load packages 
pacman::p_load(
  shinydashboard,
  shiny, dplyr, here, 
  glue, lubridate
)



# UI Designs -------------------------------------------------------------------
# sidebar 
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem(
      "Proportion Test (CTR, etc.)", 
      tabName = "prop_test", 
      icon = icon("percent")
    ),
    menuItem(
      "t-Test (FQ28, etc.)", 
      tabName = "t_test", 
      icon = icon("hourglass-half")
    )
  )
)

body <- dashboardBody(
  
  # Tab 1: Proportion Test (CTR, CVR, etc.)
  tabItems(
    
    tabItem(
      tabName = "prop_test",
      
      fluidRow(
        # 1. Baseline CVR and Lift %  
        box(
          "Step 1: Enter the baseline conversion rate for the page, experience, and audience 
        you hope to impact (e.g., enter “5” for “5%”):",
          numericInput(
            inputId = "prop_test_baseline", 
            label = "Baseline converstion rate (%):",
            value = 15.0
          ),
          "Step 2: Enter the estimated lift percentage you would need to see in order to make 
        a decision (positive or negative):",
          numericInput(
            inputId = "prop_test_min_effect", 
            label = "Expected lift percentage (%):",
            value = 1.0
          ), 
          title = "1. Baseline Conversion Rate and Estimated Life %", 
          solidHeader = FALSE,
          status = "primary",
          height = 300
        ),
        
        # 2. Traffic Volume and # of Variations
        box(
          "How many visit(or)s do you get to the experience, on average, over the 
            course of 30 days?",
          numericInput(
            inputId = "prop_test_traffic", 
            label = "Traffic (Two Weeks User Count):",
            value = 10000
          ),
          "How many total variations are you testing, including the control (e.g.,
            a standard A/B test would be “2”)?",
          numericInput(
            inputId = "prop_test_variations", 
            label = "Number of Variations:",
            value = 2
          ), 
          title = "2. Traffic Volume and # of Variations (Groups)", 
          solidHeader = FALSE,
          status = "primary",
          height = 300
        )
      ),
      
      
      fluidRow(
        # 3. Tail Options 
        box(
          "Is your hypothesis directional (e.g., you expect the conversion rate 
            to increase) or non-directional (e.g., you expect the challenger to 
            be different, but you have no evidence to support the challenger as 
            better)?", br(), 
          selectInput(
            inputId = "prop_test_tail_option", 
            label = "Test Tail Option:",
            choices = c(
              "Two-side (A non-directional hypothesis: B = A)" = "two.sided",
              "One-side (A directional hypothesis: B > or < A)" = "one.sided"
            )
          ),
          #"Note: Results within your testing tool may vary if you select one-tailed 
          #  and your testing tool uses two-tailed and vice versa.",
          title = "3. Select 1-Tailed vs. 2-Tailed", 
          solidHeader = FALSE,
          status = "primary",
          width = 4,
          height = 230
        ),
        
        # 4. Alpha 
        box(
          "How important is it that you do not erroneously report a difference 
          when, in reality, the variations are the same?", br(), 
          sliderInput(
            inputId = "prop_test_alpha", 
            label = div(style='width:350px;',
                        div(style='float:left;', 'Not Important'),
                        div(style='float:right;', 'Very Important')),
            min = 50,
            max = 99,
            value = 95,
            post = "%"
          ),
          #"This is the statistical confidence. The higher you set the statistical 
          #confidence, the less likely the statistical results will return a false 
          #difference (aka, a false positive or a Type I error).", 
          title = "4. Select Confidence (1-\u03B1)", 
          solidHeader = FALSE,
          status = "primary",
          width = 4,
          height = 230
        ),
        
        
        # 5. Beta  
        box(
          "How important is it that you do not erroneously report NO difference 
          when, in reality, there is a difference between the variations?", br(), 
          sliderInput(
            inputId = "prop_test_beta", 
            label = div(style='width:350px;',
                        div(style='float:left;', 'Not Important'),
                        div(style='float:right;', 'Very Important')),
            min = 50,
            max = 99,
            value = 80,
            post = "%"
          ),
          #"The higher you set the statistical power, the greater your likelihood 
          #of detecting a real difference if one exists and the less likely you 
          #will return a false “no difference” (aka, a false negative or a Type 
          #II error).", 
          title = "4. Select Confidence (1-\u03B2)", 
          solidHeader = FALSE,
          status = "primary",
          width = 4,
          height = 230
        )
      ),
      
      fluidRow(
        box(
          "The number of visit(or)s should be at least:",
          h1(
            style = "text-align: center;", 
            textOutput("propTestSampleSizeBox", inline=TRUE), 
            span(style="display: inline-block; font-size:40px;", "per variation")
          ),
          h2(
            style = "text-align: center;", 
            textOutput("propTestTotalVisitors", inline=TRUE)
          ),
          "This is the number of visitors required to detect a change in the 
            conversion rate from the baseline (%) to (1+lift) x basline (%).",
          title = "Minimum Sample Size (Proportion Test)", 
          solidHeader = FALSE,
          #status = "success",
          background = "blue",
          width = 12,
          height = 230
        )
      ),
      fluidRow(
        downloadButton(
          "downloadDataProp",
          label = "Download the proportion test result"
        )
      )
    ),
    
    # Tab 2: t-test 
    tabItem(
      tabName = "t_test",
      
      fluidRow(
        # 1. Baseline CVR and Lift %  
        box(
          "Step 1: Enter the number of active users (usually in two weeks periods):",
          numericInput(
            inputId = "t_test_user_count", 
            label = "Number of active users:",
            value = 9566078
          ),
          "Step 2: Enter the mean of the metric of interest:",
          numericInput(
            inputId = "t_test_mean", 
            label = "Mean value of the metric:",
            value = 3.614
          ), 
          "Step 3: Enter the standard deviation of the metric:",
          numericInput(
            inputId = "t_test_sd", 
            label = "Standard deviation value of the metric:",
            value = 2.743
          ), 
          title = "1. Baseline Metrics Information", 
          solidHeader = FALSE,
          status = "warning",
          height = 330
        ),
        
        # 2. Traffic Volume and # of Variations
        box(
          "Step 4: Enter the estimated lift percentage you would need to see in order to make 
        a decision (positive or negative):",
          numericInput(
            inputId = "t_test_min_effect", 
            label = "Expected lift (%):",
            value = 1
          ),
          "Step 5: Enter the number of total variations are you testing, including the control (e.g.,
            a standard A/B test would be “2”)?",
          numericInput(
            inputId = "t_test_variations", 
            label = "Number of Variations:",
            value = 2
          ), 
          title = "2. Expected Life % and # of Variations (Groups)", 
          solidHeader = FALSE,
          status = "warning",
          height = 330
        )
      ),
      
      fluidRow(
        # 3. Tail Options 
        box(
          "Is your hypothesis directional (e.g., you expect the conversion rate 
            to increase) or non-directional (e.g., you expect the challenger to 
            be different, but you have no evidence to support the challenger as 
            better)?", br(), 
          selectInput(
            inputId = "t_test_tail_option", 
            label = "Test Tail Option:",
            choices = c(
              "Two-side (A non-directional hypothesis: B = A)" = "two.sided",
              "One-side (A directional hypothesis: B > or < A)" = "one.sided"
            )
          ),
          #"Note: Results within your testing tool may vary if you select one-tailed 
          #  and your testing tool uses two-tailed and vice versa.",
          title = "3. Select 1-Tailed vs. 2-Tailed", 
          solidHeader = FALSE,
          status = "warning",
          width = 4,
          height = 210
        ),
        
        # 4. Alpha 
        box(
          "How important is it that you do not erroneously report a difference 
          when, in reality, the variations are the same?", br(), 
          sliderInput(
            inputId = "t_test_alpha", 
            label = div(style='width:350px;',
                        div(style='float:left;', 'Not Important'),
                        div(style='float:right;', 'Very Important')),
            min = 50,
            max = 99,
            value = 95,
            post = "%"
          ),
          title = "4. Select Confidence (1-\u03B1)", 
          solidHeader = FALSE,
          status = "warning",
          width = 4,
          height = 210
        ),
        
        
        # 5. Beta  
        box(
          "How important is it that you do not erroneously report NO difference 
          when, in reality, there is a difference between the variations?", br(), 
          sliderInput(
            inputId = "t_test_beta", 
            label = div(style='width:350px;',
                        div(style='float:left;', 'Not Important'),
                        div(style='float:right;', 'Very Important')),
            min = 50,
            max = 99,
            value = 80,
            post = "%"
          ),
          title = "4. Select Confidence (1-\u03B2)", 
          solidHeader = FALSE,
          status = "warning",
          width = 4,
          height = 210
        )
      ),
      
      # t-test sample size
      fluidRow(
        box(
          "The number of visit(or)s should be at least:",
          h1(
            style = "text-align: center;",
            textOutput("tTestSampleSizeBox", inline=TRUE),
            span(style="display: inline-block; font-size:40px;", "per variation")
          ),
          h2(
            style = "text-align: center;",
            textOutput("tTestTotalVisitors", inline=TRUE)
          ),
          "This is the number of visitors required to detect a change in the 
            conversion rate from the baseline (%) to (1+lift) x basline (%).",
          title = "Minimum Sample Size (t-Test)", 
          solidHeader = FALSE,
          background = "yellow", 
          #status = "success",
          width = 12,
          height = 230
        )
      ),
      fluidRow(
        downloadButton(
          "downloadDataT",
          label = "Download the t test result"
        )
      )
    ) 
  )
) 



# UI ---------------------------------------------------------------------------
ui <- dashboardPage(
  skin = "black",
  dashboardHeader(title = "A/B Test Sample Size"),
  sidebar,
  body
)



# Server -----------------------------------------------------------------------
server <- function(input, output) {
  # Reactive function to do the actual sample size calculation. This has error
  # checking baked in. And, it returns a number or a string
  calc_prop_results <- reactive({
    tryCatch(
      {
        # Calculate the result
        calc_n <- power.prop.test(p1 = input$prop_test_baseline/100,
                                  p2 = (input$prop_test_baseline/100) * (1 + input$prop_test_min_effect/100),
                                  sig.level = (100 - input$prop_test_alpha)/100,
                                  power = input$prop_test_beta/100,
                                  alternative = input$prop_test_tail_option)
        
        # Extract the sample size from the returned list and return it
        return(round(calc_n$n))
      }#,
      # error = function(e){
      #   return("N/A")
      # }
    )
  })
  
  calc_t_results <- reactive({
    tryCatch(
      {
        # Calculate the result
        calc_n <- power.t.test(
          delta = input$t_test_min_effect/100*input$t_test_mean, 
          sd = input$t_test_sd,
          sig.level = (100 - input$t_test_alpha)/100,
          power = input$t_test_beta/100,
          alternative = input$t_test_tail_option
        )
        
        # Extract the sample size from the returned list and return it
        return(round(calc_n$n))
      }#,
      # error = function(e){
      #   return("N/A")
      # }
    )
  })
  
  comma_format <- function(x){
    format(x, big.mark=",", scientific = FALSE)
  }
  
  filename <- function(type){
    glue("{type}-data-{date}.csv",
         type = type,
         date = Sys.Date())
  }
  
  
  
  # proportion test
  output$propTestSampleSizeBox <- renderText({
    comma_format(calc_prop_results())
  })
  
  output$propTestTotalVisitors <- renderText({
    glue(
      "({size} total visitors)",
      size = comma_format(
        calc_prop_results()*input$prop_test_variations
      )
    )
  })
  
  # t-test
  output$tTestSampleSizeBox <- renderText({
    comma_format(calc_t_results())
  })
  
  output$tTestTotalVisitors <- renderText({
    glue(
      "({size} total visitors, which affects {pctg} % of the total targets.",
      size = comma_format(
        calc_t_results()*input$t_test_variations
      ),
      pctg = round(
        calc_t_results()*
          input$t_test_variations/input$t_test_user_count, 
        digits = 4
      )*100
    )
  })
  
  # download function: prop.test
  output$downloadDataProp <- downloadHandler(
    filename = function() {
      paste("proportion-test-data-", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      data = data.frame(
        date = Sys.Date(), 
        test_type = "proportion test",
        baseline_cvr = input$prop_test_baseline,
        expected_lift_percentage = input$prop_test_min_effect,
        n_variations = input$prop_test_variations,
        test_tail_type = input$prop_test_tail_option,
        confidence_level = input$prop_test_alpha,
        power = input$prop_test_beta,
        min_sample_size = calc_prop_results(),
        total_variations_size = calc_prop_results()*input$prop_test_variations)
      
      write.csv(data, file)
    }
  )
  
  # download function: prop.test
  output$downloadDataT <- downloadHandler(
    filename = function() {
      paste("t-test-data-", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      data = data.frame(
        date = Sys.Date(), 
        test_type = "t-test",
        n_users = input$t_test_user_count,
        metric_mean = input$t_test_mean,
        metric_sd = input$t_test_sd,
        expected_lift_percentage = input$t_test_min_effect,
        n_variations = input$t_test_variations,
        test_tail_type = input$t_test_tail_option,
        confidence_level = input$t_test_alpha,
        power = input$t_test_beta,
        min_sample_size = calc_t_results(),
        total_variations_size = calc_t_results()*input$t_test_variations,
        affected_targets_percentage = round(calc_t_results()*input$t_test_variations/input$t_test_user_count, digits = 4)
      )
      
      write.csv(data, file)
    }
  )
  
}

data.frame(a = "quote", b = pi)



# Run the App ------------------------------------------------------------------
shinyApp(ui, server)
